part of '../api_db.dart';

@DataClassName('ObjectsDto')
final class ObjectsTable extends Table {
  @override
  String get tableName => 'objects';

  IntColumn get idObject => integer().autoIncrement()();
  TextColumn get bucket => text().withLength(min: 1, max: 128)();
  TextColumn get title => text().withLength(min: 6, max: 128)();
  TextColumn get loalPath => text().withLength(min: 6, max: 128)();

  TextColumn get cloudType => text().withLength(min: 2, max: 16)();
}
