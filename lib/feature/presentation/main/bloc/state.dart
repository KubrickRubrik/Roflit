part of 'notifier.dart';

@freezed
class MainState with _$MainState {
  const factory MainState.loading() = MainLoadingState;

  const factory MainState.loaded({
    @Default(0) int counter,
    @Default([]) List<int> list,
  }) = MainLoadedState;
}
