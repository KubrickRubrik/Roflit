import 'dart:convert';

import 'package:crypto/crypto.dart';

final class Signature {
  final String accessKey;
  final String secretKey;
  final String region;
  final String dateYYYYmmDD;
  final String xAmzDateHeader;

  Signature({
    required this.accessKey,
    required this.secretKey,
    required this.region,
    required this.dateYYYYmmDD,
    required this.xAmzDateHeader,
  });

  /// Signing the message.
  String stringToSign(String message) {
    return _hex(signHMAC(_signingKey, message));
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

    final hmacSha256 = Hmac(sha256, keyBytes);
    final digest = hmacSha256.convert(messageBytes);
    return digest.toString();
  }

  /// Convert message to hexadecimal format.
  String _hex(String value) {
    return value.codeUnits.map((e) => e.toRadixString(16)).join();
  }

  /// Convert message to Base64 format.
  String base64Encode(String value) {
    return base64.encode(utf8.encode(value));
  }
}
