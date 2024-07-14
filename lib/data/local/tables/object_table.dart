part of '../api_db.dart';

@DataClassName('ObjectDto')
class ObjectTable extends Table {
  @override
  String get tableName => 'object';

  IntColumn get idObject => integer().autoIncrement()();
  TextColumn get bucket => text().withLength(min: 1, max: 128)();
  TextColumn get objectKey => text().withLength(min: 3, max: 128)();
  TextColumn get remotePath => text().nullable().withLength(min: 6, max: 1024)();
  TextColumn get localPath => text().nullable().withLength(min: 6, max: 1024)();
  TextColumn get type => text().withLength(min: 2, max: 16)();
  TextColumn get size => text().withLength(min: 0, max: 16).withDefault(const Constant('0'))();

  TextColumn get storageType => text().withLength(min: 2, max: 16)();
}
