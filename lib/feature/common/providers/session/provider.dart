import 'dart:async';

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
  SessionState build() {
    ref.onCancel(() async {
      await _listener?.cancel();
    });
    return const SessionState.init();
  }

  StreamSubscription<List<ProfileEntity>>? _listener;

  Future<void> checkAuthentication() async {
    // final api = ref.read(diProvider).apiRemoteClient.buckets.getBucketObjects(bucketName: bucketName);
    state = const SessionState.loading();

    await _listener?.cancel();

    final api = ref.read(diProvider).apiLocalClient.profilesDao;
    await api.addProfiles();
    _listener = api.watchProfiles().listen((event) {
      state = SessionState.loaded(profiles: event);
    });
  }
}
