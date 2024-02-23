import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../middleware/zip_utils.dart';

part 'service.g.dart';

@riverpod
ApiClientService apiClientService(ApiClientServiceRef ref) {
  return ApiClientService();
}

final class ApiClientService {
  void api() {
    logger.info('>>>> update Client');
  }
}
