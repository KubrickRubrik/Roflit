part of '../api_db.dart';

@DriftAccessor(tables: [ObjectsLoadTable, ObjectsTable])
class ObjectsLoadDao extends DatabaseAccessor<ApiDatabase> with _$ObjectsLoadDaoMixin {
  ObjectsLoadDao(super.db);

  Stream<List<ObjectEntity>> watchObjects() {
    final query = select(objectsLoadTable).join([
      leftOuterJoin(
        objectsTable,
        objectsTable.idObject.equalsExp(objectsLoadTable.idObject),
      ),
    ]);

    final response = (query..where(objectsLoadTable.state.equals(true))).watch();

    return response.map((rows) {
      return rows.map((row) {
        return ObjectEntity.fromDto(row.readTable(objectsTable));
      }).toList();
    });
  }
}
