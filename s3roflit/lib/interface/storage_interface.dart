import 'package:s3roflit/src/config/s3/request_type.dart';
import 'package:s3roflit/src/requests/parameters/bucket_parameters.dart';
import 'package:s3roflit/src/requests/parameters/object_parameters.dart';

abstract interface class StorageInterface {
  String get host;
  StorageBucketRequestsInterface get buckets;
  StorageObjectRequestsInterface get objects;
}

abstract interface class StorageBucketRequestsInterface {
  StorageBucketRequestsDtoInterface get({
    Map<String, String> headers = const {},
    String queryParameters = '',
  });

  StorageBucketRequestsDtoInterface getMeta({
    required String bucketName,
    Map<String, String> headers = const {},
    String queryParameters = '',
  });

  StorageBucketRequestsDtoInterface create({
    required String bucketName,
    Map<String, String> headers = const {},
  });

  StorageBucketRequestsDtoInterface delete({
    required String bucketName,
    Map<String, String> headers = const {},
  });

  StorageBucketRequestsDtoInterface getObjects({
    required String bucketName,
    Map<String, String> headers = const {},
    BucketListObjectParameters queryParameters = const BucketListObjectParameters.empty(),
  });
}

abstract interface class StorageObjectRequestsInterface {
  StorageBucketRequestsDtoInterface get({
    required String bucketName,
    required String objectKey,
    Map<String, String> headers = const {},
    ObjectGetParameters queryParameters = const ObjectGetParameters.empty(),
  });

  StorageBucketRequestsDtoInterface delete({
    required String bucketName,
    required String objectKey,
    Map<String, String> headers = const {},
  });

  StorageBucketRequestsDtoInterface deleteMultiple({
    required String bucketName,
    required String body,
    DeleteObjectHeadersParameters headers,
  });

  StorageBucketRequestsDtoInterface upload({
    required String bucketName,
    required String objectKey,
    required String body,
    required ObjectUploadHadersParameters headers,
  });
}

abstract interface class StorageBucketRequestsDtoInterface {
  Uri get url;
  Map<String, String> get headers;
  RequestType get typeRequest;
  Object? get body;
}
