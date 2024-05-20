import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class ApiSecureStorage {
  final _secureStorage = const FlutterSecureStorage();

  Future<void> read(String key) async {
    await _secureStorage.read(key: key);
  }

  Future<void> write({required String key, required String value}) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }
}
