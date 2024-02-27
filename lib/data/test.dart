// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:crypto/crypto.dart';

// String calculateSignature(String stringToSign, String secretKey) {
//   final keyBytes = utf8.encode(secretKey);
//   final hmacSha256 = Hmac(sha256, keyBytes);
//   final digest = hmacSha256.convert(utf8.encode(stringToSign));
//   return base64Encode(digest.bytes);
// }

// void signRequest(http.BaseRequest request, String accessKey, String secretKey) {
//   final now = DateTime.now().toUtc();
//   final dateStamp = '${now.year.toString().padLeft(4, '0')}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
//   final credentialScope = '$dateStamp/us-east-1/s3/aws4_request';
//   final canonicalRequest = 'GET\n${request.url.path}\n\nhost:${request.url.host}\n\nhost\n';
//   final stringToSign = 'AWS4-HMAC-SHA256\n${now.toIso8601String()}\n$credentialScope\n${sha256.convert(utf8.encode(canonicalRequest)).hex}';
//   final signature = calculateSignature(stringToSign, secretKey);
//   final authorizationHeader = 'AWS4-HMAC-SHA256 Credential=$accessKey/$credentialScope, SignedHeaders=host, Signature=$signature';
//   request.headers['Authorization'] = authorizationHeader;
//   request.headers['X-Amz-Date'] = now.toIso8601String();
// }

// void main() async {
//   final accessKey = 'YOUR_ACCESS_KEY';
//   final secretKey = 'YOUR_SECRET_KEY';
//   final bucketName = 'YOUR_BUCKET_NAME';
//   final objectKey = 'YOUR_OBJECT_KEY';

//   final url = Uri.https(bucketName, objectKey);
//   final request = http.Request('GET', url);

//   signRequest(request, accessKey, secretKey);

//   final response = await http.Client().send(request);
//   if (response.statusCode == 200) {
//     print('Success: ${response.body}');
//   } else {
//     print('Failed to load data: ${response.statusCode}');
//   }
// }