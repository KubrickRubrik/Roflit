import 'config/constants.dart';

import 'config/headers.dart';
import 'yandex_requests/requests/requests_buckets.dart';
import 'yandex_requests/requests/requests_objects.dart';

part 'yandex_requests/yandex_requests.dart';

final class YandexCloud {
  final String _accessKey;
  final String _secretKey;
  final String _host;
  final String _region;

  YandexCloud({
    required String accessKey,
    required String secretKey,
    String host = YCConstant.host,
    String region = YCConstant.region,
  })  : _accessKey = accessKey,
        _secretKey = secretKey,
        _host = host,
        _region = region;

  YandexRequests get _request => YandexRequests(
        accessKey: _accessKey,
        secretKey: _secretKey,
        host: _host,
        region: _region,
      );

  YandexRequestsBucket get buckets => _request.buckets;
  YandexRequestsObject get objects => _request.object;
}
