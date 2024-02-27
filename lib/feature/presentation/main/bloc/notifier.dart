import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/data/service.dart';
import 'package:roflit/feature/common/async_state.dart';
import 'package:roflit/feature/presentation/main/test/notifier.dart';
import 'package:roflit/middleware/utils/logger.dart';
import 'package:roflit/middleware/zip_utils.dart';

part 'notifier.freezed.dart';
part 'notifier.g.dart';
part 'state.dart';

@riverpod
final class MainNotifier extends _$MainNotifier {
  late final _apiClientService = ref.read(apiClientServiceProvider);

  @override
  MainState build() {
    // ref.listenSelf((previous, next) {
    // if (next.counter == 2) {
    //   ref.read(testNotifierProvider.notifier).actionPlus();
    // }
    // });
    print('>>>> update MainNotifier');
    // return const MainState.loading();
    return const MainState.loaded();
  }

  Future<void> getData() async {
    // state = const AsyncState.loading();
    await _apiClientService.test();
    // await Await.second(3);
    // state = const AsyncState.error(1);
  }

  Future<void> setLoading() async {
    // state = const AsyncState.loading();
  }

  Future<void> setStop() async {
    // state = const AsyncState.error(1);
    if (state is MainLoadedState) {
      final a = state as MainLoadedState;
      state = a.copyWith(
        list: a.list..firstWhere((e) => e == 5).isEven,
      );
    }
  }
}
