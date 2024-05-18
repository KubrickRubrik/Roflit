import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:roflit/core/enums.dart';

part 'account_storage.freezed.dart';

@freezed
class AccountStorageEntity with _$AccountStorageEntity {
  const factory AccountStorageEntity({
    required int idStorage,
    required int idAccount,
    required String title,
    required TypeCloud cloudType,
    required String link,
    required String accessKey,
    required String secretKey,
    @Default('') String region,
  }) = _AccountStorageEntity;
}
