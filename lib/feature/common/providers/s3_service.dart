import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/entity/storage.dart';
import 'package:s3roflit/s3roflit.dart';
import 'package:s3roflit/yandex_cloud/yandex_cloud.dart';

part 's3_service.g.dart';

@riverpod
S3Service s3Service(S3ServiceRef ref) {
  return S3Service(
      // sessionBloc: ref.watch(sessionBlocProvider.notifier),
      // apiLocalClient: ref.watch(diServiceProvider).apiLocalClient,
      );
}

final class S3Service {
  YandexCloud? storage;

  void setStorage(StorageEntity currentStorage) {
    if (currentStorage.storageType.isYandexCloud) {
      storage = S3Roflit.yandex(
        accessKey: currentStorage.accessKey,
        secretKey: currentStorage.secretKey,
        region: currentStorage.region,
      );
    }
  }
}
