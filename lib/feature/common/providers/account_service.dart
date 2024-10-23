// ignore_for_file: functional_ref
import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/config/account.dart';
import 'package:roflit/core/entity/account.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/providers/di_service.dart';
import 'package:roflit/data/local/api_db.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:roflit/feature/common/providers/storage_service.dart';

part 'account_service.g.dart';

@riverpod
AccountService accountService(AccountServiceRef ref) {
  return AccountService(
    sessionBloc: ref.watch(sessionBlocProvider.notifier),
    storageService: ref.watch(storageServiceProvider),
    apiLocalClient: ref.watch(diServiceProvider).apiLocalClient.accountsDao,
    test: ref.watch(diServiceProvider).apiLocalClient.watchingDao,
  );
}

final class AccountService {
  final SessionBloc sessionBloc;
  final StorageService storageService;
  final AccountDao apiLocalClient;
  final WatchingDao test;

  AccountService({
    required this.sessionBloc,
    required this.storageService,
    required this.apiLocalClient,
    required this.test,
  });

  Future<bool> createAccount({
    required String name,
    required AppLocalization localization,
    required String password,
  }) async {
    if (name.isEmpty ||
        name.isNotEmpty && name.length < 3 ||
        password.isNotEmpty && password.length < 3) {
      //TODO snackbar
      return false;
    }

    final account = AccountEntity(
      idAccount: -1,
      name: name,
      localization: localization,
      password: password.isEmpty ? null : password,
      activeBucket: '',
    );

    final responseAccount = await apiLocalClient.createAccount(account: account);

    if (responseAccount == null) {
      return false;
      //TODO snackbar
    }

    await sessionBloc.loginFreeAccount(responseAccount);

    //TODO snackbar
    return true;
  }

  Future<bool> updateAccount({
    required int? idAccount,
    required String name,
    required AppLocalization localization,
    required String password,
  }) async {
    if (idAccount == null) return false;
    if (name.isEmpty ||
        name.isNotEmpty && name.length < 3 ||
        password.isNotEmpty && password.length < 3) {
      //TODO snackbar
      return false;
    }

    final account = AccountTableCompanion(
      idAccount: Value(idAccount),
      name: Value(name),
      localization: Value(localization.name),
      password: Value(password.isEmpty ? null : password),
    );

    final response = await apiLocalClient.updateAccount(account: account);

    if (!response) {
      return false;
      //TODO snackbar
    }
    //TODO snackbar
    return true;
  }

  Future<bool> deleteAccount({required int idAccount}) async {
    final responseSession = await sessionBloc.clearSession(idAccount);

    if (!responseSession) {
      return false;
      //TODO snackbar
    }

    final response = await apiLocalClient.deleteAccount(idAccount: idAccount);

    if (!response) {
      return false;
      //TODO snackbar
    }

    return response;
  }

  Future<bool> setConfig({
    required int idAccount,
    bool? isOnUpload,
    bool? isOnDownload,
    ActionFirst? action,
  }) async {
    final account = AccountTableCompanion(
      idAccount: Value(idAccount),
      isOnUpload: Value.absentIfNull(isOnUpload),
      isOnDownload: Value.absentIfNull(isOnDownload),
      action: Value.absentIfNull(action),
    );

    final response = await apiLocalClient.updateAccount(account: account);

    if (!response) {
      return false;
      //TODO snackbar
    }
    //TODO snackbar
    return true;
  }

  Future<void> createDefaultAccount() async {
    await createAccount(
      name: 'Account Test 1',
      localization: AppLocalization.ru,
      password: '',
    );
    await createAccount(
      name: 'Account Test 2',
      localization: AppLocalization.ru,
      password: '',
    );

    var accounts = sessionBloc.accounts();

    if (accounts.isEmpty) return;
    final testAccount1 = accounts.first;

    await storageService.createStorage(
      idAccount: testAccount1.idAccount,
      title: ServiceAccount.yandexCloud1.title,
      storageType: StorageType.yxCloud,
      accessKey: _getData(ServiceAccount.yandexCloud1.accessKeyId),
      secretKey: _getData(ServiceAccount.yandexCloud1.secretAccessKey),
      region: _getData(ServiceAccount.yandexCloud1.region),
    );

    await storageService.createStorage(
      idAccount: testAccount1.idAccount,
      title: ServiceAccount.vkCloud1.title,
      storageType: StorageType.vkCloud,
      accessKey: _getData(ServiceAccount.vkCloud1.accessKeyId),
      secretKey: _getData(ServiceAccount.vkCloud1.secretAccessKey),
      region: _getData(ServiceAccount.vkCloud1.region),
    );

    final testAccount2 = accounts.last;
    await storageService.createStorage(
      idAccount: testAccount2.idAccount,
      title: ServiceAccount.yandexCloud2.title,
      storageType: StorageType.yxCloud,
      accessKey: _getData(ServiceAccount.yandexCloud2.accessKeyId),
      secretKey: _getData(ServiceAccount.yandexCloud2.secretAccessKey),
      region: _getData(ServiceAccount.yandexCloud2.region),
    );

    await storageService.createStorage(
      idAccount: testAccount2.idAccount,
      title: ServiceAccount.vkCloud2.title,
      storageType: StorageType.vkCloud,
      accessKey: _getData(ServiceAccount.vkCloud2.accessKeyId),
      secretKey: _getData(ServiceAccount.vkCloud2.secretAccessKey),
      region: _getData(ServiceAccount.vkCloud2.region),
    );

    await sessionBloc.loginFreeAccount(testAccount1);

    accounts = sessionBloc.accounts();

    if (accounts.first.storages.isEmpty) return;

    await sessionBloc.setActiveStorage(accounts.first.storages.first.idStorage);
  }

  String _getData(String data) {
    return utf8.decode(base64Decode(data));
  }
}
