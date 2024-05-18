part of '../api_db.dart';

@DataClassName('ObjectLoadDto')
class ObjectLoadTable extends Table {
  @override
  String get tableName => 'object_load';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get idObject => integer().references(ObjectTable, #idObject)();
  BoolColumn get state => boolean().withDefault(const Constant(false))();
}
