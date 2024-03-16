part of '../yandex_cloud.dart';

final class YandexRequests {
  final String _accessKey;
  final String _secretKey;
  final String _host;
  final String _region;

  YandexRequests({
    required String accessKey,
    required String secretKey,
    required String host,
    required String region,
  })  : _accessKey = accessKey,
        _secretKey = secretKey,
        _host = host,
        _region = region;

  YandexHeaders get _headers => YandexHeaders(
        accessKey: _accessKey,
        region: _region,
        secretKey: _secretKey,
        host: _host,
      );

  YandexRequestsBucket get buckets => YandexRequestsBucket(header: _headers);
  YandexRequestsObject get object => YandexRequestsObject(header: _headers);
}
