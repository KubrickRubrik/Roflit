import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/data/local/api_db.dart';

part 'api_local_client.g.dart';

@Riverpod()
ApiLocalClient apiLocalClient(ApiLocalClientRef ref) {
  return ApiLocalClient();
}

final class ApiLocalClient {
  final _db = ApiDatabase();

  TestDao get testDao => _db.testDao;
  ProfilesDao get profilesDao => _db.profilesDao;

  Future<void> closeDb() async {
    await _db.close();
  }
}
