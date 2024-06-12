import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/entity/result.dart';
import 'package:roflit/core/utils/logger.dart';
import 'package:s3roflit/interface/storage_interface.dart';

part 'api_remote_client.g.dart';

@Riverpod()
ApiRemoteClient apiRemoteClient(ApiRemoteClientRef ref) {
  return ApiRemoteClient();
}

final class ApiRemoteClient {
  Future<Result> send(
    StorageBucketRequestsDtoInterface client,
  ) async {
    try {
      final response = await http.get(
        client.url,
        headers: client.headers,
      );
      // logger.info(response.body);
      return Result.success(
        statusCode: response.statusCode,
        success: response.body,
      );
    } catch (e) {
      logger.error(e);
      return Result.failuer(message: e.toString());
    }
  }
}
