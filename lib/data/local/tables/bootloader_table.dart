part of '../api_db.dart';

@DataClassName('BootloaderDto')
class BootloaderTable extends Table {
  @override
  String get tableName => 'object_bootloader';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get idStorage => integer().references(StorageTable, #idStorage)();
  IntColumn get idObject => integer().references(ObjectTable, #idObject)();
  TextColumn get action => textEnum<ActionBootloader>()();
}
