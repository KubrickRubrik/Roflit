import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:roflit/core/entity/object.dart';
import 'package:roflit/data/local/api_db.dart';

part 'upload_object.freezed.dart';

@freezed
class UploadObjectEntity with _$UploadObjectEntity {
  const factory UploadObjectEntity({
    required int idUpload,
    required ObjectEntity object,
  }) = _UploadObjectEntity;

  factory UploadObjectEntity.fromDto({
    required ObjectUploadDto uploadDto,
    required ObjectDto objectDto,
  }) {
    return UploadObjectEntity(
      idUpload: uploadDto.idUpload,
      object: ObjectEntity.fromDto(objectDto),
    );
  }
}
