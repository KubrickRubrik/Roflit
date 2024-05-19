part of '../api_db.dart';

@DataClassName('StorageDto')
class StorageTable extends Table {
  @override
  String get tableName => 'storage';

  IntColumn get idStorage => integer().autoIncrement()();
  IntColumn get idAccount => integer()();
  TextColumn get title => text().unique().withLength(min: 2, max: 64)();
  TextColumn get storageType => text().withLength(min: 2, max: 16)();
  TextColumn get activeBucket => text().nullable().withLength(min: 1, max: 128)();
  TextColumn get link => text().withDefault(Constant(const Uuid().v1()))();
  BoolColumn get state => boolean().withDefault(const Constant(true))();
}
