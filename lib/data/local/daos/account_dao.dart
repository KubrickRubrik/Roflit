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
    required AccountEntity account,
  }) async {
    final accountUpdate = update(accountTable);
    accountUpdate.where((t) => t.idAccount.equals(account.idAccount));
    final response = await accountUpdate.write(AccountTableCompanion(
      name: Value(account.name),
      localization: Value(account.localization.name),
      password: Value(account.password),
    ));

    return response == 1;
  }

  Future<bool> deleteAccount({required int idAccount}) async {
    final accountUpdate = update(accountTable);
    accountUpdate.where((t) => t.idAccount.equals(idAccount));
    final response = await accountUpdate.write(const AccountTableCompanion(
      state: Value(false),
    ));

    return response == 1;
  }

  Future<StorageEntity?> createStorage(StorageEntity storage) async {
    return transaction<StorageEntity?>(() async {
      final storageInsert = await into(storageTable).insertReturningOrNull(
        StorageTableCompanion.insert(
          idAccount: storage.idAccount,
          title: storage.title,
          storageType: storage.storageType.name,
        ),
      );
    });
    //TODO: add save to key in securestorage
  }

  Stream<List<AccountEntity>> watchAccounts() {
    final query = select(accountTable).join([
      leftOuterJoin(
        storageTable,
        storageTable.idAccount.equalsExp(accountTable.idAccount) & storageTable.state.equals(true),
      )
    ]);
    query.where(accountTable.state.equals(true));
    query.orderBy([
      OrderingTerm.asc(accountTable.idAccount),
      OrderingTerm.asc(storageTable.idStorage),
    ]);

    return query.watch().map((rows) {
      print('>>>> ROWS $rows');
      return rows.map((row) {
        final account = row.readTable(accountTable);
        final clouds = row.readTableOrNull(storageTable);
        // print(
        //     '>>>> PROFILE: ${profile.idProfile}, ${profile.name} CLOUD: id: ${clouds.id} TYPE ${clouds.cloudType}');
        return AccountEntity.fromDto(
          accountDto: row.readTable(accountTable),
          storageDto: null, // row.readTable(storageTable));
        );
      }).toList();
    });
  }
}
