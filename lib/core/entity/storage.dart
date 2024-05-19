import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:roflit/core/enums.dart';

part 'storage.freezed.dart';

@freezed
class StorageEntity with _$StorageEntity {
  const factory StorageEntity({
    required int idStorage,
    required int idAccount,
    required String title,
    required TypeStorage storageType,
    required String link,
    required String accessKey,
    required String secretKey,
    @Default('') String region,
  }) = _StorageEntity;
}
