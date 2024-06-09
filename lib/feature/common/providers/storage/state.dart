part of 'provider.dart';

@freezed
class StorageState with _$StorageState {
  const factory StorageState({
    @Default(null) StorageEntity? activeStorage,
    @Default([]) List<BucketEntity> buckets,
    @Default(ContentStatus.loading) ContentStatus loaderPage,
    @Default(ContentStatus.loading) ContentStatus loaderScroll,
  }) = _StorageState;

  const StorageState._();

  StorageInterface get roflit {
    return switch (activeStorage!.storageType) {
      StorageType.yxCloud => S3Roflit.yandex(
          accessKey: activeStorage!.accessKey,
          secretKey: activeStorage!.secretKey,
          region: activeStorage!.region,
        ),
      StorageType.vkCloud => S3Roflit.vkontakte(
          accessKey: activeStorage!.accessKey,
          secretKey: activeStorage!.secretKey,
        ),
    };
  }

  StorageSerializerInterface get serizalizer {
    return StorageSerializer.serializaer(activeStorage!.storageType);
  }
}
