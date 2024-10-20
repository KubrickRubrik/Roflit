part of 'provider.dart';

@freezed
class ObjectsState with _$ObjectsState {
  const factory ObjectsState({
    @Default(null) StorageEntity? activeStorage,
    @Default([]) List<ObjectEntity> items,
    @Default(ContentStatus.loading) ContentStatus loaderPage,
    @Default(ContentStatus.loading) ContentStatus loaderScroll,
  }) = _ObjectsState;
}
