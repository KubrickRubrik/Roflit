import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:roflit/core/entity/account.dart';
import 'package:roflit/core/entity/object.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:uuid/uuid.dart';

part 'api_db.g.dart';
part 'daos/account.dart';
part 'daos/objects_download.dart';
part 'daos/objects_load.dart';
part 'daos/test.dart';
part 'tables/account_clouds.dart';
part 'tables/accounts.dart';
part 'tables/objects.dart';
part 'tables/objects_download.dart';
part 'tables/objects_load.dart';
part 'tables/test.dart';

@DriftDatabase(
  tables: [
    TestTable,
    TestTodoCategoryTable,
    AccountsTable,
    ProfilesCloudsTable,
    ObjectsDownloadTable,
    ObjectsLoadTable,
    ObjectsTable,
  ],
  daos: [
    TestDao,
    AccountsDao,
    ObjectsDownloadDao,
    ObjectsLoadDao,
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
    print('>>>> $dbFolder');
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
