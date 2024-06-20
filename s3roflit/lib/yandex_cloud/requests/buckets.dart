import 'package:s3roflit/interface/storage_interface.dart';
import 'package:s3roflit/src/config/s3/dto.dart';
import 'package:s3roflit/src/config/s3/request_type.dart';
import 'package:s3roflit/src/config/s3/s3config.dart';
import 'package:s3roflit/src/requests/parameters/bucket_parameters.dart';

final class YandexRequestsBucket implements StorageBucketRequestsInterface {
  final YandexAccess _access;

  YandexRequestsBucket(
    YandexAccess access,
  ) : _access = access;

  /// Returns a list of buckets available to the user.
  @override
  YandexRequestDto get({
    Map<String, String> headers = const {},
    String queryParameters = '',
  }) {
    const canonicalRequest = '/';
    const requestType = RequestType.get;

    final s3Config = S3Config(
      access: _access,
      canonicalRequest: canonicalRequest,
      canonicalQuerystring: queryParameters,
      requestType: requestType,
      headers: headers,
    );

    return s3Config.signing();
  }

  /// Allows you to check:
  /// - Does the bucket exist?
  /// - Does the user have sufficient rights to access the bucket.
  /// The response can only contain general headers
  /// https://cloud.yandex.ru/ru/docs/storage/s3/api-ref/common-request-headers.
  @override
  YandexRequestDto getMeta({
    required String bucketName,
    Map<String, String> headers = const {},
    String queryParameters = '',
  }) {
    final canonicalRequest = '/$bucketName';
    const requestType = RequestType.get;

    final s3Config = S3Config(
      access: _access,
      canonicalRequest: canonicalRequest,
      canonicalQuerystring: queryParameters,
      requestType: requestType,
      headers: headers,
    );
    return s3Config.signing();
  }

  // YandexRequestDto createBucket({
  //   required String bucketName,
  //   Map<String, String> headers = const {},
  // }) {
  //   final canonicalRequest = '/$bucketName';
  //   const requestType = RequestType.put;

  //   final s3Config = S3Config(
  //     access: _access,
  //     canonicalRequest: canonicalRequest,
  //     requestType: requestType,
  //     headers: headers,
  //   );
  //   return s3Config.signing();
  // }

  @override
  YandexRequestDto delete({
    required String bucketName,
    Map<String, String> headers = const {},
  }) {
    final canonicalRequest = '/$bucketName';
    const requestType = RequestType.delete;

    final s3Config = S3Config(
      access: _access,
      canonicalRequest: canonicalRequest,
      requestType: requestType,
      headers: headers,
    );
    return s3Config.signing();
  }

  /// Returns a list of objects in the bucket.
  /// Pagination is used; in one request you can get a list of no longer than 1000 objects.
  /// If there are more objects, then you need to run several queries in a row.
  @override
  YandexRequestDto getObjects({
    required String bucketName,
    Map<String, String> headers = const {},
    BucketListObjectParameters queryParameters = const BucketListObjectParameters.empty(),
  }) {
    final canonicalRequest = '/$bucketName';
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
}
