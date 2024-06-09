class Result {
  final int? statusCode;
  final Object? success;
  final bool failed;
  final String? message;

  Result.success({
    required this.success,
    this.statusCode,
  })  : failed = false,
        message = null;

  Result.failuer({
    required this.message,
    this.statusCode,
    this.success,
  }) : failed = true;
}
