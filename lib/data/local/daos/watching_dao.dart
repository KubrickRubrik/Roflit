part of '../api_db.dart';

@DriftAccessor(tables: [SessionTable, AccountTable, StorageTable, BootloaderTable, ObjectTable])
class WatchingDao extends DatabaseAccessor<ApiDatabase> with _$WatchingDaoMixin {
  WatchingDao(super.db);

  Stream<SessionEntity> watchSession() {
    final query = select(sessionTable).join([
      innerJoin(
        accountTable,
        accountTable.idAccount.equalsExp(sessionTable.activeIdAccount),
      )
    ]);

    return query.watchSingleOrNull().map((row) {
      final session = row?.readTableOrNull(sessionTable);

      return SessionEntity(
        activeIdAccount: session?.activeIdAccount,
        activeIdStorage: session?.activeIdStorage,
      );
    });
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

  Stream<AccountEntity?> watchActiveAccount() {
    final query = select(accountTable).join([
      innerJoin(
        sessionTable,
        sessionTable.activeIdAccount.equalsExp(accountTable.idAccount),
        useColumns: false,
      ),
      leftOuterJoin(
        storageTable,
        storageTable.idAccount.equalsExp(accountTable.idAccount) &
            storageTable.idStorage.equalsExp(sessionTable.activeIdStorage),
      )
    ]);

    return query.watchSingleOrNull().map((row) {
      final account = row?.readTableOrNull(accountTable);
      final storage = row?.readTableOrNull(storageTable);

      if (account != null) {
        return AccountEntity.fromDto(
          accountDto: account,
          storageDto: storage,
        );
      }
      return null;
    });
  }

  Stream<StorageEntity?> watchActiveStorage() {
    final query = select(sessionTable).join([
      leftOuterJoin(
        storageTable,
        storageTable.idStorage.equalsExp(sessionTable.activeIdStorage),
      )
    ]);

    return query.watchSingleOrNull().map((row) {
      final storageDto = row?.readTableOrNull(storageTable);
      if (storageDto == null) return null;
      return StorageEntity.fromDto(storageDto);
    });
  }

  Stream<List<BootloaderEntity>> watchBootloader([ActionBootloader? action]) {
    final query = select(bootloaderTable).join([
      innerJoin(
        objectTable,
        objectTable.idObject.equalsExp(bootloaderTable.idObject),
      )
    ]);

    if (action != null) {
      query.where(bootloaderTable.action.equals(action.name));
    }

    query.orderBy([
      OrderingTerm.asc(bootloaderTable.idStorage),
      OrderingTerm.asc(objectTable.bucket),
      OrderingTerm.asc(bootloaderTable.id),
    ]);

    return query.watch().map((rows) {
      final listResult = <BootloaderEntity>[];
      for (final row in rows) {
        final uploadDto = row.readTableOrNull(bootloaderTable);
        final object = row.readTableOrNull(objectTable);
        if (uploadDto != null && object != null) {
          listResult.add(BootloaderEntity.fromDto(
            bootloaderDto: uploadDto,
            objectDto: object,
          ));
        }
      }

      return listResult;
    });
  }
}
