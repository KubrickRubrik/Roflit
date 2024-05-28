part of '../api_db.dart';

@DriftAccessor(tables: [SessionTable, AccountTable])
class SessionDao extends DatabaseAccessor<ApiDatabase> with _$SessionDaoMixin {
  SessionDao(super.db);

  Stream<SessionEntity> watchSession() {
    final query = select(sessionTable).join([
      innerJoin(
        accountTable,
        accountTable.idAccount.equalsExp(sessionTable.activeIdAccount),
      )
    ]);

    query.limit(1);

    return query.watchSingleOrNull().map((row) {
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

      return response == 1;
    }
  }

  Future<bool> clearSession() async {
    final updateQuery = update(sessionTable);
    updateQuery.where((t) => t.id.equals(1));
    final response = await updateQuery.write(
      SessionTableCompanion.insert(
        activeIdAccount: const Value(null),
        activeIdStorage: const Value(null),
      ),
    );
    return response == 1;
  }

  Future<bool> setActiveStorage({
    required int idAccount,
    required int activeIdStorage,
  }) async {
    return transaction<bool>(() async {
      final updateAccountQuery = update(accountTable);
      updateAccountQuery.where((t) => t.idAccount.equals(idAccount));
      final responseAccount = await updateAccountQuery.write(
        AccountTableCompanion(
          activeIdStorage: Value(activeIdStorage),
        ),
      );
      if (responseAccount != 1) {
        throw Exception('Abort transaction');
      }
      final updateSessionQuery = update(sessionTable);
      updateSessionQuery.where((t) => t.id.equals(1));
      final responseSession = await updateSessionQuery.write(
        SessionTableCompanion.insert(
          activeIdStorage: Value(activeIdStorage),
        ),
      );
      if (responseSession != 1) {
        throw Exception('Abort transaction');
      }
      return true;
    });
  }
}
