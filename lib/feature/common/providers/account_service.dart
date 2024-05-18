import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/entity/account.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/providers/di_service.dart';
import 'package:roflit/data/local/api_db.dart';

part 'account_service.g.dart';

@riverpod
AccountService accountService(AccountServiceRef ref) {
  return AccountService(
    apiLocalClient: ref.read(diServiceProvider).apiLocalClient.accountsDao,
  );
}

final class AccountService {
  final AccountDao apiLocalClient;

  AccountService({required this.apiLocalClient});

  Future<bool> createAccount({
    required String name,
    required AvailableAppLocale localization,
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

    final response = await apiLocalClient.createAccount(account: account);

    if (!response) {
      return false;
      //TODO snackbar
    }
    //TODO snackbar
    return true;
  }

  Future<bool> updateAccount({
    required int? idAccount,
    required String name,
    required AvailableAppLocale localization,
    required String password,
  }) async {
    if (idAccount == null) return false;
    if (name.isEmpty ||
        name.isNotEmpty && name.length < 3 ||
        password.isNotEmpty && password.length < 3) {
      //TODO snackbar
      return false;
    }

    final account = AccountEntity(
      idAccount: idAccount,
      name: name,
      localization: localization,
      password: password.isEmpty ? null : password,
    );

    final response = await apiLocalClient.updateAccount(account: account);

    if (!response) {
      return false;
      //TODO snackbar
    }
    //TODO snackbar
    return true;
  }
}
