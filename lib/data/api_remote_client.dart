import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:s3roflit/interface/storage_interface.dart';

part 'api_remote_client.g.dart';

@Riverpod()
ApiRemoteClient apiRemoteClient(ApiRemoteClientRef ref) {
  return ApiRemoteClient();
}

final class ApiRemoteClient {
  Future<T?> send<T>(
    StorageBucketRequestsDtoInterface client, {
    required T Function(dynamic) serializer,
  }) async {
    try {
      final response = await http.get(
        client.url,
        headers: client.headers,
      );
      // log(response.statusCode.toString());
      // log(response.body);
      print('>>>> ${response.body.runtimeType}');
      return serializer(response.body);
    } catch (e) {
      // log(e.toString());
      return null;
    }
  }
}
