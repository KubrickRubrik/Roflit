part of '../api_db.dart';

@DataClassName('AccountDto')
class AccountTable extends Table {
  @override
  String get tableName => 'account';

  IntColumn get idAccount => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 3, max: 32)();
  TextColumn get localization =>
      text().withDefault(const Constant('ru')).withLength(min: 2, max: 2)();
  IntColumn get activeIdStorage => integer().nullable()();
  TextColumn get password => text().nullable().withLength(min: 3, max: 32)();
}
