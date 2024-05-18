part of '../api_db.dart';

@DriftAccessor(tables: [SessionTable, AccountTable])
class SessionDao extends DatabaseAccessor<ApiDatabase> with _$SessionDaoMixin {
  SessionDao(super.db);

  Stream<SessionEntity> watchSession() {
    final query = select(sessionTable).join([
      innerJoin(
        accountTable,
        accountTable.idAccount.equalsExp(sessionTable.activeIdAccount) &
            accountTable.state.equals(true),
      )
    ]);
    query.where(accountTable.state.equals(true));
    query.limit(1);

    return query.watchSingleOrNull().map((row) {
      print('>>>> ROW SESSION $row');
      final session = row?.readTableOrNull(sessionTable);

      return SessionEntity(
        activeIdAccount: session?.activeIdAccount,
        activeIdStorage: session?.activeIdStorage,
      );
    });
  }

  Future<bool> updateSession(SessionEntity session) async {
    final querySelect = select(sessionTable);
    querySelect.where((t) => t.id.equals(1));
    final response = await querySelect.getSingleOrNull();

    if (response == null) {
      final insertQuery = into(sessionTable);
      final response = await insertQuery.insert(
        SessionTableCompanion.insert(
          id: const Value(1),
          activeIdAccount: Value(session.activeIdAccount),
          activeIdStorage: Value(session.activeIdStorage),
        ),
      );
      print('>>>> INSERT $response');
      return response == 1;
    } else {
      final updateQuery = update(sessionTable);
      updateQuery.where((t) => t.id.equals(1));
      final response = await updateQuery.write(
        SessionTableCompanion.insert(
          activeIdAccount: Value(session.activeIdAccount),
          activeIdStorage: Value(session.activeIdStorage),
        ),
      );
      print('>>>> UPDATE $response');
      return response == 1;
    }
  }
}
