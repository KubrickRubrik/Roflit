import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/entity/result.dart';
import 'package:roflit/feature/common/providers/api_observer/provider.dart';
import 'package:roflit_s3/roflit_s3.dart';

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
    RoflitRequest client,
  ) async {
    // try {
    Response<dynamic>? response;

    switch (client.typeRequest) {
      case RequestType.get:
        print('>>>> GET URL ${client.url.origin}');
        print('>>>> GET HEADERS ${client.headers}');
        print('>>>> GET BODY ${client.body}');

        response = await _dio.get<dynamic>(
          client.url.toString(),
          options: Options(
            headers: client.headers,
          ),
        );

        // print('>>>> GET CODE ${response.statusCode}');
        log('>>>> GET ${response.data}');
      case RequestType.put:
        // print('>>>> PUT ${client.url}');
        // print('>>>> PUT ${client.url.path}');
        // print('>>>> PUT ${client.url.queryParametersAll}');

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

      // print('>>>> PUT URL ${client.url}');
      // print('>>>> PUT HEADERS ${client.headers}');
      // print('>>>> PUT BODY ${client.body}');

      // print('>>>> PUT CODE ${response.statusCode}');
      // print('>>>> PUT ${response.data}');
      case RequestType.delete:
        response = await _dio.delete(
          client.url.toString(),
          options: Options(
            headers: client.headers,
          ),
        );
      case RequestType.post:
        // print('>>>> SEND POST URL ${client.url}');
        // print('>>>> SEND POST HEADERS ${client.headers}');
        // print('>>>> SEND POST BODY ${client.body}');
        response = await _dio.post(
          client.url.toString(),
          options: Options(
            headers: client.headers,
          ),
          data: client.body,
        );
      // print('>>>> POST CODE ${response.statusCode}');
      // print('>>>> POST ${response.data}');
    }
    // return Result.success(
    //   statusCode: 101,
    //   success: null,
    // );
    final statusCode = response.statusCode ?? 400;

    if (statusCode < 200 || statusCode >= 300) {
      return Result.failuer(
        statusCode: response.statusCode,
        success: response.data,
        message: response.statusMessage,
      );
    } else {
      return Result.success(
        statusCode: response.statusCode,
        success: response.data,
      );
    }
  }

  Future<Result> download(
    RoflitRequest client,
    String savedStr,
  ) async {
    final response = await _dio.downloadUri(
      client.url,
      savedStr,
      options: Options(headers: client.headers),
      onReceiveProgress: (count, total) {
        ref.read(apiObserverBlocProvider.notifier).onReceiveDownloadProgress(
              ApiObjectValue(count: count, total: total),
            );
      },
    );

    final statusCode = response.statusCode ?? 400;

    if (statusCode < 200 || statusCode >= 300) {
      return Result.failuer(
        statusCode: response.statusCode,
        success: response.data,
        message: response.statusMessage,
      );
    } else {
      return Result.success(
        statusCode: response.statusCode,
        success: response.data,
      );
    }
  }
}
