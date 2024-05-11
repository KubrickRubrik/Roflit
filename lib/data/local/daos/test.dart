part of '../api_db.dart';

// the TestDaoMixin will be created by drift. It contains all the necessary
// fields for the tables. The <TestTable> type annotation is the database class
// that should use this dao.
@DriftAccessor(tables: [TestTable])
class TestDao extends DatabaseAccessor<ApiDatabase> with _$TestDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object
  TestDao(super.db);

  Stream<TestDto> todosInCategory() {
    return (select(testTable)..where((tbl) => tbl.val1.equals(0))).watchSingle();
  }
}


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
    // ------------------------------
    // return transaction(() async {
    //   final profileInsert = await into(profilesTable).insertReturningOrNull(
    //     ProfilesTableCompanion.insert(
    //       name: profile.name,
    //       language: Value(profile.language.name),
    //       password: Value.absentIfNull(profile.password),
    //     ),
    //   );

    //   if (profileInsert == null) {
    //     throw Exception('Insert error');
    //   }

    //   final cloudInsert = await into(profilesCloudsTable).insertReturningOrNull(
    //     ProfilesCloudsTableCompanion.insert(
    //       idProfile: profileInsert.idProfile,
    //       titleLink: cloud.titleLink,
    //       cloudType: cloud.typeCloud.name,
    //     ),
    //   );

    //   if (cloudInsert == null) {
    //     throw Exception('Insert error');
    //   }
    //   return true;
    // }).catchError((e) {
    //   return false;
    // });