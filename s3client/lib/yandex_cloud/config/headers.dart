// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation

import 'package:s3client/middleware/zip.dart';

import 'signature.dart';

final class YandexHeaders {
  final String _accessKey;
  final String _secretKey;
  final String _host;
  final String _region;

  YandexHeaders({
    required String accessKey,
    required String secretKey,
    required String host,
    required String region,
  })  : _accessKey = accessKey,
        _secretKey = secretKey,
        _host = host,
        _region = region;

  Signature get _signature => Signature(
        accessKey: _accessKey,
        secretKey: _secretKey,
        region: _region,
        dateYYYYmmDD: Utility.dateYYYYmmDD,
        xAmzDateHeader: Utility.xAmzDateHeader,
      );

  String _signedHeaders(Map<String, String> headers) {
    return headers.keys.map((e) => e.toLowerCase()).join(';');
  }

  Map<String, String> get({
    required String canonicalRequest,
    required Map<String, String> headers,
  }) {
    return {
      'Host': _host,
      'Authorization': 'AWS4-HMAC-SHA256' +
          'Credential=$_accessKey/${Utility.dateYYYYmmDD}/$_region/s3/aws4_request,' +
          'SignedHeaders=${_signedHeaders(headers)}host;x-amz-date,' +
          'Signature=${_signature.stringToSign(canonicalRequest)}',
      'X-Amz-Date': Utility.xAmzDateHeader,
      'Content-Type': 'application/json',
      ...headers,
    };
  }
}
