part of 'provider.dart';

@freezed
class FileManagerState with _$FileManagerState {
  const factory FileManagerState({
    @Default(null) AccountEntity? account,
    @Default([]) List<BootloaderEntity> bootloaders,
    @Default([]) List<BootloaderEntity> copyBootloaders,
    @Default(ContentStatus.loading) ContentStatus loaderPage,
    @Default(FileManagerAction.addBootloader) FileManagerAction action,
  }) = _FileManagerState;
}

enum FileManagerAction {
  addBootloader,
  editBootloader;

  bool get isAddBootloader => this == addBootloader;
  bool get isEditBootloader => this == editBootloader;
}
