import 'package:s3roflit/yandex_cloud/config/constants.dart';
import 'package:s3roflit/yandex_cloud/config/s3/dto.dart';
import 'package:s3roflit/yandex_cloud/config/s3/s3config.dart';

import 'parameters/object_parameters.dart';

final class YandexRequestsObject {
  final YandexAccess _access;
  YandexRequestsObject(
    YandexAccess access,
  ) : _access = access;

  /// Returns an object from Object Storage.
  YandexRequestDto get({
    required String bucketName,
    required String objectKey,
    Map<String, String> headers = const {},
    ObjectGetParameters queryParameters = const ObjectGetParameters.empty(),
  }) {
    final canonicalRequest = '/$bucketName/$objectKey';
    const requestType = RequestType.get;

    final s3Config = S3Config(
      access: _access,
      canonicalRequest: canonicalRequest,
      canonicalQuerystring: queryParameters.url,
      requestType: requestType,
      headers: headers,
    );
    return s3Config.signing();
  }

  YandexRequestDto delete({
    required String bucketName,
    required String objectKey,
    Map<String, String> headers = const {},
  }) {
    final canonicalRequest = '/$bucketName/$objectKey';
    const requestType = RequestType.delete;

    final s3Config = S3Config(
      access: _access,
      canonicalRequest: canonicalRequest,
      requestType: requestType,
      headers: headers,
    );
    return s3Config.signing();
  }

  YandexRequestDto upload({
    required String bucketName,
    required String objectKey,
    required String body,
    required ObjectUploadHadersParameters headers,
  }) {
    final canonicalRequest = '/$bucketName/$objectKey';
    const requestType = RequestType.put;

    final s3Config = S3Config(
      access: _access,
      canonicalRequest: canonicalRequest,
      requestType: requestType,
      headers: headers.getHeaders,
      requestBody: body,
    );
    return s3Config.signing();
  }
}
