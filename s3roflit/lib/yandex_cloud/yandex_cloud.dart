import 'config/constants.dart';
import 'config/s3/dto.dart';
import 'requests/buckets.dart';
import 'requests/objects.dart';

final class YandexCloud {
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

  YandexRequestsBucket get buckets => YandexRequestsBucket(_access);
  YandexRequestsObject get object => YandexRequestsObject(_access);
}
