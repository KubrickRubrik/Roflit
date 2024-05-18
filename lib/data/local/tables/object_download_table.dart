part of '../api_db.dart';

@DataClassName('ObjectDownloadDto')
class ObjectDownloadTable extends Table {
  @override
  String get tableName => 'object_download';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get idObject => integer().references(ObjectTable, #idObject)();
  BoolColumn get state => boolean().withDefault(const Constant(false))();
}
