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

  Future<StorageEntity?> createStorage({required StorageEntity storage}) async {
    return transaction<StorageEntity?>(() async {
      final storageDto = await into(storageTable).insertReturningOrNull(
        StorageTableCompanion.insert(
          idAccount: storage.idAccount,
          title: storage.title,
          storageType: storage.storageType.name,
          link: storage.link,
          accessKey: storage.accessKey,
          secretKey: storage.secretKey,
          region: storage.region,
        ),
      );

      if (storageDto == null) {
        throw Exception('Error create storage');
      }

      return StorageEntity.fromDto(storageDto);
    });
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

    return query.map((row) => null).watch().watch().map((rows) {
      print('>>>> ROWS $rows');
      return rows.map((row) {
        final account = row.readTable(accountTable);
        final clouds = row.readTableOrNull(storageTable);
        print(
            '>>>> ID ${account.idAccount} | CLOUD: idStorage: ${clouds?.idStorage} TYPE ${clouds?.storageType}');
        return AccountEntity.fromDto(
          accountDto: row.readTable(accountTable),
          storageDto: null, // row.readTable(storageTable));
        );
      }).toList();
    });
  }
}
