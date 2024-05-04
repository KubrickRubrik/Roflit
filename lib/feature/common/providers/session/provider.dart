import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/feature/common/entity/profile.dart';
import 'package:roflit/feature/common/entity/session.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';
part 'state.dart';

@riverpod
final class SessionBloc extends _$SessionBloc {
  @override
  SessionState build() => const SessionState.init();

  Future<void> checkAuthentication() async {
    state = const SessionState.loading();
  }
}
