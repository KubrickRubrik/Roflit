import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service.g.dart';

@riverpod
ApiClientService apiClientService(ApiClientServiceRef ref) {
  return ApiClientService();
}

final class ApiClientService {}
