import 'package:collection/collection.dart';
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
    @Default(AccountConfigEntity()) AccountConfigEntity config,
  }) = _AccountEntity;

  const AccountEntity._();

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
      storages: storageDto != null ? [StorageEntity.fromDto(storageDto)] : [],
      config: AccountConfigEntity(
        isOnUpload: accountDto.isOnUpload,
        isOnDownload: accountDto.isOnDownload,
        action: ActionFirst.values.byName(accountDto.action.name),
      ),
    );
  }

  factory AccountEntity.empty() {
    return const AccountEntity(
      idAccount: -1,
      name: '',
      localization: AppLocalization.ru,
      storages: [],
    );
  }

  StorageEntity? get activeStorage {
    return storages.firstWhereOrNull((v) {
      return v.idStorage == activeIdStorage;
    });
  }
}

@freezed
class AccountConfigEntity with _$AccountConfigEntity {
  const factory AccountConfigEntity({
    @Default(true) bool isOnUpload,
    @Default(true) bool isOnDownload,
    @Default(ActionFirst.upload) ActionFirst action,
  }) = _AccountConfigEntity;

  const AccountConfigEntity._();

  bool get isOn => isOnUpload && action.isUpload || isOnDownload && action.isDownload;
}
