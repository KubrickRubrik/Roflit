part of '../api_db.dart';

@DataClassName('ObjectsLoadDto')
class ObjectsLoadTable extends Table {
  @override
  String get tableName => 'objects_load';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get idObject => integer().references(ObjectsTable, #idObject)();
  BoolColumn get state => boolean().withDefault(const Constant(false))();
}
