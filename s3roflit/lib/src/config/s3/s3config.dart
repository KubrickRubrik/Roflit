import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:s3roflit/middleware/utility.dart';
import 'package:s3roflit/src/config/s3/dto.dart';
import 'package:s3roflit/src/config/s3/request_type.dart';
import 'package:s3roflit/yandex_cloud/constants.dart';

final class S3Config with PreparedData {
  final YandexAccess access;
  final String canonicalRequest;
  final String canonicalQuerystring;

  final List<int> requestBody;
  final RequestType requestType;
  final Map<String, String> headers;
  final String bucketName;

  S3Config({
    required this.canonicalRequest,
    required this.requestType,
    required this.headers,
    required this.access,
    this.canonicalQuerystring = '',
    this.requestBody = const [],
    this.bucketName = '',
  });

  signing() {
    final dateYYYYmmDD = Utility.dateYYYYmmDD;
    final xAmzDateHeader = Utility.xAmzDateHeader;
    final bucket = bucketName.isNotEmpty ? '$bucketName.' : '';
    final payloadHash = S3Utility.hashSha256(requestBody);
    //
    final headersS3Signature = _headersS3Signature(
      access: access,
      headers: headers,
      xAmzDateHeader: xAmzDateHeader,
      bucket: bucket,
      payloadHash: payloadHash,
    );
    log('>>> S3 HEADERS: $headersS3Signature');
    final canonicalS3Request = _canonicalS3Request(
      requestType: requestType,
      payloadHash: payloadHash,
      headersS3Signature: headersS3Signature,
      canonicalRequest: canonicalRequest,
      canonicalQuerystring: canonicalQuerystring,
    );
    log('>>> S3 CANONICAL: $canonicalS3Request');
    final s3Signature = _signature(
      access: access,
      headersS3Signature: headersS3Signature,
      canonicalS3Request: canonicalS3Request,
      dateYYYYmmDD: dateYYYYmmDD,
      xAmzDateHeader: xAmzDateHeader,
    );
    log('>>> S3 SIGNATURE: $s3Signature');
    final s3Headers = _header(
      headersS3Signature: headersS3Signature,
      signature: s3Signature,
    );
    log('>>> S3 HEADER: $s3Headers');
    final queryString = canonicalQuerystring.isNotEmpty ? '?$canonicalQuerystring' : '';

    return YandexRequestDto(
      url: Uri.parse('https://$bucket${YCConstant.host}$canonicalRequest$queryString'),
      headers: s3Headers,
      typeRequest: requestType,
      // body: utf8.encode(requestBody), // return sha256.convert(utf8.encode(value)).toString();
      body: requestBody,
    );
  }
}

mixin PreparedData {
  // Defining the headers that will be used in the request.
  Map<String, String> _headersS3Signature({
    required YandexAccess access,
    required Map<String, String> headers,
    required String xAmzDateHeader,
    String bucket = '',
    String payloadHash = '',
  }) {
    final defaultHeaders = {
      'host': '$bucket${access.host}',
      'x-amz-date': xAmzDateHeader,
    };

    if (payloadHash.isNotEmpty) {
      defaultHeaders.addAll({'x-amz-content-sha256': payloadHash});
    }

    for (var key in headers.keys) {
      final titleKey = key.toLowerCase();
      final value = headers[key]!;
      defaultHeaders.addAll({titleKey: value});
    }

    if (!defaultHeaders.containsKey('content-type')) {
      defaultHeaders['content-type'] = 'application/x-amz-json-1.1';
    }

    return defaultHeaders;
  }

  // Definition of a canonical query.
  String _canonicalS3Request({
    required RequestType requestType,
    required String payloadHash,
    required Map<String, String> headersS3Signature,
    required String canonicalRequest,
    required String canonicalQuerystring,
  }) {
    final canonicalHeaders = <String>[];
    headersS3Signature.forEach((key, value) {
      canonicalHeaders.add('$key:$value\n');
    });

    final canonicalHeadersString = (canonicalHeaders..sort()).join('');
    //
    final keyList = headersS3Signature.keys.map((e) => e.toLowerCase()).toList()..sort();
    final signedHeaderKeys = keyList.join(';');
    //
    //
    return '${requestType.value}\n'
        '$canonicalRequest\n'
        '$canonicalQuerystring\n'
        '$canonicalHeadersString\n'
        '$signedHeaderKeys\n'
        '$payloadHash';
  }

  String _signature({
    required YandexAccess access,
    required Map<String, String> headersS3Signature,
    required String canonicalS3Request,
    required String dateYYYYmmDD,
    required String xAmzDateHeader,
  }) {
    const algorithm = 'AWS4-HMAC-SHA256';
    final credentialScope =
        '$dateYYYYmmDD/${access.region}/${YCConstant.service}/${YCConstant.aws4Request}';
    //
    final stringToSign = '$algorithm\n$xAmzDateHeader\n$credentialScope\n'
        '${S3Utility.hashSha256(utf8.encode(canonicalS3Request))}';

    //
    final signature = S3Utility.getSignature(
      secretKey: access.secretKey,
      dateStamp: dateYYYYmmDD,
      regionName: YCConstant.region,
      serviceName: YCConstant.service,
      stringToSign: stringToSign,
    );
    //
    final keyList = headersS3Signature.keys.toList()..sort();
    final signedHeaderKeys = keyList.join(';');
    //
    return '$algorithm '
        'Credential=${access.accessKey}/$credentialScope, '
        'SignedHeaders=$signedHeaderKeys, '
        'Signature=$signature';
  }

  Map<String, String> _header({
    required Map<String, String> headersS3Signature,
    required String signature,
  }) {
    return {
      'Accept': '*/*',
      'Authorization': signature,
      ...headersS3Signature,
    };
  }
}

abstract final class S3Utility {
  static String hashSha256(List<int> value) {
    return sha256.convert(value).toString();
  }

  static dynamic sign({required List<int> key, required String msg}) {
    return Hmac(sha256, key).convert(utf8.encode(msg));
  }

  static String getSignature({
    required String secretKey,
    required String dateStamp,
    required String regionName,
    required String serviceName,
    required String stringToSign,
  }) {
    final kDate = Hmac(sha256, utf8.encode('AWS4$secretKey')).convert(utf8.encode(dateStamp)).bytes;

    final kRegion = sign(key: kDate, msg: regionName).bytes;
    final kService = sign(key: kRegion, msg: serviceName).bytes;
    final kSigning = sign(key: kService, msg: YCConstant.aws4Request).bytes;
    return sign(key: kSigning, msg: stringToSign).toString();
  }
}
