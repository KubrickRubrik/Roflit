part of '../api_db.dart';

@DriftAccessor(tables: [AccountsTable, ProfilesCloudsTable])
class AccountsDao extends DatabaseAccessor<ApiDatabase> with _$AccountsDaoMixin {
  AccountsDao(super.db);

  Future<bool> createProfile({
    required AccountEntity account,
  }) async {
    final profileInsert = await into(accountsTable).insertReturningOrNull(
      AccountsTableCompanion.insert(
        name: account.name,
        localization: Value(account.localization.name),
        password: Value.absentIfNull(account.password),
      ),
    );
    if (profileInsert == null) return false;
    return true;
  }

  Stream<List<AccountEntity>> watchProfiles() {
    final query = select(accountsTable).join([
      leftOuterJoin(
        profilesCloudsTable,
        profilesCloudsTable.idProfile.equalsExp(accountsTable.idProfile) &
            profilesCloudsTable.state.equals(true),
      )
    ]);
    query.where(accountsTable.state.equals(true));
    query.orderBy([
      OrderingTerm.asc(accountsTable.idProfile),
      OrderingTerm.asc(profilesCloudsTable.id),
    ]);

    return query.watch().map((rows) {
      print('>>>> ROWS $rows');
      return rows.map((row) {
        final profile = row.readTable(accountsTable);
        final clouds = row.readTableOrNull(profilesCloudsTable);
        // print(
        //     '>>>> PROFILE: ${profile.idProfile}, ${profile.name} CLOUD: id: ${clouds.id} TYPE ${clouds.cloudType}');
        return AccountEntity.fromDto(
          profileDto: row.readTable(accountsTable),
          cloudsDto: null, // row.readTable(profilesCloudsTable));
        );
      }).toList();
    });
  }
}
