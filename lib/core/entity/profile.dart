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
    String? password,
    @Default([]) List<AccountCloudEntity> clouds,
  }) = _ProfileEntity;

  factory ProfileEntity.fromDto({
    required ProfilesDto profileDto,
    required ProfilesCloudsDto? cloudsDto,
  }) {
    return ProfileEntity(
      name: profileDto.name,
      language: AvailableAppLocale.values.firstWhere(
        (e) => e.name == profileDto.language,
        orElse: () => AvailableAppLocale.ru,
      ),
      password: profileDto.password,
      clouds: [],
    );
  }
}
