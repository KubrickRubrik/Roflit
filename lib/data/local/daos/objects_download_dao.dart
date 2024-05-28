part of '../api_db.dart';

@DriftAccessor(tables: [ObjectDownloadTable, ObjectTable])
class ObjectDownloadDao extends DatabaseAccessor<ApiDatabase> with _$ObjectDownloadDaoMixin {
  ObjectDownloadDao(super.db);

  Stream<List<ObjectEntity>> watchObjects() {
    final query = select(objectDownloadTable).join([
      leftOuterJoin(
        objectTable,
        objectTable.idObject.equalsExp(objectDownloadTable.idObject),
      )
    ]);

    query.orderBy([OrderingTerm.asc(objectDownloadTable.id)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return ObjectEntity.fromDto(row.readTable(objectTable));
      }).toList();
    });
  }
}
