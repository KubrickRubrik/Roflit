import 'package:flutter/foundation.dart';

import '../constants.dart';

final class YandexAccess {
  final String _accessKey;
  final String _secretKey;
  final String _host;
  final String _region;

  YandexAccess({
    required String accessKey,
    required String secretKey,
    required String host,
    required String region,
  })  : _accessKey = accessKey,
        _secretKey = secretKey,
        _host = host,
        _region = region;

  String get accessKey => _accessKey;
  String get secretKey => _secretKey;
  String get host => _host;
  String get region => _region;
}

final class YandexRequestDto {
  final Uri _url;
  final Map<String, String> _headers;
  final RequestType _typeRequest;
  final Uint8List? _body;

  YandexRequestDto({
    required Uri url,
    required Map<String, String> headers,
    required RequestType requestType,
    Uint8List? body,
  })  : _url = url,
        _headers = headers,
        _typeRequest = requestType,
        _body = body;

  Uri get url => _url;
  Map<String, String> get headers => _headers;
  RequestType get typeRequest => _typeRequest;
  Uint8List? get body => _body;
}
