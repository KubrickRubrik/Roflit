import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/data/service.dart';
import 'package:roflit/middleware/utils/logger.dart';
import 'state.dart';
part 'notifier.g.dart';

@riverpod
final class MainNotifier extends _$MainNotifier {
  late final _apiClientService = ref.read(apiClientServiceProvider);

  @override
  MainState build() {
    // _apiClientService.api();
    // ref.read(apiClientServiceProvider);
    ref.listen(mainNotifierProvider, (previous, next) {
      return logger.info('>>>> used Listener');
    });
    ref.onDispose(() {});
    logger.info('>>>> update MainNotifier');
    return const MainState();
  }

  Future<void> action() async {
    // ref.read(apiClientServiceProvider).api();
    _apiClientService.api();
  }
}
