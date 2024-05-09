import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/di.dart';
import 'package:roflit/core/entity/profile.dart';
import 'package:roflit/core/entity/session.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';
part 'state.dart';

@riverpod
final class SessionBloc extends _$SessionBloc {
  @override
  SessionState build() => const SessionState.init();

  Future<void> checkAuthentication() async {
    // final api = ref.read(diProvider).apiRemoteClient.buckets.getBucketObjects(bucketName: bucketName);
    final api = ref.read(diProvider).apiLocalClient.testDao.todosInCategory();
    state = const SessionState.loading();
  }
}
