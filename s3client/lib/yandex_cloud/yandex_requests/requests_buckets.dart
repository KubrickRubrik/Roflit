import 'package:s3client/yandex_cloud/config/dto.dart';
import 'package:s3client/yandex_cloud/config/headers.dart';

final class YandexRequestsBucket {
  final YandexHeaders _header;
  YandexRequestsBucket({required YandexHeaders header}) : _header = header;

  YandexCloudDTO listBuckets({
    required String bucketName,
    String url = '',
    Map<String, String> headers = const {},
  }) {
    return YandexCloudDTO(
      url: '$bucketName?list-type=2$url}',
      headers: _header.get(
        canonicalRequest: 'GET /$bucketName?list-type=2 HTTP/2',
        headers: headers,
      ),
    );
  }
}
