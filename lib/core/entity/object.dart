import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:roflit/data/local/api_db.dart';

part 'object.freezed.dart';

@freezed
class ObjectEntity with _$ObjectEntity {
  const factory ObjectEntity({
    required String keyObject,
    required double size,
    required String lastModified,
    @Default(0) int idObject,
    String? localPath,
  }) = _ObjectEntity;

  factory ObjectEntity.fromDto(ObjectDto dto) {
    return ObjectEntity(
      idObject: dto.idObject,
      localPath: dto.localPath,
      size: 0,
      keyObject: '',
      lastModified: '',
    );
  }
}
