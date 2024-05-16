part of '../api_db.dart';

@DataClassName('SessionDto')
class SessionTable extends Table {
  @override
  String get tableName => 'session';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get activeIdAccount => integer().nullable()();
  TextColumn get activeTypeCloud => text().nullable().withLength(min: 2, max: 16)();
}
