import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/entity/result.dart';
import 'package:s3roflit/interface/storage_interface.dart';
import 'package:s3roflit/src/config/s3/request_type.dart';

part 'api_remote_client.g.dart';

@Riverpod()
ApiRemoteClient apiRemoteClient(ApiRemoteClientRef ref) {
  return ApiRemoteClient();
}

final class ApiRemoteClient {
  Future<Result> send(
    StorageBucketRequestsDtoInterface client,
  ) async {
    // try {
    Response? response;
    switch (client.typeRequest) {
      case RequestType.get:
        print('>>>> GET URL ${client.url}');
        print('>>>> GET HEADERS ${client.headers}');
        print('>>>> GET BODY ${client.body}');
        response = await http.get(
          client.url,
          headers: client.headers,
        );
        log('>>>> GET CODE ${response.statusCode}');
        log('>>>> GET ${response.body}');
      case RequestType.put:
        print('>>>> PUT URL ${client.url}');
        print('>>>> PUT HEADERS ${client.headers}');
        print('>>>> PUT BODY ${client.body}');
        response = await http.put(
          client.url,
          headers: client.headers,
          body: client.body,
        );
      case RequestType.delete:
        response = await http.delete(
          client.url,
          headers: client.headers,
        );
      case RequestType.post:
        print('>>>> SEND POST URL ${client.url}');
        print('>>>> SEND POST HEADERS ${client.headers}');
        print('>>>> SEND POST BODY ${client.body}');
        response = await http.post(
          client.url,
          headers: client.headers,
          body: client.body,
        );
        log('>>>> POST CODE ${response.statusCode}');
        log('>>>> POST ${response.body}');
    }

    return Result.success(
      statusCode: response.statusCode,
      success: response.body,
    );
    // } catch (e) {
    //   logger.error(e);
    //   return Result.failuer(message: e.toString());
    // }
  }
}
