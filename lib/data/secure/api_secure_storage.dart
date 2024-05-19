import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_secure_storage.g.dart';

@riverpod
ApiSecureStorage apiSecure(ApiSecureRef ref) {
  return ApiSecureStorage();
}

final class ApiSecureStorage {
  final storage = const FlutterSecureStorage();

  //TODO: READ,WRITE,UPDATE with converter
}
