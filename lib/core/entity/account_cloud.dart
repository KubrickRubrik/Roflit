import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:roflit/core/enums.dart';

part 'account_cloud.freezed.dart';

@freezed
class AccountCloudEntity with _$AccountCloudEntity {
  const factory AccountCloudEntity({
    required String titleLink,
    required TypeCloud typeCloud,
    required String accessKey,
    required String secretKey,
    @Default('') String region,
  }) = _AccountCloudEntity;
}
