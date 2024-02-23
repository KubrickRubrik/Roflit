import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'state.dart';
part 'notifier.g.dart';

@riverpod
final class MainNotifier extends _$MainNotifier {
  @override
  dynamic build() {
    return const MainState();
  }
}
