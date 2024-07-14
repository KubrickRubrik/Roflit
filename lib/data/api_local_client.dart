import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/data/local/api_db.dart';

part 'api_local_client.g.dart';

@Riverpod()
ApiLocalClient apiLocalClient(ApiLocalClientRef ref) {
  return ApiLocalClient();
}

final class ApiLocalClient {
  static final _instance = ApiLocalClient._();

  factory ApiLocalClient() => _instance;
  ApiLocalClient._();

  final _db = ApiDatabase();

  ApiDatabase get dbInstance => _db;

  TestDao get testDao => _db.testDao;
  WatchingDao get watchingDao => _db.watchingDao;
  SessionDao get sessionDao => _db.sessionDao;
  AccountDao get accountsDao => _db.accountDao;
  StorageDao get storageDao => _db.storageDao;
  ObjectUploadDao get objectUploadDao => _db.objectUploadDao;

  Future<void> closeDb() async {
    await _db.close();
  }
}
