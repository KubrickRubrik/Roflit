part of '../api_db.dart';

@DataClassName('StorageDto')
class StorageTable extends Table {
  @override
  String get tableName => 'storage';

  IntColumn get idStorage => integer().autoIncrement()();
  IntColumn get idAccount => integer()();
  TextColumn get title => text().withLength(min: 2, max: 128)();
  TextColumn get storageType => text().withLength(min: 2, max: 16)();
  TextColumn get activeBucket => text().nullable().withLength(min: 1, max: 128)();
  TextColumn get link => text().withLength(min: 1, max: 128)();
  TextColumn get accessKey => text().withLength(min: 1, max: 128)();
  TextColumn get secretKey => text().withLength(min: 1, max: 128)();
  TextColumn get region => text().withLength(min: 1, max: 128)();
  TextColumn get pathSelectFiles => text().nullable().withLength(min: 1, max: 512)();
  TextColumn get pathSaveFiles => text().nullable().withLength(min: 1, max: 512)();
}
