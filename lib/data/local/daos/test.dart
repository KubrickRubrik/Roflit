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
