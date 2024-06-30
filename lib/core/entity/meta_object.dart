import 'package:freezed_annotation/freezed_annotation.dart';

part 'meta_object.freezed.dart';

@freezed
class MetaObjectEntity with _$MetaObjectEntity {
  const factory MetaObjectEntity({
    required String? nextContinuationToken,
    required int keyCount,
    required bool isTruncated,
  }) = _MetaObjectEntity;

  factory MetaObjectEntity.empty() {
    return const MetaObjectEntity(
      nextContinuationToken: null,
      keyCount: 0,
      isTruncated: false,
    );
  }
}
