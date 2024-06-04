part of 'provider.dart';

@freezed
class StorageState with _$StorageState {
  const factory StorageState({
    @Default(null) StorageEntity? activeStorage,
    @Default([]) List<BucketEntity> buckets,
    @Default(ContentStatus.empty) ContentStatus loading,
  }) = _StorageState;

  const StorageState._();

  StorageInterface? get roflit {
    return switch (activeStorage?.storageType) {
      null => null,
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
}
