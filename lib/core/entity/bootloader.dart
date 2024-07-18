import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:roflit/core/entity/object.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/data/local/api_db.dart';

part 'bootloader.freezed.dart';

@freezed
class BootloaderEntity with _$BootloaderEntity {
  const factory BootloaderEntity({
    required int id,
    required int idStorage,
    required ObjectEntity object,
    required ActionBootloader action,
  }) = _BootloaderEntity;

  factory BootloaderEntity.fromDto({
    required BootloaderDto uploadDto,
    required ObjectDto objectDto,
  }) {
    return BootloaderEntity(
      id: uploadDto.id,
      idStorage: uploadDto.idStorage,
      object: ObjectEntity.fromDto(objectDto),
      action: ActionBootloader.values.byName(uploadDto.action.name),
    );
  }
}
