library s3client;

import 'vk_cloud/vk_cloud.dart';
import 'yandex_cloud/yandex_cloud.dart';

abstract final class S3Client {
  static YandexCloud yandex({
    required String accessKey,
    required String secretKey,
  }) {
    return YandexCloud(
      accessKey: accessKey,
      secretKey: secretKey,
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
