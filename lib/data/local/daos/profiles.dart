part of '../api_db.dart';

@DriftAccessor(tables: [ProfilesTable, ProfilesCloudsTable])
class ProfilesDao extends DatabaseAccessor<ApiDatabase> with _$ProfilesDaoMixin {
  ProfilesDao(super.db);

  Future<bool> createProfile({
    required ProfileEntity profile,
    required AccountCloudEntity cloud,
  }) async {
    final profileInsert = await into(profilesTable).insertReturningOrNull(
      ProfilesTableCompanion.insert(
        name: profile.name,
        language: Value(profile.language.name),
        password: Value.absentIfNull(profile.password),
      ),
    );
    if (profileInsert == null) return false;
    return true;
  }

  Stream<List<ProfileEntity>> watchProfiles() {
    final query = select(profilesTable).join([
      leftOuterJoin(
        profilesCloudsTable,
        profilesCloudsTable.idProfile.equalsExp(profilesTable.idProfile) &
            profilesCloudsTable.state.equals(true),
      )
    ]);
    query.where(profilesTable.state.equals(true));
    query.orderBy([
      OrderingTerm.asc(profilesTable.idProfile),
      OrderingTerm.asc(profilesCloudsTable.id),
    ]);

    return query.watch().map((rows) {
      print('>>>> ROWS $rows');
      return rows.map((row) {
        final profile = row.readTable(profilesTable);
        final clouds = row.readTable(profilesCloudsTable);
        // print(
        //     '>>>> PROFILE: ${profile.idProfile}, ${profile.name} CLOUD: id: ${clouds.id} TYPE ${clouds.cloudType}');
        return ProfileEntity.fromDto(
          profileDto: row.readTable(profilesTable),
          cloudsDto: null, // row.readTable(profilesCloudsTable));
        );
      }).toList();
    });
  }
}
