abstract base class AppException {
  AppException(this.msg);
  final String msg;
}

base class ApiException extends AppException {
  ApiException(super.msg);
}
