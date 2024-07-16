part of '../api_db.dart';

@DataClassName('BootloaderDto')
class BootloaderTable extends Table {
  @override
  String get tableName => 'object_upload';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get idObject => integer().references(ObjectTable, #idObject)();
  TextColumn get action => textEnum<ActionBootloader>()();
}
