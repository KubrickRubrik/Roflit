import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/data/local/api_db.dart';

part 'storage.freezed.dart';

@freezed
class StorageEntity with _$StorageEntity {
  const factory StorageEntity({
    required int idStorage,
    required int idAccount,
    required String title,
    required StorageType storageType,
    required String link,
    required String accessKey,
    required String secretKey,
    required String region,
  }) = _StorageEntity;

  const StorageEntity._();

  ({
    String key,
    String value,
  }) toSecureStorage() {
    final key = link;
    final value = jsonEncode({
      'accessKey': accessKey,
      'secretKey': secretKey,
      'region': region,
    });
    return (key: key, value: value);
  }

  ({
    String accessKey,
    String secretKey,
    String region,
  }) fromSecureStorage(String jsonSecure) {
    final value = jsonDecode(jsonSecure);
    return (
      accessKey: value['accessKey'],
      secretKey: value['secretKey'],
      region: value['region'],
    );
  }

  factory StorageEntity.fromDto({
    required StorageDto storageDto,
    required StorageEntity storageSecure,
  }) {
    return StorageEntity(
      idStorage: storageDto.idStorage,
      idAccount: storageDto.idAccount,
      title: storageDto.title,
      storageType: StorageType.yxCloud.fromName(storageDto.storageType),
      link: storageDto.link,
      accessKey: storageSecure.accessKey,
      secretKey: storageSecure.secretKey,
      region: storageSecure.region,
    );
  }
}
