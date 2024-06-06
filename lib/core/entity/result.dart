import 'package:http/http.dart';
import 'package:xml/xml.dart';

class Result {
  late int statusCode;
  late XmlDocument? success;
  late bool failed;

  Result.success(Response response) {
    try {
      success = XmlDocument.parse(response.body);
      statusCode = response.statusCode;
      failed = false;
    } catch (e) {
      throw Exception('Error serialize');
    }
  }

  Result.failuer() {
    statusCode = 0;
    success = null;
    failed = true;
  }
}
