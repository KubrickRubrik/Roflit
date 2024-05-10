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

    query.where(objectsDownloadTable.state.equals(true));
    query.orderBy([OrderingTerm.asc(objectsDownloadTable.id)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return ObjectEntity.fromDto(row.readTable(objectsTable));
      }).toList();
    });
  }
}
