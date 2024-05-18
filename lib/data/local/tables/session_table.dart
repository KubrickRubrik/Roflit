part of '../api_db.dart';

@DataClassName('SessionDto')
class SessionTable extends Table {
  @override
  String get tableName => 'session';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get activeIdAccount => integer().nullable()();
  IntColumn get activeIdStorage => integer().nullable()();
}
