import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/data/service.dart';
import 'package:roflit/feature/common/async_state.dart';
import 'package:roflit/feature/presentation/main/test/notifier.dart';
import 'package:roflit/middleware/utils/logger.dart';

part 'notifier.freezed.dart';
part 'notifier.g.dart';
part 'state.dart';

@riverpod
final class MainNotifier extends _$MainNotifier {
  // late final ApiClientService _apiClientService = ref.read(apiClientServiceProvider);

  @override
  AsyncState<MainState> build() {
    // ref.listenSelf((previous, next) {
    // if (next.counter == 2) {
    //   ref.read(testNotifierProvider.notifier).actionPlus();
    // }
    // });
    print('>>>> update MainNotifier');
    // return const MainState.loading();
    return const AsyncState.data(MainState());
  }

  Future<void> actionPlus() async {
    // final bloc = ref.read(apiClientServiceProvider);
    // if (state is MainLoadedState) {
    //   state as MainLoadedState;

    // state = (state as MainLoadedState).copyWith(counter: (state as MainLoadedState).counter + 1);
    // }
    // state = MainState.loaded();
    // state = state.copyWith(
    //   counter: state.counter + 1,
    // );
  }

  Future<void> actionMinus() async {
    // final bloc = ref.read(apiClientServiceProvider);
    state = const AsyncState.loading(false);
    state = const AsyncState.error(false);
    // state = AsyncState.data(
    //   state.
    // );
    // state = const AsyncValue.loading();
    // ref.read(apiClientServiceProvider).api();
    // _apiClientService.api();
    // state = state.maybeWhen(
    //     loaded: (counter) {
    //       return state as
    //     },
    //     orElse: () {});
    // state = state.copyWith(
    //   counter: state.counter - 1,
    // );
  }
}
