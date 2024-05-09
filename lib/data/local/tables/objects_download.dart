part of '../api_db.dart';

@DataClassName('ObjectsDownloadDto')
final class ObjectsDownloadTable extends Table {
  @override
  String get tableName => 'objects_download';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get idObject => integer().references(ObjectsTable, #idObject)();
  BoolColumn get state => boolean().withDefault(const Constant(false))();
}
