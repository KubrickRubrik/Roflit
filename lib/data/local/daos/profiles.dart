part of '../api_db.dart';

@DriftAccessor(tables: [ProfilesTable, ProfilesCloudsTable])
class ProfilesDao extends DatabaseAccessor<ApiDatabase> with _$ProfilesDaoMixin {
  ProfilesDao(super.db);

  Future<void> addProfiles() async {
    await delete(profilesTable).go();
    await delete(profilesCloudsTable).go();

    // await into(profilesTable).insert(
    //   ProfilesTableCompanion.insert(
    //     name: 'Profile 1',
    //   ),
    // );
    // await batch((batch) {
    //   batch.insertAll(profilesTable, [
    //     ProfilesTableCompanion.insert(
    //       name: 'Profile 1',
    //     ),
    //     ProfilesTableCompanion.insert(
    //       name: 'Profile 2',
    //     ),
    //     ProfilesTableCompanion.insert(
    //       name: 'Profile 3',
    //     ),
    //   ]);
    // });

    final profile1 = await into(profilesTable).insertReturning(
      ProfilesTableCompanion.insert(
        name: 'Profile 1',
      ),
    );
    final profile2 = await into(profilesTable).insertReturning(
      ProfilesTableCompanion.insert(
        name: 'Profile 2',
      ),
    );
    final profile3 = await into(profilesTable).insertReturning(
      ProfilesTableCompanion.insert(
        name: 'Profile 3',
      ),
    );

    await batch((batch) {
      batch.insertAll(profilesCloudsTable, [
        ProfilesCloudsTableCompanion.insert(idProfile: profile1.idProfile, cloudType: 'YC'),
        ProfilesCloudsTableCompanion.insert(idProfile: profile1.idProfile, cloudType: 'VK'),
        ProfilesCloudsTableCompanion.insert(idProfile: profile1.idProfile, cloudType: 'CL'),
        ProfilesCloudsTableCompanion.insert(idProfile: profile2.idProfile, cloudType: 'YC'),
        ProfilesCloudsTableCompanion.insert(idProfile: profile2.idProfile, cloudType: 'VK'),
        ProfilesCloudsTableCompanion.insert(idProfile: profile3.idProfile, cloudType: 'YC'),
      ]);
    });
  }

  Stream<List<ProfileEntity>> watchProfiles() {
    // final allProfiles = alias(profilesTable, 'inProfiles');

    // final queryClouds = Subquery(
    //   select(profilesCloudsTable)
    //     ..where((tbl) => tbl.state.equals(true))
    //     ..orderBy([(e) => OrderingTerm.asc(e.id)]),
    //   's',
    // );

    // final query1 = select(profilesTable).join([
    //   leftOuterJoin(
    //     queryClouds,
    //     queryClouds.ref(profilesCloudsTable.idProfile.equalsExp(profilesTable.idProfile)),
    //   )
    // ]);

    // query1.where(profilesTable.state.equals(true));
    // query1.orderBy([OrderingTerm.asc(profilesTable.idProfile)]);
    // query1.groupBy([profilesTable.idProfile]);

    // final response = query1.watch();

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
