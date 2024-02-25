import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/config/account.dart';
import 'package:roflit/middleware/extension/zip.dart';

import '../middleware/zip_utils.dart';

part 'service.g.dart';

@riverpod
ApiClientService apiClientService(ApiClientServiceRef ref) {
  return ApiClientService();
}

final class ApiClientService {
  final _dio = Dio();
  void api() {
    logger.info('>>>> update Client');
  }

  Future<void> test() async {
    // final authorization = {'Authorization': ''};
    // final host = {'Host': 'storage.yandexcloud.net'};
    // final date = {'Host': DateTime.now().toIso8601String()};

    final response = await _dio.get(
      'https://storage.yandexcloud.net',
      options: Options(headers: {
        'Host': 'storage.yandexcloud.net',
        'Authorization': _authorization,
        'Date': DateTime.now().inHeader,
      }),
    );
    print('>>>> ${response}');
    // print('>>>> ${response.data}');
// {GET|HEAD|PUT|DELETE} /<имя_бакета>/<ключ_объекта> HTTP/2
// Host: storage.yandexcloud.net
// Content-Length: length
// Date: date
// Authorization: authorization string (AWS Signature Version 4)

// Request_body
    // signer.sign(request, credentialScope: credentialScope);

    _stringToSign('Максим');
  }

  String _stringToSign(String stringToSign) {
    final result = _sign(_signingKey, stringToSign);
    return result.codeUnits.map((e) => e.toRadixString(16)).join();
  }

  String get _signingKey {
    final dateKey = _sign('AWS4${ServiceAccount.secretKey}', DateTime.now().yyyyMMdd);
    final region = _sign(dateKey, 'ru-central1');
    final serviceKey = _sign(region, 's3');
    return _sign(serviceKey, 'aws4_request');
  }

  String _sign(String key, String message) {
    final keyBytes = utf8.encode(key);
    final messageBytes = utf8.encode(message);
    final hmacSha256 = crypto.Hmac(crypto.sha256, keyBytes);
    final digest = hmacSha256.convert(messageBytes);
    return digest.toString();
  }

  String get _authorization {
    final dateKey = DateTime.now().yyyyMMdd;
    const region = 'ru-central1';
    return 'AWS4-HMAC-SHA256 Credential=${ServiceAccount.idKey}/$dateKey/$region/s3/aws4_request SignedHeaders=host;range;x-amz-date Signature=${_signingKey}';
  }
}
