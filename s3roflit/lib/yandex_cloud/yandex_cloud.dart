import 'package:s3roflit/interface/storage_interface.dart';

import 'config/constants.dart';
import 'config/s3/dto.dart';
import 'requests/buckets.dart';
import 'requests/objects.dart';

final class YandexCloud implements StorageInterface {
  final YandexAccess _access;

  YandexCloud({
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
  String get host => 'https://${_access.host}';

  @override
  StorageBucketRequestsInterface get buckets => YandexRequestsBucket(_access);

  @override
  StorageObjectRequestsInterface get object => YandexRequestsObject(_access);
}
