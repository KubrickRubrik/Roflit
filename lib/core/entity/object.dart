import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/services/format_converter.dart';
import 'package:roflit/data/local/api_db.dart';

part 'object.freezed.dart';

@freezed
class ObjectEntity with _$ObjectEntity {
  const factory ObjectEntity({
    required String objectKey,
    required String bucket,
    required int size,
    required IconSourceType type,
    @Default(0) int nesting,
    @Default(0) int idObject,
    String? lastModified,
    String? remotePath,
    String? localPath,
    String? signedUrl,
  }) = _ObjectEntity;

  factory ObjectEntity.fromDto(ObjectDto dto) {
    return ObjectEntity(
      idObject: dto.idObject,
      objectKey: dto.objectKey,
      bucket: dto.bucket,
      localPath: dto.localPath,
      type: FormatConverter.fromDto(dto.type),
      nesting: FormatConverter.nesting(dto.objectKey),
      size: int.tryParse(dto.size) ?? 0,
      lastModified: '',
    );
  }
}
