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
    required TypeCloud cloudType,
  }) = _ObjectEntity;

  factory ObjectEntity.fromDto(ObjectsDto dto) {
    return ObjectEntity(
      idObject: dto.idObject,
      bucket: dto.bucket,
      title: dto.title,
      localPath: dto.localPath,
      cloudType: TypeCloud.values.firstWhere(
        (e) => e.name == dto.cloudType,
        orElse: () => TypeCloud.none,
      ),
    );
  }
}
