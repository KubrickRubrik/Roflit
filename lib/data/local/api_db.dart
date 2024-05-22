import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:roflit/core/entity/account.dart';
import 'package:roflit/core/entity/object.dart';
import 'package:roflit/core/entity/session.dart';
import 'package:roflit/core/entity/storage.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'api_db.g.dart';
// Dao
part 'daos/account_dao.dart';
part 'daos/objects_download_dao.dart';
part 'daos/objects_load_dao.dart';
part 'daos/session_dao.dart';
// Table
part 'daos/test.dart';
part 'tables/account_table.dart';
part 'tables/object_download_table.dart';
part 'tables/object_load_table.dart';
part 'tables/object_table.dart';
part 'tables/session_table.dart';
part 'tables/storage_table.dart';
part 'tables/test_table.dart';

@DriftDatabase(
  tables: [
    TestTable,
    TestTodoCategoryTable,
    SessionTable,
    AccountTable,
    StorageTable,
    ObjectDownloadTable,
    ObjectLoadTable,
    ObjectTable,
  ],
  daos: [
    TestDao,
    SessionDao,
    AccountDao,
    ObjectDownloadDao,
    ObjectLoadDao,
  ],
)
class ApiDatabase extends _$ApiDatabase {
  ApiDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  //  LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
