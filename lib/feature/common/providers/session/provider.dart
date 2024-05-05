import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/feature/common/entity/profile.dart';
import 'package:roflit/feature/common/entity/session.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';
part 'state.dart';

@riverpod
final class SessionBloc extends _$SessionBloc {
  // late final api = ref.read(diProvider).apiRemoteBucketService;

  @override
  SessionState build() => const SessionState.init();

  Future<void> checkAuthentication() async {
    // final api = ref.read(diProvider).apiRemoteBucketService;
    state = const SessionState.loading();
  }
}
