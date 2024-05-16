import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:roflit/core/enums.dart';

part 'session.freezed.dart';

@freezed
class SessionEntity with _$SessionEntity {
  const factory SessionEntity({
    int? activeIdAccount,
    TypeCloud? activeTypeCloud,
  }) = _SessionEntity;
}
