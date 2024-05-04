import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:s3roflit/yandex_cloud/config/s3/dto.dart';
import 'package:xml/xml.dart';

final class ApiRemoteClient {
  Future<Result> smRequest(YandexRequestDto client) async {
    try {
      final response = await http.get(
        client.url,
        headers: client.headers,
      );
      // log(response.statusCode.toString());
      // log(response.body);
      return Result.success(response);
    } catch (e) {
      // log(e.toString());
      return Result.failuer();
    }
  }
}

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
