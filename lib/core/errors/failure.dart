abstract base class Failure {
  Failure(this.msg);
  final String msg;
}

final class ApiFailure extends Failure {
  ApiFailure(super.msg);
}

final class DataFormatFailuer extends Failure {
  DataFormatFailuer(super.msg);
}
