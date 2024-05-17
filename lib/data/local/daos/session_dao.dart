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

    return query.watchSingleOrNull().map((row) {
      print('>>>> ROW SESSION $row');
      final session = row?.readTableOrNull(sessionTable);

      return SessionEntity(
        activeIdAccount: session?.activeIdAccount,
        activeTypeCloud: TypeCloud.none.typeCloudFromName(session?.activeTypeCloud),
      );
    });
  }

  Future<bool> updateSession(SessionEntity session) async {
    final query = into(sessionTable);

    final response = await query.insert(
      SessionTableCompanion.insert(
        id: const Value(1),
        activeIdAccount: Value(session.activeIdAccount),
        activeTypeCloud: Value(session.activeTypeCloud?.name),
      ),
      onConflict: DoUpdate((old) {
        return SessionTableCompanion(
          activeIdAccount: Value(session.activeIdAccount),
          activeTypeCloud: Value(session.activeTypeCloud?.name),
        );
      }),
    );

    print('>>>> $response');
    return response == 1;
  }
}
