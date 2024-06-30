import 'package:s3roflit/interface/storage_interface.dart';
import 'package:s3roflit/src/config/s3/dto.dart';
import 'package:s3roflit/src/config/s3/request_type.dart';
import 'package:s3roflit/src/config/s3/s3config.dart';
import 'package:s3roflit/src/requests/parameters/object_parameters.dart';

final class YandexRequestsObject implements StorageObjectRequestsInterface {
  final YandexAccess _access;
  YandexRequestsObject(
    YandexAccess access,
  ) : _access = access;

  /// Returns an object from Object Storage.
  @override
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

  @override
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

  @override
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

  @override
  StorageBucketRequestsDtoInterface deleteMultiple({
    required String bucketName,
    required String objectKeysXmlDoc,
    DeleteObjectHeadersParameters headers = const DeleteObjectHeadersParameters(),
  }) {
    final canonicalRequest = '/$bucketName?delete';
    const requestType = RequestType.post;

    final s3Config = S3Config(
      access: _access,
      canonicalRequest: canonicalRequest,
      requestType: requestType,
      // bucketName: bucketName,
      headers: headers.getHeaders(inputStringDoc: objectKeysXmlDoc),
      requestBody: objectKeysXmlDoc,
    );
    return s3Config.signing();
  }
}
