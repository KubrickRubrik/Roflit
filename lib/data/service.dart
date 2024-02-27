// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart' as crypto;
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/config/account.dart';
import 'package:roflit/middleware/extension/zip.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'package:xml_map_converter/xml_map_converter.dart';

import '../middleware/zip_utils.dart';

part 'service.g.dart';

@riverpod
ApiClientService apiClientService(ApiClientServiceRef ref) {
  return ApiClientService();
}

final class ApiClientService {
  static const host = 'storage.yandexcloud.net';
  String get accessKey =>
      'YCAJEZfmQQRot1qExZ_sP97T9'; //ServiceAccount.accessKey; // 'YCAJE9nDIk-aEuQZTRZYWgLzr';
  String get secretKey =>
      'YCO_jtQOZUgRY8NMO7zXSxRwidrz8cawQVmfLl2Z'; //ServiceAccount.secretKey; // 'YCNgmm8quibCBF9sM3II4TJM8MBTPgdtbW4kTeDT';
  static const region = 'ru-central1';
  static const bucketName = 'roflit';
  String get dateYYYYmmDD => DateTime.now().toUtc().yyyyMMdd;
  // String get dateHeader => DateTime.now().toUtc().inHeader;
  String get xAmzDateHeader => DateTime.now().toUtc().xAmzDate;
  String get isoDateHeader => DateTime.now().toUtc().toIso8601String();
  String get url => 'https://storage.yandexcloud.net/$bucketName?list-type=2';

  Future<void> test() async {
    // const url = 'https://storage.yandexcloud.net';

    // const canonicalRequest = 'GET / HTTP/2';
    const canonicalRequest = 'GET /$bucketName?list-type=2 HTTP/2';
    final signetStringSignature = _stringToSign(canonicalRequest);

    final headers = <String, String>{
      'Host': host,
      'Authorization': 'AWS4-HMAC-SHA256' +
          'Credential=$accessKey/$dateYYYYmmDD/$region/s3/aws4_request,' +
          'SignedHeaders=host;x-amz-date,' +
          'Signature=$signetStringSignature',
      'X-Amz-Date': xAmzDateHeader,
    };
    print('>>>> $url');
    print('>>>> $headers');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        final json = (Xml2Json()..parse(response.body)).toOpenRally();
        log('RESPONSE $json');
        // final res = await Xml2Map(response.body).transform();
        // log('RESPONSE ${res.toString()}');
      }
      print('>>>> ');
      log(response.body);
    } catch (e) {
      log(e.toString());
    }
  }

  /// Signing the message.
  String _stringToSign(String message) {
    return base64Encode(hex(signHMAC(_signingKey, message)));
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
