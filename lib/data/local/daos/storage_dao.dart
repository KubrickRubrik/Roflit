part of '../api_db.dart';

@DriftAccessor(tables: [AccountTable, StorageTable])
class StorageDao extends DatabaseAccessor<ApiDatabase> with _$StorageDaoMixin {
  StorageDao(super.db);

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
}
