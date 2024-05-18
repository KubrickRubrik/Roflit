part of '../api_db.dart';

@DataClassName('AccountStorageDto')
class AccountStorageTable extends Table {
  @override
  String get tableName => 'account_storage';

  IntColumn get idStorage => integer().autoIncrement()();
  IntColumn get idAccount => integer()();
  TextColumn get title => text().unique().withLength(min: 2, max: 64)();
  TextColumn get cloudType => text().withLength(min: 2, max: 16)();
  TextColumn get link => text().withDefault(Constant(const Uuid().v1()))();
  BoolColumn get state => boolean().withDefault(const Constant(true))();
}
