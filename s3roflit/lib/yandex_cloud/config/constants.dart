abstract final class YCConstant {
  static const url = 'https://storage.yandexcloud.net';
  static const host = 'storage.yandexcloud.net';
  static const region = 'ru-central1';
}

enum RequestType {
  get,
  post;

  bool get isGet => this == get;
  bool get isPost => this == post;
}
