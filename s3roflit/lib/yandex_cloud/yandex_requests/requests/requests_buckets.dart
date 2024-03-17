import 'package:s3roflit/yandex_cloud/config/constants.dart';
import 'package:s3roflit/yandex_cloud/config/dto.dart';
import 'package:s3roflit/yandex_cloud/config/headers.dart';

final class YandexRequestsBucket {
  final YandexHeaders _header;
  YandexRequestsBucket({required YandexHeaders header}) : _header = header;

  /// Returns a list of buckets available to the user.
  YandexCloudDTO getListBuckets({
    Map<String, String> headers = const {},
  }) {
    return YandexCloudDTO(
      url: '/',
      typeRequest: RequestType.get,
      headers: _header.get(
        canonicalRequest: 'GET / HTTP/2',
        headers: headers,
      ),
    );
  }

  /// Allows you to check:
  /// - Does the bucket exist?
  /// - Does the user have sufficient rights to access the bucket.
  /// The response can only contain general headers
  /// https://cloud.yandex.ru/ru/docs/storage/s3/api-ref/common-request-headers.
  YandexCloudDTO getMetaBucket({
    required String bucketName,
    Map<String, String> headers = const {},
  }) {
    return YandexCloudDTO(
      url: '/$bucketName',
      typeRequest: RequestType.get,
      headers: _header.get(
        canonicalRequest: 'GET /$bucketName HTTP/2',
        headers: headers,
      ),
    );
  }

  /// Returns a list of objects in the bucket.
  /// Pagination is used; in one request you can get a list of no longer than 1000 objects.
  /// If there are more objects, then you need to run several queries in a row.
  YandexCloudDTO getListObject({
    required String bucketName,
    Map<String, String> headers = const {},
    ListObjectParameters? url,
  }) {
    return YandexCloudDTO(
      url: '/$bucketName?list-type=2${url?.url}}',
      typeRequest: RequestType.get,
      headers: _header.get(
        canonicalRequest: 'GET /$bucketName?list-type=2${url?.url}} HTTP/2',
        headers: headers,
      ),
    );
  }
}

final class ListObjectParameters {
  /// Used to get the next part of the list if all the results do not fit into one response.
  /// To get the next part of the list, use the `NextContinuationToken value` from the previous answer.
  final String? continuationToken;

  /// The maximum number of elements in the response.
  /// This option should be used if you need to receive fewer than 1000 items in a single response.
  /// If more keys fall under the selection criteria than fit in the search results, then the
  /// answer contains `<IsTruncated>true</IsTruncated>`.
  final int? maxKeys;

  /// Separator character.
  /// If specified, Object Storage treats the key as a file path, with directories separated by a
  ///  delimiter character. In response to the request, the user will see a list of files and
  /// directories in the bucket. Files will be displayed in Contents elements,
  /// and directories in CommonPrefixes elements.

  /// If the prefix parameter is also specified in the request, then Object Storage will return
  /// a list of files and directories in the prefix directory.
  final String? delimiter;

  /// Object Storage will only select keys that start with prefix.
  final String? prefix;

  /// The key to start listing with.
  final String? startAfter;

  ListObjectParameters({
    required this.continuationToken,
    required this.maxKeys,
    required this.delimiter,
    required this.prefix,
    required this.startAfter,
  });

  String get _continuationUrl =>
      (continuationToken?.isNotEmpty == true) ? '&continuation-token=$continuationToken' : '';

  String get _maxKeysUrl => (maxKeys != null && maxKeys! > 0) ? '&max-keys=$maxKeys' : '';

  String get _delimiterUrl => (delimiter?.isNotEmpty == true) ? '&delimiter=$delimiter' : '';

  String get _prefixUrl => (prefix?.isNotEmpty == true) ? '&prefix=$prefix' : '';

  String get _startAfterUrl => (startAfter?.isNotEmpty == true) ? '&start-after=$startAfter' : '';

  String get url => '$_continuationUrl$_maxKeysUrl$_delimiterUrl$_prefixUrl$_startAfterUrl';
}
