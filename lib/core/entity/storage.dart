import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/data/local/api_db.dart';
import 'package:roflit/middleware/services/secure.dart';

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

  StorageEntity toDto() {
    return StorageEntity(
      idStorage: idStorage,
      idAccount: idAccount,
      title: title,
      storageType: storageType,
      link: link,
      accessKey: SecureService.encryptedSm(key: link, value: accessKey),
      secretKey: SecureService.encryptedSm(key: link, value: secretKey),
      region: SecureService.encryptedSm(key: link, value: region),
    );
  }

  factory StorageEntity.fromDto(StorageDto storageDto) {
    return StorageEntity(
      idStorage: storageDto.idStorage,
      idAccount: storageDto.idAccount,
      title: storageDto.title,
      storageType: StorageType.yxCloud.fromName(storageDto.storageType),
      link: storageDto.link,
      accessKey: SecureService.decryptedSm(key: storageDto.link, value: storageDto.accessKey),
      secretKey: SecureService.decryptedSm(key: storageDto.link, value: storageDto.secretKey),
      region: SecureService.decryptedSm(key: storageDto.link, value: storageDto.region),
    );
  }
}
