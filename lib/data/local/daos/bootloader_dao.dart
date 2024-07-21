part of '../api_db.dart';

@DriftAccessor(tables: [BootloaderTable, StorageTable, ObjectTable])
class BootloaderDao extends DatabaseAccessor<ApiDatabase> with _$BootloaderDaoMixin {
  BootloaderDao(super.db);

  Future<bool> saveBootloader({
    required int idStorage,
    required List<ObjectTableCompanion> objects,
    required ActionBootloader action,
  }) async {
    return transaction<bool>(() async {
      final uploadObject = <BootloaderTableCompanion>[];
      for (final object in objects) {
        final idObject = await into(objectTable).insert(object);
        uploadObject.add(
          BootloaderTableCompanion.insert(
            idStorage: idStorage,
            idObject: idObject,
            action: action,
          ),
        );
      }

      if (uploadObject.isEmpty || uploadObject.length != objects.length) {
        throw Exception('Abort transaction');
      }

      await batch((batch) {
        batch.insertAll(bootloaderTable, uploadObject);
      });
      return true;
    });
  }

  Future<bool> updateBootloader({
    required List<ObjectTableCompanion> objects,
  }) async {
    return transaction<bool>(() async {
      await batch((batch) {
        batch.replaceAll(objectTable, objects);
      });
      return true;
    });
  }

  Future<bool> removeBootloader(List<int> ids) async {
    return transaction<bool>(() async {
      final query = select(bootloaderTable).join([
        innerJoin(
          objectTable,
          objectTable.idObject.equalsExp(bootloaderTable.idObject),
          useColumns: false,
        ),
      ]);

      query.where(bootloaderTable.id.isIn(ids));

      final uploadObjects = await query.get();

      if (uploadObjects.isEmpty) return false;

      final removeUploadsList = <BootloaderDto>[];

      for (final row in uploadObjects) {
        final upload = row.readTableOrNull(bootloaderTable);
        if (upload != null) {
          removeUploadsList.add(upload);
        }
      }

      if (removeUploadsList.isEmpty) return false;

      final deleteUpload = delete(bootloaderTable);
      deleteUpload.where((t) {
        return t.id.isIn(removeUploadsList.map((v) => v.id));
      });

      final deleteObject = delete(objectTable);
      deleteObject.where((t) {
        return t.idObject.isIn(removeUploadsList.map((v) => v.idObject));
      });

      final result = await Future.wait([deleteUpload.go(), deleteObject.go()]);
      if (result.first != result.last) {
        throw Exception('Error delete');
      }

      return true;
    });
  }
}
