part of 'provider.dart';

@freezed
class BucketsState with _$BucketsState {
  const factory BucketsState({
    @Default(null) StorageEntity? activeStorage,
    @Default([]) List<BucketEntity> buckets,
    @Default(ContentStatus.loading) ContentStatus loaderPage,
    @Default(ContentStatus.loading) ContentStatus loaderScroll,
  }) = _BucketsState;
}
