import 'package:s3roflit/interface/storage_interface.dart';
import 'package:s3roflit/yandex_cloud/config/constants.dart';
import 'package:s3roflit/yandex_cloud/config/s3/dto.dart';
import 'package:s3roflit/yandex_cloud/requests/buckets.dart';
import 'package:s3roflit/yandex_cloud/requests/objects.dart';

final class VKCloud implements StorageInterface {
  final YandexAccess _access;

  VKCloud({
    required String accessKey,
    required String secretKey,
    String host = YCConstant.host,
    String region = YCConstant.region,
  }) : _access = YandexAccess(
          accessKey: accessKey,
          secretKey: secretKey,
          host: host,
          region: region,
        );

  @override
  StorageBucketRequestsInterface get buckets => YandexRequestsBucket(_access);

  @override
  StorageObjectRequestsInterface get object => YandexRequestsObject(_access);
}
