part of '../api_db.dart';

@DataClassName('ObjectUploadDto')
class ObjectUploadTable extends Table {
  @override
  String get tableName => 'object_upload';

  IntColumn get idUpload => integer().autoIncrement()();
  IntColumn get idObject => integer().references(ObjectTable, #idObject)();
}
