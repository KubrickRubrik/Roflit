import 'dart:convert';

abstract final class SecureService {
  static String encryptedSm({required String key, required String value}) {
    final keyList = key.split('');
    final valueList = value.split('');
    final result = <String>[];
    var keyIndex = 0;
    for (var i = 0; i < valueList.length; i++) {
      if (keyIndex >= keyList.length) keyIndex = 0;
      final resultString = '${valueList[i]}${keyList[keyIndex]}';
      result.add(resultString);
      keyIndex++;
    }
    final newValue = utf8.encode(result.join()).toList().reversed.toList();
    final b = base64Encode(newValue);
    return b;
  }

  static String decryptedSm({required String key, required String value}) {
    final result = <String>[];
    final sourceString = utf8.decode(base64Decode(value)).split('').reversed.toList();
    for (var i = 0; i < sourceString.length; i++) {
      if (i.isEven) {
        result.add(sourceString[i]);
      }
    }
    return result.join();
  }
}
