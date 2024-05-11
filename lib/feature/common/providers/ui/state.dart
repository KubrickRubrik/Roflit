part of 'provider.dart';

@freezed
class UiState with _$UiState {
  const factory UiState({
    @Default(false) bool isDisplayedAccountMenu,
    @Default(false) bool isDisplayedStorageMenu,
    @Default(false) bool isDisplayedMainMenu,
  }) = UiActionState;
}
