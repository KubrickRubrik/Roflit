import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'remote/api_remote_buckets_service.dart';

part 'api_remote_client.g.dart';

@Riverpod()
ApiRemoteClient apiRemoteClient(ApiRemoteClientRef ref) {
  return ApiRemoteClient();
}

final class ApiRemoteClient {
  final buckets = ApiRemoteClientBucketsService();
}
