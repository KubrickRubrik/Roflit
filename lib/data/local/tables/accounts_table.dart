part of '../api_db.dart';

@DataClassName('AccountsDto')
class AccountsTable extends Table {
  @override
  String get tableName => 'accounts';

  IntColumn get idAccount => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 3, max: 32)();
  TextColumn get localization =>
      text().withDefault(const Constant('ru')).withLength(min: 2, max: 2)();
  TextColumn get activeBucket => text().nullable().withLength(min: 2, max: 128)();
  TextColumn get activeTypeCloud => text().nullable().withLength(min: 2, max: 16)();
  TextColumn get password => text().nullable().withLength(min: 3, max: 32)();
  BoolColumn get state => boolean().withDefault(const Constant(true))();
}
