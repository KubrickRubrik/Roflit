class Result {
  final bool sendOk;
  final int? statusCode;
  final Object? success;
  final bool failed;
  final String? message;

  Result.success({
    required this.success,
    this.statusCode,
  })  : sendOk = (statusCode ?? 0) >= 200 && (statusCode ?? 0) < 300,
        failed = false,
        message = null;

  Result.failuer({
    required this.message,
    this.statusCode,
    this.success,
  })  : sendOk = false,
        failed = true;
}
