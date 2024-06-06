import 'package:freezed_annotation/freezed_annotation.dart';

part 'bucket.freezed.dart';

@freezed
class BucketEntity with _$BucketEntity {
  const factory BucketEntity({
    required String bucket,
    required int countObjects,
    required String creationDate,
  }) = _BucketEntity;

  // factory ObjectEntity.fromDto(ObjectDto dto) {
  //   return ObjectEntity(
  //     idObject: dto.idObject,
  //     bucket: dto.bucket,
  //     title: dto.title,
  //     localPath: dto.localPath,
  //     storageType: StorageType.values.firstWhereOrNull(
  //       (e) => e.name == dto.storageType,
  //     ),
  //   );
  // }
}
