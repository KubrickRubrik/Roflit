import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:roflit/core/entity/account_cloud.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/data/local/api_db.dart';

part 'account.freezed.dart';

@freezed
class AccountEntity with _$AccountEntity {
  const factory AccountEntity({
    required String name,
    required AvailableAppLocale localization,
    String? password,
    @Default([]) List<AccountCloudEntity> clouds,
  }) = _AccountEntity;

  factory AccountEntity.fromDto({
    required AccountsDto profileDto,
    required ProfilesCloudsDto? cloudsDto,
  }) {
    return AccountEntity(
      name: profileDto.name,
      localization: AvailableAppLocale.values.firstWhere(
        (e) => e.name == profileDto.localization,
        orElse: () => AvailableAppLocale.ru,
      ),
      password: profileDto.password,
      clouds: [],
    );
  }
}
