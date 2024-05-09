part of '../api_db.dart';

@DriftAccessor(tables: [ObjectsDownloadTable, ObjectsTable])
class ObjectsDownloadDao extends DatabaseAccessor<ApiDatabase> with _$ObjectsDownloadDaoMixin {
  ObjectsDownloadDao(super.db);

  Stream<List<ObjectEntity>> watchObjects() {
    final query = select(objectsDownloadTable).join([
      leftOuterJoin(
        objectsTable,
        objectsTable.idObject.equalsExp(objectsDownloadTable.idObject),
      )
    ]);

    final response = (query..where(objectsDownloadTable.state.equals(true))).watch();

    return response.map((rows) {
      return rows.map((row) {
        return ObjectEntity.fromDto(row.readTable(objectsTable));
      }).toList();
    });
  }
}
