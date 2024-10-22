part of '../api_db.dart';

@DataClassName('BootloaderDto')
class BootloaderTable extends Table {
  @override
  String get tableName => 'object_bootloader';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get idStorage => integer().references(StorageTable, #idStorage)();
  IntColumn get idObject => integer().references(ObjectTable, #idObject)();
  TextColumn get action => textEnum<ActionBootloader>()();

  IntColumn get originIdStorage => integer().nullable().references(StorageTable, #idStorage)();
  TextColumn get originBucket => text().nullable().withLength(min: 1, max: 128)();
  IntColumn get recipientIdStorage => integer().nullable().references(StorageTable, #idStorage)();
  TextColumn get recipientBucket => text().nullable().withLength(min: 1, max: 128)();
}
