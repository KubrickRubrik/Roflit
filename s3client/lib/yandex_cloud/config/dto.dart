final class YandexCloudDTO {
  final String url;
  final Map<String, String> headers;
  final YandexRequestType typeRequest;

  YandexCloudDTO({
    required this.url,
    required this.headers,
    required this.typeRequest,
  });
}

enum YandexRequestType {
  get,
  post;

  bool get isGet => this == get;
  bool get isPost => this == post;
}
