import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';

@freezed
class SessionEntity with _$SessionEntity {
  const factory SessionEntity({
    int? activeIdAccount,
    int? activeIdStorage,
  }) = _SessionEntity;
}
