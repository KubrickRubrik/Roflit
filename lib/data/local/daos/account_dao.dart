part of '../api_db.dart';

@DriftAccessor(tables: [AccountTable, StorageTable])
class AccountDao extends DatabaseAccessor<ApiDatabase> with _$AccountDaoMixin {
  AccountDao(super.db);

  Future<AccountEntity?> createAccount({
    required AccountEntity account,
  }) async {
    final accountInsert = await into(accountTable).insertReturningOrNull(
      AccountTableCompanion.insert(
        name: account.name,
        localization: Value(account.localization.name),
        password: Value.absentIfNull(account.password),
      ),
    );
    if (accountInsert == null) return null;
    return AccountEntity.fromDto(accountDto: accountInsert);
  }

  Future<bool> updateAccount({
    required AccountTableCompanion account,
  }) async {
    final accountUpdate = update(accountTable);
    accountUpdate.where((t) => t.idAccount.equals(account.idAccount.value));

    final response = await accountUpdate.write(account);

    return response == 1;
  }

  Future<bool> deleteAccount({required int idAccount}) async {
    final accountUpdate = delete(accountTable);
    accountUpdate.where((t) => t.idAccount.equals(idAccount));
    final response = await accountUpdate.go();
    return response == 1;
  }
}
