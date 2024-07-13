part of 'provider.dart';

@freezed
class FileManagerState with _$FileManagerState {
  const factory FileManagerState({
    @Default(null) StorageEntity? activeStorage,
    @Default([]) List<ObjectEntity> objects,
    @Default(ContentStatus.loading) ContentStatus loaderPage,
  }) = _FileManagerState;
}
