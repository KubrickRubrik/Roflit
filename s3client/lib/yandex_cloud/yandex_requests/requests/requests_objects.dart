import 'package:s3client/yandex_cloud/config/dto.dart';
import 'package:s3client/yandex_cloud/config/headers.dart';

final class YandexRequestsObject {
  final YandexHeaders _header;
  YandexRequestsObject({required YandexHeaders header}) : _header = header;

  YandexCloudDTO listObject({
    required String bucketName,
    Map<String, String> headers = const {},
    String url = '',
  }) {
    return YandexCloudDTO(
      url: '$bucketName?list-type=2$url}',
      typeRequest: YandexRequestType.get,
      headers: _header.get(
        canonicalRequest: 'GET /$bucketName?list-type=2 HTTP/2',
        headers: headers,
      ),
    );
  }
}
