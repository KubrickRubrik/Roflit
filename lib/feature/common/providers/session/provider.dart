import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/entity/account.dart';
import 'package:roflit/core/entity/account_storage.dart';
import 'package:roflit/core/entity/session.dart';
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

  AccountEntity? getAccount({
    required bool getActive,
    int? getByIndex,
    int? getByIdAccount,
  }) {
    if (state is! SessionLoadedState) return null;
    final currentState = state as SessionLoadedState;

    if (getActive) {
      return currentState.accounts.firstWhereOrNull((e) {
        return e.idAccount == currentState.session.activeIdAccount;
      });
    } else {
      if (getByIndex != null) {
        return currentState.accounts.elementAtOrNull(getByIndex);
      } else if (getByIdAccount != null) {
        return currentState.accounts.firstWhereOrNull((e) {
          return e.idAccount == getByIdAccount;
        });
      }
      return null;
    }
  }

  bool isActiveIdAccount({int? getByIndex, int? getByIdAccount}) {
    if (state is! SessionLoadedState) return false;
    final currentState = state as SessionLoadedState;
    final account =
        getAccount(getActive: false, getByIndex: getByIndex, getByIdAccount: getByIdAccount);
    return account?.idAccount == currentState.session.activeIdAccount;
  }

  AccountStorageEntity? getStorage({
    required bool getActive,
    int? getByIndex,
    int? getByIdStorage,
  }) {
    final account = getAccount(getActive: true);
    if (getActive) {
      return account?.storages.firstWhereOrNull((e) {
        return e.idStorage == account.activeIdStorage;
      });
    } else {
      if (getByIndex != null) {
        return account?.storages.elementAtOrNull(getByIndex);
      } else if (getByIdStorage != null) {
        return account?.storages.firstWhereOrNull((e) {
          return e.idStorage == getByIdStorage;
        });
      }
      return null;
    }
  }

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

  Future<bool?> confirmLogin(int idAccount) async {
    if (state is! SessionLoadedState) return null;
    final currentState = state as SessionLoadedState;
    if (idAccount == currentState.session.activeIdAccount) return null;

    final account = currentState.accounts.firstWhere((account) {
      return account.idAccount == idAccount;
    });

    if (account.password?.isNotEmpty == true) return false;
    await loginFreeAccount(account);
    return true;
  }

  Future<void> loginFreeAccount(AccountEntity account) async {
    if (state is! SessionLoadedState) return;
    final apiSessionDao = ref.read(diServiceProvider).apiLocalClient.sessionDao;
    final currentState = state as SessionLoadedState;

    final newSession = SessionEntity(
      activeIdAccount: account.idAccount,
      activeIdStorage: account.activeIdStorage,
    );

    final response = await apiSessionDao.updateSession(newSession);

    if (!response) {
      //TODO: добавление снэкбара
      return null;
    }

    state = currentState.copyWith(session: newSession);
  }

  Future<bool> loginLockAccount({
    required int idAccount,
    required String password,
  }) async {
    if (state is! SessionLoadedState) return false;
    final apiSessionDao = ref.read(diServiceProvider).apiLocalClient.sessionDao;
    final currentState = state as SessionLoadedState;

    final account = currentState.accounts.firstWhere((account) {
      return account.idAccount == idAccount;
    });

    if (account.password != password) {
      // TODO: добавить снэкбар - неверный пароль
      return false;
    }

    final newSession = SessionEntity(
      activeIdAccount: account.idAccount,
      activeIdStorage: account.activeIdStorage,
    );

    final response = await apiSessionDao.updateSession(newSession);

    if (!response) {
      //TODO: добавление снэкбара
      return false;
    }

    state = currentState.copyWith(session: newSession);
    return true;
  }
}
