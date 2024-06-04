import 'dart:typed_data';

import 'package:s3roflit/yandex_cloud/config/constants.dart';
import 'package:s3roflit/yandex_cloud/requests/parameters/object_parameters.dart';

abstract interface class StorageInterface {
  StorageBucketRequestsInterface get buckets;
  StorageObjectRequestsInterface get object;
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

  StorageBucketRequestsDtoInterface delete({
    required String bucketName,
    Map<String, String> headers = const {},
  });

  StorageBucketRequestsDtoInterface getObjects({
    required String bucketName,
    Map<String, String> headers = const {},
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
  Uint8List? get body;
}
