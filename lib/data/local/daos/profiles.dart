part of '../api_db.dart';

@DriftAccessor(tables: [ProfilesTable, ProfileCloudsTable])
class ProfilesDao extends DatabaseAccessor<ApiDatabase> with _$ProfilesDaoMixin {
  ProfilesDao(super.db);

  Stream<List<ProfileEntity>> getProfiles() {
    final response = select(profilesTable).watch();
    // TODO
    return response.map((rows) {
      return rows.map((row) {
        return ProfileEntity.fromDto(row);
      }).toList();
    });
  }
}
