part of 'notifier.dart';

@freezed
class MainState with _$MainState {
  // const factory MainState.loading() = MainLoadingState;

  // const factory MainState.loaded({
  //   @Default(0) int counter,
  // }) = MainLoadedState;
  const factory MainState({
    @Default(0) int counter,
  }) = _MainState;
}

enum DataState {
  loading,
  loaded,
  error,
}
