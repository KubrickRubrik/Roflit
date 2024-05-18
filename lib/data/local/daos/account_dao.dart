part of '../api_db.dart';

@DriftAccessor(tables: [AccountTable, AccountStorageTable])
class AccountDao extends DatabaseAccessor<ApiDatabase> with _$AccountDaoMixin {
  AccountDao(super.db);

  Future<bool> createAccount({
    required AccountEntity account,
  }) async {
    final accountInsert = await into(accountTable).insertReturningOrNull(
      AccountTableCompanion.insert(
        name: account.name,
        localization: Value(account.localization.name),
        password: Value.absentIfNull(account.password),
      ),
    );
    if (accountInsert == null) return false;
    return true;
  }

  Future<bool> updateAccount({
    required AccountEntity account,
  }) async {
    final accountUpdate = update(accountTable);
    accountUpdate.where((t) => t.idAccount.equals(account.idAccount));
    await accountUpdate.write(AccountTableCompanion(
      name: Value(account.name),
      localization: Value(account.localization.name),
      password: Value(account.password),
    ));

    return true;
  }

  Stream<List<AccountEntity>> watchAccounts() {
    final query = select(accountTable).join([
      leftOuterJoin(
        accountStorageTable,
        accountStorageTable.idAccount.equalsExp(accountTable.idAccount) &
            accountStorageTable.state.equals(true),
      )
    ]);
    query.where(accountTable.state.equals(true));
    query.orderBy([
      OrderingTerm.asc(accountTable.idAccount),
      OrderingTerm.asc(accountStorageTable.idStorage),
    ]);

    return query.watch().map((rows) {
      print('>>>> ROWS $rows');
      return rows.map((row) {
        final account = row.readTable(accountTable);
        final clouds = row.readTableOrNull(accountStorageTable);
        // print(
        //     '>>>> PROFILE: ${profile.idProfile}, ${profile.name} CLOUD: id: ${clouds.id} TYPE ${clouds.cloudType}');
        return AccountEntity.fromDto(
          accountDto: row.readTable(accountTable),
          storageDto: null, // row.readTable(accountStorageTable));
        );
      }).toList();
    });
  }
}
