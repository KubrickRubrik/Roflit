import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/entity/result.dart';
import 'package:roflit/core/utils/logger.dart';
import 'package:s3roflit/interface/storage_interface.dart';
import 'package:s3roflit/src/config/s3/request_type.dart';

part 'api_remote_client.g.dart';

@Riverpod()
ApiRemoteClient apiRemoteClient(ApiRemoteClientRef ref) {
  return ApiRemoteClient();
}

final class ApiRemoteClient {
  Future<Result> get(
    StorageBucketRequestsDtoInterface client,
  ) async {
    try {
      Response? response;
      switch (client.typeRequest) {
        case RequestType.get:
          response = await http.get(
            client.url,
            headers: client.headers,
          );
        case RequestType.put:
          response = await http.put(
            client.url,
            headers: client.headers,
          );
        case RequestType.delete:
        case RequestType.post:
      }
      log('>>>> ${response?.body}');

      return Result.success(
        statusCode: response?.statusCode,
        success: response?.body,
      );
    } catch (e) {
      logger.error(e);
      return Result.failuer(message: e.toString());
    }
  }
}
