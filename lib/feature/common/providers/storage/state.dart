part of 'provider.dart';

@freezed
class StorageState with _$StorageState {
  const factory StorageState({
    @Default(null) StorageEntity? activeStorage,
    @Default([]) List<BucketEntity> buckets,
    @Default(ContentStatus.empty) ContentStatus loading,
  }) = _StorageState;
}
