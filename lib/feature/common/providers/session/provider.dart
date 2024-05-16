import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/entity/account.dart';
import 'package:roflit/core/entity/session.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/providers/di_service.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';
part 'state.dart';

@riverpod
final class SessionBloc extends _$SessionBloc {
  @override
  SessionState build() {
    ref.onCancel(() async {
      await _listenerSession?.cancel();
      await _listenerAccounts?.cancel();
    });
    return const SessionState.init();
  }

  // Removable listeners.
  StreamSubscription<SessionEntity>? _listenerSession;
  StreamSubscription<List<AccountEntity>>? _listenerAccounts;

  Future<void> checkAuthentication() async {
    // final api = ref.read(diProvider).apiRemoteClient.buckets.getBucketObjects(bucketName: bucketName);
    state = const SessionState.loading();
    await _listenerAccounts?.cancel();

    final apiSessionDao = ref.read(diServiceProvider).apiLocalClient.sessionDao;
    final apiAccountsDao = ref.read(diServiceProvider).apiLocalClient.accountsDao;

    _listenerSession = apiSessionDao.watchSession().listen((event) {
      if (state is SessionLoadedState) {
        state = (state as SessionLoadedState).copyWith(session: event);
      } else {
        state = SessionState.loaded(session: event);
      }
    });

    _listenerAccounts = apiAccountsDao.watchAccounts().listen((event) {
      if (state is SessionLoadedState) {
        state = (state as SessionLoadedState).copyWith(accounts: event);
      } else {
        state = SessionState.loaded(accounts: event);
      }
    });
  }

  Future<bool> setLocalization({
    required int idAccount,
    required AvailableAppLocale localization,
  }) async {
    if (state is! SessionLoadedState) return false;
    final newState = state as SessionLoadedState;
    final newAccounts = newState.accounts.toList();

    final accountIndex = newAccounts.indexWhere((e) {
      return e.idAccount == idAccount;
    });

    if (accountIndex == -1) return false;

    newAccounts[accountIndex] =
        newAccounts.elementAt(accountIndex).copyWith(localization: localization);

    state = newState.copyWith(
      accounts: newAccounts,
    );
    return true;
  }

  Future<bool?> confirmLogin(int idAccount) async {
    if (state is! SessionLoadedState) return null;
    final currentState = state as SessionLoadedState;
    if (idAccount == currentState.session.activeIdAccount) return null;

    final account = currentState.accounts.firstWhere((account) {
      return account.idAccount == idAccount;
    });

    if (account.password?.isNotEmpty == true) return false;
    await login(account);
    return true;
  }

  Future<void> login(AccountEntity account) async {
    if (state is! SessionLoadedState) return;
    final apiSessionDao = ref.read(diServiceProvider).apiLocalClient.sessionDao;
    final currentState = state as SessionLoadedState;

    final newSession = SessionEntity(
      activeIdAccount: account.idAccount,
      activeTypeCloud: account.activeTypeCloud,
    );

    final response = await apiSessionDao.updateSession(newSession);

    if (!response) {
      return null;
    }

    state = currentState.copyWith(session: newSession);
  }
}
