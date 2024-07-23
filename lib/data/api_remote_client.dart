import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/entity/result.dart';
import 'package:roflit/feature/common/providers/api_observer/provider.dart';
import 'package:s3roflit/interface/storage_interface.dart';
import 'package:s3roflit/src/config/s3/request_type.dart';

part 'api_remote_client.g.dart';

@Riverpod()
ApiRemoteClient apiRemoteClient(ApiRemoteClientRef ref) {
  return ApiRemoteClient(ref);
}

final class ApiRemoteClient {
  ApiRemoteClient(this.ref);

  final ApiRemoteClientRef ref;
  final _dio = Dio();

  Future<Result> send(
    StorageBucketRequestsDtoInterface client,
  ) async {
    // try {
    Response<Object>? response;
    switch (client.typeRequest) {
      case RequestType.get:
        // print('>>>> GET URL ${client.url.origin}');
        // print('>>>> GET HEADERS ${client.headers}');
        // print('>>>> GET BODY ${client.body}');

        response = await _dio.get(
          client.url.toString(),
          options: Options(
            headers: client.headers,
          ),
        );

        print('>>>> GET CODE ${response.statusCode}');
        print('>>>> GET ${response.data}');
      case RequestType.put:
        print('>>>> PUT ${client.url}');
        print('>>>> PUT ${client.url.path}');
        print('>>>> PUT ${client.url.queryParametersAll}');

        response = await _dio.put(
          client.url.toString(),
          options: Options(
            headers: client.headers,
          ),
          data: client.body,
          // onReceiveProgress: (count, total) {},
          onSendProgress: (count, total) {
            ref.read(apiObserverBlocProvider.notifier).onSendUploadProgress(
                  ApiObjectValue(count: count, total: total),
                );
          },
        );

        print('>>>> PUT URL ${client.url}');
        print('>>>> PUT HEADERS ${client.headers}');
        // print('>>>> PUT BODY ${client.body}');

        print('>>>> PUT CODE ${response.statusCode}');
      // print('>>>> PUT ${response.data}');
      case RequestType.delete:
        response = await _dio.delete(
          client.url.toString(),
          options: Options(
            headers: client.headers,
          ),
        );
      case RequestType.post:
        print('>>>> SEND POST URL ${client.url}');
        print('>>>> SEND POST HEADERS ${client.headers}');
        print('>>>> SEND POST BODY ${client.body}');
        response = await _dio.post(
          client.url.toString(),
          options: Options(
            headers: client.headers,
          ),
          data: client.body,
        );
        print('>>>> POST CODE ${response.statusCode}');
        print('>>>> POST ${response.data}');
    }

    return Result.success(
      statusCode: response.statusCode,
      success: response.data,
    );
  }
}
