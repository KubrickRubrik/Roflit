import 'package:flutter/foundation.dart';
import 'package:s3roflit/interface/storage_interface.dart';
import 'package:s3roflit/src/config/s3/request_type.dart';

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

final class YandexRequestDto implements StorageBucketRequestsDtoInterface {
  final Uri _url;
  final Map<String, String> _headers;
  final RequestType _typeRequest;
  final Uint8List? _body;

  YandexRequestDto({
    required Uri url,
    required Map<String, String> headers,
    required RequestType typeRequest,
    Uint8List? body,
  })  : _url = url,
        _headers = headers,
        _typeRequest = typeRequest,
        _body = body;

  @override
  Uri get url => _url;
  @override
  Map<String, String> get headers => _headers;
  @override
  RequestType get typeRequest => _typeRequest;
  @override
  Uint8List? get body => _body;
}
