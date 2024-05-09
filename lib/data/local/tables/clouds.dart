part of '../api_db.dart';

@DataClassName('CloudsDto')
final class ProfileCloudsTable extends Table {
  @override
  String get tableName => 'profile_clouds';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get idProfile => integer()();
  TextColumn get cloudType => text().withLength(min: 6, max: 16)();
  TextColumn get link => text().withDefault(Constant(const Uuid().v1()))();
}
