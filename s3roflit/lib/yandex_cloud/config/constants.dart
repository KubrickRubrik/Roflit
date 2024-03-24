abstract final class YCConstant {
  static const url = 'https://storage.yandexcloud.net';
  static const host = 'storage.yandexcloud.net';
  static const region = 'ru-central1';
  static const service = 's3';
  static const aws4Request = 'aws4_request';
}

enum RequestType {
  get,
  put,
  delete,
  post;

  bool get isGet => this == get;
  bool get isPut => this == put;
  bool get isDelete => this == delete;
  bool get isPost => this == post;

  String get value => toString().split('.').last.toUpperCase();

  const RequestType();
}
