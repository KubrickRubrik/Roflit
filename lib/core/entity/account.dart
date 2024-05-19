import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:roflit/core/entity/storage.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/data/local/api_db.dart';

part 'account.freezed.dart';

@freezed
class AccountEntity with _$AccountEntity {
  const factory AccountEntity({
    required int idAccount,
    required String name,
    required AppLocalization localization,
    String? activeBucket,
    int? activeIdStorage,
    String? password,
    @Default([]) List<StorageEntity> storages,
  }) = _AccountEntity;

  factory AccountEntity.fromDto({
    required AccountDto accountDto,
    StorageDto? storageDto,
  }) {
    return AccountEntity(
      idAccount: accountDto.idAccount,
      name: accountDto.name,
      localization: AppLocalization.values.firstWhere(
        (e) => e.name == accountDto.localization,
        orElse: () => AppLocalization.ru,
      ),
      activeIdStorage: accountDto.activeIdStorage,
      password: accountDto.password,
      storages: [],
    );
  }

  factory AccountEntity.empty() {
    return const AccountEntity(
      idAccount: -1,
      name: '',
      localization: AppLocalization.ru,
    );
  }
}
