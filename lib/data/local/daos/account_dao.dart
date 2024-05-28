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
    final accountUpdate = delete(accountTable);
    accountUpdate.where((t) => t.idAccount.equals(idAccount));
    final response = await accountUpdate.go();
    return response == 1;
  }

  Future<StorageEntity?> createStorage({required StorageEntity storage}) async {
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
      return null;
    }

    return StorageEntity.fromDto(storageDto);
  }

  Future<bool> updateStorage({required StorageEntity storage}) async {
    final storageUpdate = update(storageTable);
    storageUpdate.where((t) => t.idStorage.equals(storage.idStorage));
    final response = await storageUpdate.write(
      StorageTableCompanion(
        title: Value(storage.title),
        storageType: Value(storage.storageType.name),
        link: Value(storage.link),
        accessKey: Value(storage.accessKey),
        secretKey: Value(storage.secretKey),
        region: Value(storage.region),
      ),
    );

    return response == 1;
  }

  Future<bool> deleteStorage({required int idStorage}) async {
    final deleteStorage = delete(storageTable);
    deleteStorage.where((t) => t.idStorage.equals(idStorage));
    final response = await deleteStorage.go();
    return response == 1;
  }

  Stream<List<AccountEntity>> watchAccounts() {
    final query = select(accountTable).join([
      leftOuterJoin(
        storageTable,
        storageTable.idAccount.equalsExp(accountTable.idAccount),
      )
    ]);

    query.orderBy([
      OrderingTerm.asc(accountTable.idAccount),
      OrderingTerm.asc(storageTable.idStorage),
    ]);

    return query.watch().map((rows) {
      final listResult = <int, AccountEntity>{};
      for (final row in rows) {
        final account = row.readTable(accountTable);
        final storage = row.readTableOrNull(storageTable);
        if (listResult[account.idAccount] != null && storage != null) {
          final newAccount = listResult[account.idAccount];

          if (!newAccount!.storages.any((s) => s.idStorage == storage.idStorage)) {
            final newStorage = StorageEntity.fromDto(storage);
            listResult[account.idAccount] = newAccount.copyWith(storages: [
              ...newAccount.storages,
              newStorage,
            ]);
          }
        } else {
          listResult.addAll({
            account.idAccount: AccountEntity.fromDto(
              accountDto: account,
              storageDto: storage,
            )
          });
        }
      }

      return listResult.values.toList();
    });
  }
}
