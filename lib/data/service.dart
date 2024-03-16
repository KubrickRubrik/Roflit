// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart' as crypto;
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/config/account.dart';
import 'package:roflit/middleware/extension/zip.dart';
import 'package:s3client/s3client.dart';

part 'service.g.dart';

@riverpod
ApiClientService apiClientService(ApiClientServiceRef ref) {
  return ApiClientService();
}

final class ApiClientService {
  final yxClient = S3Client.yandex(
    accessKey: ServiceAccount.accessKey,
    secretKey: ServiceAccount.secretKey,
  );

  void abc() {
    final dto = yxClient.buckets.getListObject(bucketName: bucketName);
  }

  static const host = 'storage.yandexcloud.net';
  static const region = 'ru-central1';
  static const bucketName = 'roflit';
  // Static access keys
  String get accessKey => ServiceAccount.accessKey;
  String get secretKey => ServiceAccount.secretKey;
  String get dateYYYYmmDD => DateTime.now().toUtc().yyyyMMdd; // YYYYMMDD
  String get xAmzDateHeader => DateTime.now().toUtc().xAmzDate; // 20240301T120357Z
  //
  String get url => 'https://storage.yandexcloud.net/$bucketName?list-type=2';
  // String get canonicalRequest => 'GET / HTTP/2';
  String get canonicalRequest => 'GET /$bucketName?list-type=2 HTTP/2';

  Future<void> test() async {
    final signetStringSignature = _stringToSign(canonicalRequest);

    final headers = <String, String>{
      'Host': host,
      'Authorization': 'AWS4-HMAC-SHA256' +
          'Credential=$accessKey/$dateYYYYmmDD/$region/s3/aws4_request,' +
          'SignedHeaders=host;x-amz-date,' +
          'Signature=$signetStringSignature',
      'X-Amz-Date': xAmzDateHeader,
    };
    log('>>>> $url\n$headers');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      log(response.statusCode.toString());
      log(response.body);
    } catch (e) {
      log(e.toString());
    }
  }

  /// Signing the message.
  String _stringToSign(String message) {
    return hex(signHMAC(_signingKey, message));
  }

  /// Signing key.
  String get _signingKey {
    final dateKey = signHMAC('AWS4$secretKey', dateYYYYmmDD);
    final regionKey = signHMAC(dateKey, region);
    final serviceKey = signHMAC(regionKey, 's3');
    return signHMAC(serviceKey, 'aws4_request');
  }

  /// Signature mechanism.
  String signHMAC(String key, String message) {
    final keyBytes = utf8.encode(key);
    final messageBytes = utf8.encode(message);

    final hmacSha256 = crypto.Hmac(crypto.sha256, keyBytes);
    final digest = hmacSha256.convert(messageBytes);
    return digest.toString();
  }

  ///!
  String hashSha256(String value) {
    return sha256.convert(utf8.encode(value)).toString();
  }

  /// Convert message to hexadecimal format.
  String hex(String value) {
    return value.codeUnits.map((e) => e.toRadixString(16)).join();
  }

  /// Convert message to Base64 format.
  String base64Encode(String value) {
    return base64.encode(utf8.encode(value));
  }
}
