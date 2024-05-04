library s3roflit;

import 'vk_cloud/vk_cloud.dart';
import 'yandex_cloud/config/constants.dart';
import 'yandex_cloud/yandex_cloud.dart';

abstract final class S3Roflit {
  static YandexCloud yandex({
    required String accessKey,
    required String secretKey,
    String region = YCConstant.region,
  }) {
    return YandexCloud(
      accessKey: accessKey,
      secretKey: secretKey,
      region: region,
    );
  }

  static VKCloud vkontakte({
    required String accessKey,
    required String secretKey,
  }) {
    return VKCloud(
      accessKey: accessKey,
      secretKey: secretKey,
    );
  }

  // static VKCloud custom({
  //   required String accessKey,
  //   required String secretKey,
  // }) {
  //   return CustomCloud(
  //     accessKey: accessKey,
  //     secretKey: secretKey,
  //   );
  // }
}
