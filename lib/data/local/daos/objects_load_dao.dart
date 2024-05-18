part of '../api_db.dart';

@DriftAccessor(tables: [ObjectLoadTable, ObjectTable])
class ObjectLoadDao extends DatabaseAccessor<ApiDatabase> with _$ObjectLoadDaoMixin {
  ObjectLoadDao(super.db);

  Stream<List<ObjectEntity>> watchObjects() {
    final query = select(objectLoadTable).join([
      leftOuterJoin(
        objectTable,
        objectTable.idObject.equalsExp(objectLoadTable.idObject),
      ),
    ]);
    query.where(objectLoadTable.state.equals(true));
    query.orderBy([OrderingTerm.asc(objectLoadTable.id)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return ObjectEntity.fromDto(row.readTable(objectTable));
      }).toList();
    });
  }
}
