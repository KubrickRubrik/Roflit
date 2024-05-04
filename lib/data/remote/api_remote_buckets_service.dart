import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/config/account.dart';
import 'package:roflit/helper_remove/main/bloc/notifier.dart';
import 'package:s3roflit/s3roflit.dart';
import 'package:xml/xml.dart';

import 'client.dart';

part 'api_remote_buckets_service.g.dart';

@riverpod
ApiRemoteBucketsService apiRemoteBucketsService(ApiRemoteBucketsServiceRef ref) {
  return ApiRemoteBucketsService();
}

final class ApiRemoteBucketsService {
  final client = ApiRemoteClient();
  final yxClient = S3Roflit.yandex(
    accessKey: ServiceAccount.accessKey,
    secretKey: ServiceAccount.secretKey,
  );

  Future<List<Bucket>> getBuckets() async {
    final request = yxClient.buckets.getList();

    final result = await client.smRequest(request);
    if (result.failed) {
      return [];
    }

    try {
      final listBucket = result.success!.findAllElements('Bucket').toList();
      if (listBucket.isEmpty) return [];

      final buckets = List.generate(listBucket.length, (index) {
        final bucket = listBucket[index];
        return Bucket(
          name: bucket.findElements('Name').single.innerText,
          creationDate: bucket.findElements('CreationDate').single.innerText,
        );
      });
      buckets.sort((a, b) => a.name.compareTo(b.name));
      return buckets;
    } catch (e) {
      return [];
    }
  }

  Future<List<BucketObject>> getBucketObjects({required String bucketName}) async {
    final request = yxClient.buckets.getListObject(bucketName: bucketName);

    final result = await client.smRequest(request);
    if (result.failed) {
      return [];
    }

    try {
      final listObjects = result.success!.findAllElements('Contents').toList();
      if (listObjects.isEmpty) return [];

      final objects = List.generate(listObjects.length, (index) {
        final object = listObjects[index];
        return BucketObject(
          key: object.findElements('Key').single.innerText,
          size: object.findElements('Size').single.innerText,
          lastModified: object.findElements('LastModified').single.innerText,
        );
      });
      objects.sort((a, b) => a.key.compareTo(b.key));
      return objects;
    } catch (e) {
      return [];
    }
  }
}
