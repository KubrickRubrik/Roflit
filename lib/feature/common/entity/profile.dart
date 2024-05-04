import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:roflit/feature/common/entity/account_cloud.dart';
import 'package:roflit/feature/common/enums.dart';

part 'profile.freezed.dart';

@freezed
class ProfileEntity with _$ProfileEntity {
  const factory ProfileEntity({
    required String name,
    required AvailableAppLocale language,
    @Default([]) List<AccountCloudEntity> clouds,
    String? password,
  }) = _ProfileEntity;
}
