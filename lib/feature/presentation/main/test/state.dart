part of 'notifier.dart';

@freezed
class TestState with _$TestState {
  const factory TestState({
    @Default(0) int counter,
  }) = _TestState;
}
