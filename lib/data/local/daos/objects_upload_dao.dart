part of '../api_db.dart';

@DriftAccessor(tables: [ObjectUploadTable, ObjectTable])
class ObjectUploadDao extends DatabaseAccessor<ApiDatabase> with _$ObjectUploadDaoMixin {
  ObjectUploadDao(super.db);

  // Stream<List<ObjectEntity>> watchObjects() {
  //   final query = select(objectUploadTable).join([
  //     leftOuterJoin(
  //       objectTable,
  //       objectTable.idObject.equalsExp(objectUploadTable.idObject),
  //     ),
  //   ]);

  //   query.orderBy([OrderingTerm.asc(objectUploadTable.idObject)]);

  //   return query.watch().map((rows) {
  //     return rows.map((row) {
  //       return ObjectEntity.fromDto(row.readTable(objectTable));
  //     }).toList();
  //   });
  // }

  Future<bool> saveUploadObject(List<ObjectTableCompanion> objects) async {
    return transaction<bool>(() async {
      final uploadObject = <ObjectUploadTableCompanion>[];
      for (final object in objects) {
        final idObject = await into(objectTable).insert(object);
        uploadObject.add(ObjectUploadTableCompanion.insert(idObject: idObject));
      }

      if (uploadObject.isEmpty || uploadObject.length != objects.length) {
        throw Exception('Abort transaction');
      }

      await batch((batch) {
        batch.insertAll(objectUploadTable, uploadObject);
      });
      return true;
    });
  }

  Future<bool> removeUploadObject(List<int> ids) async {
    return transaction<bool>(() async {
      final query = select(objectUploadTable).join([
        innerJoin(
          objectTable,
          objectTable.idObject.equalsExp(objectUploadTable.idObject),
          useColumns: false,
        ),
      ]);

      query.where(objectUploadTable.idUpload.isIn(ids));

      final uploadObjects = await query.get();

      if (uploadObjects.isEmpty) return false;

      final removeUploadsList = <ObjectUploadDto>[];

      for (final row in uploadObjects) {
        final upload = row.readTableOrNull(objectUploadTable);
        if (upload != null) {
          removeUploadsList.add(upload);
        }
      }

      if (removeUploadsList.isEmpty) return false;

      final deleteUpload = delete(objectUploadTable);
      deleteUpload.where((t) {
        return t.idUpload.isIn(removeUploadsList.map((v) => v.idUpload));
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
