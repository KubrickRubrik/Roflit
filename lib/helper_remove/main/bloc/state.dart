part of 'notifier.dart';

@freezed
class MainState with _$MainState {
  const factory MainState.loading() = MainLoadingState;

  const factory MainState.loaded({
    @Default(0) int selectedBucket,
    @Default([]) List<Bucket> buckets,
  }) = MainLoadedState;
}

@freezed
class Bucket with _$Bucket {
  const factory Bucket({
    required String name,
    required String creationDate,
    @Default(false) bool loading,
    @Default([]) List<BucketObject> objects,
  }) = _Bucket;
}

@freezed
class BucketObject with _$BucketObject {
  const factory BucketObject({
    required String key,
    required String size,
    required String lastModified,
  }) = _BucketObject;
}
