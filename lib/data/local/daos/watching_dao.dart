part of '../api_db.dart';

@DriftAccessor(tables: [SessionTable, AccountTable, StorageTable, ObjectUploadTable, ObjectTable])
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

  Stream<List<UploadObjectEntity>> watchUploadObjects() {
    final query = select(objectUploadTable).join([
      innerJoin(
        objectTable,
        objectTable.idObject.equalsExp(objectUploadTable.idObject),
      )
    ]);

    query.orderBy([OrderingTerm.asc(objectUploadTable.idUpload)]);

    return query.watch().map((rows) {
      final listResult = <UploadObjectEntity>[];
      for (final row in rows) {
        final uploadDto = row.readTableOrNull(objectUploadTable);
        final object = row.readTableOrNull(objectTable);
        if (uploadDto != null && object != null) {
          listResult.add(UploadObjectEntity.fromDto(
            uploadDto: uploadDto,
            objectDto: object,
          ));
        }
      }

      return listResult;
    });
  }
}
