part of '../api_db.dart';

@DriftAccessor(tables: [AccountsTable, ProfilesCloudsTable])
class AccountsDao extends DatabaseAccessor<ApiDatabase> with _$AccountsDaoMixin {
  AccountsDao(super.db);

  Future<bool> createAccount({
    required AccountEntity account,
  }) async {
    final accountInsert = await into(accountsTable).insertReturningOrNull(
      AccountsTableCompanion.insert(
        name: account.name,
        localization: Value(account.localization.name),
        password: Value.absentIfNull(account.password),
      ),
    );
    if (accountInsert == null) return false;
    return true;
  }

  Future<bool> updateAccount({
    required AccountEntity account,
  }) async {
    final accountUpdate = update(accountsTable);
    accountUpdate.where((t) => t.idAccount.equals(account.idAccount));
    await accountUpdate.write(AccountsTableCompanion(
      name: Value(account.name),
      localization: Value(account.localization.name),
      password: Value(account.password),
    ));

    return true;
  }

  Stream<List<AccountEntity>> watchProfiles() {
    final query = select(accountsTable).join([
      leftOuterJoin(
        profilesCloudsTable,
        profilesCloudsTable.idProfile.equalsExp(accountsTable.idAccount) &
            profilesCloudsTable.state.equals(true),
      )
    ]);
    query.where(accountsTable.state.equals(true));
    query.orderBy([
      OrderingTerm.asc(accountsTable.idAccount),
      OrderingTerm.asc(profilesCloudsTable.id),
    ]);

    return query.watch().map((rows) {
      print('>>>> ROWS $rows');
      return rows.map((row) {
        final account = row.readTable(accountsTable);
        final clouds = row.readTableOrNull(profilesCloudsTable);
        // print(
        //     '>>>> PROFILE: ${profile.idProfile}, ${profile.name} CLOUD: id: ${clouds.id} TYPE ${clouds.cloudType}');
        return AccountEntity.fromDto(
          accountDto: row.readTable(accountsTable),
          cloudsDto: null, // row.readTable(profilesCloudsTable));
        );
      }).toList();
    });
  }
}
