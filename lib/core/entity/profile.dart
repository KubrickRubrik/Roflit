import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:roflit/core/entity/account_cloud.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/data/local/api_db.dart';

part 'profile.freezed.dart';

@freezed
class ProfileEntity with _$ProfileEntity {
  const factory ProfileEntity({
    required String name,
    required AvailableAppLocale language,
    @Default([]) List<AccountCloudEntity> clouds,
    String? password,
  }) = _ProfileEntity;

  factory ProfileEntity.fromDto(ProfilesDto dto) {
    return ProfileEntity(
      name: dto.name,
      language: AvailableAppLocale.values.firstWhere(
        (e) => e.name == dto.language,
        orElse: () => AvailableAppLocale.ru,
      ),
      password: dto.password,
    );
  }
}
