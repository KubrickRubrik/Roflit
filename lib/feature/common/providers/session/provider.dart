import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/entity/account.dart';
import 'package:roflit/core/entity/session.dart';
import 'package:roflit/core/entity/storage.dart';
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

  Future<void> watchSessionAndAccounts() async {
    state = const SessionState.loading();
    await _listenerSession?.cancel();
    await _listenerAccounts?.cancel();

    final watchingDao = ref.read(diServiceProvider).apiLocalClient.watchingDao;

    _listenerSession = watchingDao.watchSession().listen((event) {
      if (state is SessionLoadedState) {
        state = (state as SessionLoadedState).copyWith(session: event);
      } else {
        state = SessionState.loaded(session: event);
      }
    });

    _listenerAccounts = watchingDao.watchAccounts().listen((event) {
      if (state is SessionLoadedState) {
        state = (state as SessionLoadedState).copyWith(accounts: event);
      } else {
        state = SessionState.loaded(accounts: event);
      }
    });
  }

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

    if (getByIndex != null) {
      final account = getAccount(getActive: false, getByIndex: getByIndex);
      return account?.idAccount == currentState.session.activeIdAccount;
    } else if (getByIdAccount != null) {
      return getByIdAccount == currentState.session.activeIdAccount;
    }
    return false;
  }

  bool isActiveStorage({int? getByIndex, int? getByIdStorage}) {
    if (state is! SessionLoadedState) return false;
    final currentState = state as SessionLoadedState;

    if (getByIndex != null) {
      final account = getStorage(getActive: false, getByIndex: getByIndex);
      return account?.idAccount == currentState.session.activeIdStorage;
    } else if (getByIdStorage != null) {
      return getByIdStorage == currentState.session.activeIdStorage;
    }
    return false;
  }

  StorageEntity? getStorage({
    required bool getActive,
    int? getByIndex,
    int? getByIdStorage,
  }) {
    // if (state is! SessionLoadedState) return null;
    // final currentState = state as SessionLoadedState;
    final account = getAccount(getActive: true);
    if (getActive) {
      return account?.storages.firstWhereOrNull((e) {
        // print('>>>> ${e.idStorage} == ${account.activeIdStorage}');
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

  Future<bool?> checkLogin(int idAccount) async {
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

    final newSession = SessionEntity(
      activeIdAccount: account.idAccount,
      activeIdStorage: account.activeIdStorage,
    );

    final response = await apiSessionDao.updateSession(newSession);

    if (!response) {
      //TODO: добавление снэкбара
      return null;
    }
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
    return true;
  }

  Future<bool> clearSession(int idAccount) async {
    final apiSessionDao = ref.read(diServiceProvider).apiLocalClient.sessionDao;
    final response = await apiSessionDao.clearSession();
    return response;
  }

  Future<bool> setActiveStorage(int? idStorage) async {
    final apiSessionDao = ref.read(diServiceProvider).apiLocalClient.sessionDao;
    final account = getAccount(getActive: true);
    if (account == null ||
        account.storages.firstWhereOrNull((e) => e.idStorage == idStorage) == null) {
      //TODO: добавление снэкбара
      return false;
    }

    final response = await apiSessionDao.setActiveStorage(
      idAccount: account.idAccount,
      activeIdStorage: idStorage!,
    );

    if (!response) {
      //TODO: добавление снэкбара
      return false;
    }
    return true;
  }
}
