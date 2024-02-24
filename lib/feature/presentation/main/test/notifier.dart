import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifier.freezed.dart';
part 'notifier.g.dart';
part 'state.dart';

@riverpod
final class TestNotifier extends _$TestNotifier {
  @override
  TestState build() {
    print('>>>> update TestNotifier');
    return const TestState();
  }

  Future<void> actionPlus() async {
    state = state.copyWith(
      counter: state.counter + 1,
    );
  }

  Future<void> actionMinus() async {
    // final bloc = ref.read(apiClientServiceProvider);
    // ref.read(apiClientServiceProvider).api();
    // _apiClientService.api();
    state = state.copyWith(
      counter: state.counter - 1,
    );
  }
}
