import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/config/account.dart';
import 'package:s3roflit/s3roflit.dart';

part 'service.g.dart';

@riverpod
ApiClientService apiClientService(ApiClientServiceRef ref) {
  return ApiClientService();
}

final class ApiClientService {
  final yxClient = S3Roflit.yandex(
    accessKey: ServiceAccount.accessKey,
    secretKey: ServiceAccount.secretKey,
  );

  Future<void> test() async {
    final client = yxClient.buckets.getListObject(bucketName: 'bucket-u1');
    // final client = yxClient.buckets.getListBuckets();

    log('>>>> ${client.url}\n${client.headers}');

    try {
      final response = await http.get(
        client.url,
        headers: client.headers,
      );
      log(response.statusCode.toString());
      log(response.body);
    } catch (e) {
      log(e.toString());
    }
  }
}
