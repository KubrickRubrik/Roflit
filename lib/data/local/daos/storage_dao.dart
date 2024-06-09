part of '../api_db.dart';

@DriftAccessor(tables: [AccountTable, StorageTable])
class StorageDao extends DatabaseAccessor<ApiDatabase> with _$StorageDaoMixin {
  StorageDao(super.db);

  Future<StorageEntity?> createStorage({required StorageTableCompanion storage}) async {
    final storageDto = await into(storageTable).insertReturningOrNull(storage);

    if (storageDto == null) {
      return null;
    }

    return StorageEntity.fromDto(storageDto);
  }

  Future<bool> updateStorage({required StorageTableCompanion storage}) async {
    final updateStorage = update(storageTable);
    updateStorage.where((t) => t.idStorage.equals(storage.idStorage.value));
    final response = await updateStorage.write(storage);
    return response == 1;
  }

  Future<bool> deleteStorage({required int idStorage}) async {
    final deleteStorage = delete(storageTable);
    deleteStorage.where((t) => t.idStorage.equals(idStorage));
    final response = await deleteStorage.go();
    return response == 1;
  }
}
