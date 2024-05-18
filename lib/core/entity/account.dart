import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:roflit/core/entity/account_storage.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/data/local/api_db.dart';

part 'account.freezed.dart';

@freezed
class AccountEntity with _$AccountEntity {
  const factory AccountEntity({
    required int idAccount,
    required String name,
    required AvailableAppLocale localization,
    String? activeBucket,
    int? activeIdStorage,
    String? password,
    @Default([]) List<AccountStorageEntity> storages,
  }) = _AccountEntity;

  factory AccountEntity.fromDto({
    required AccountDto accountDto,
    required AccountStorageDto? storageDto,
  }) {
    return AccountEntity(
      idAccount: accountDto.idAccount,
      name: accountDto.name,
      localization: AvailableAppLocale.values.firstWhere(
        (e) => e.name == accountDto.localization,
        orElse: () => AvailableAppLocale.ru,
      ),
      activeBucket: accountDto.activeBucket,
      activeIdStorage: accountDto.activeIdStorage,
      password: accountDto.password,
      storages: [],
    );
  }
}
