part of 'provider.dart';

@freezed
class UiState with _$UiState {
  const factory UiState({
    @Default(false) bool isDisplayedAccountMenu,
    @Default(false) bool isDisplayedUploadConfigMenu,
    @Default(false) bool isDisplayedDownloadConfigMenu,
    @Default(false) bool isDisplayedStorageMenu,
    @Default(false) bool isDisplayedMainMenu,
    @Default(false) bool isDisplayBucketMenu,
    @Default(false) bool isDisplayObjectMenu,
    @Default(false) bool isDisplayedFileManagerMenu,
  }) = UiActionState;
}

enum RedirectMainMenuPage {
  accounts,
  login,
  account,
}
