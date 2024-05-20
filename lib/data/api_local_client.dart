import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/data/local/api_db.dart';
import 'package:roflit/data/local/api_secure_storage.dart';

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
  final _secureStorage = ApiSecureStorage();

  ApiDatabase get dbInstance => _db;
  ApiSecureStorage get secureStorage => _secureStorage;

  TestDao get testDao => _db.testDao;
  AccountDao get accountsDao => _db.accountDao;
  SessionDao get sessionDao => _db.sessionDao;

  Future<void> closeDb() async {
    await _db.close();
  }
}
