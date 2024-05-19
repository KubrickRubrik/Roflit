import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/data/local/api_db.dart';

part 'object.freezed.dart';

@freezed
class ObjectEntity with _$ObjectEntity {
  const factory ObjectEntity({
    required int idObject,
    required String bucket,
    required String title,
    required String? localPath,
    required TypeStorage? storageType,
  }) = _ObjectEntity;

  factory ObjectEntity.fromDto(ObjectDto dto) {
    return ObjectEntity(
      idObject: dto.idObject,
      bucket: dto.bucket,
      title: dto.title,
      localPath: dto.localPath,
      storageType: TypeStorage.values.firstWhereOrNull(
        (e) => e.name == dto.storageType,
      ),
    );
  }
}
