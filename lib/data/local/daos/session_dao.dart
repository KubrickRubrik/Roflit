part of '../api_db.dart';

@DriftAccessor(tables: [SessionTable, AccountsTable])
class SessionDao extends DatabaseAccessor<ApiDatabase> with _$SessionDaoMixin {
  SessionDao(super.db);

  Stream<SessionEntity> watchSession() {
    final query = select(sessionTable).join([
      innerJoin(
        accountsTable,
        accountsTable.idAccount.equalsExp(sessionTable.activeIdAccount) &
            accountsTable.state.equals(true),
      )
    ]);
    query.where(accountsTable.state.equals(true));
    query.limit(1);

    return query.watchSingle().map((row) {
      print('>>>> ROW SESSION $row');
      final session = row.readTableOrNull(sessionTable);

      return SessionEntity(
        activeIdAccount: session?.activeIdAccount,
        activeTypeCloud: TypeCloud.none.typeCloudFromName(session?.activeTypeCloud),
      );
    });
  }

  Future<bool> updateSession(SessionEntity session) async {
    final query = update(sessionTable);
    query.where((t) => t.id.equals(1));

    final response = await query.write(
      SessionTableCompanion(
        activeIdAccount: Value(session.activeIdAccount),
        activeTypeCloud: Value(session.activeTypeCloud?.name),
      ),
    );

    return response == 1;
  }
}
