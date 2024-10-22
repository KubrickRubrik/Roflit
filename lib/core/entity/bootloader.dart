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
    @Default(null) BootloaderCopy? copy,
    @Default(BootloaderStatus.none) BootloaderStatus status,
  }) = _BootloaderEntity;

  factory BootloaderEntity.fromDto({
    required BootloaderDto bootloaderDto,
    required ObjectDto objectDto,
  }) {
    return BootloaderEntity(
      id: bootloaderDto.id,
      idStorage: bootloaderDto.idStorage,
      object: ObjectEntity.fromDto(objectDto),
      action: ActionBootloader.values.byName(bootloaderDto.action.name),
    );
  }
}

@freezed
class BootloaderCopy with _$BootloaderCopy {
  const factory BootloaderCopy({
    required int originIdStorage,
    required String originBucket,
    required StorageType originStorageType,
    @Default(null) int? recipientIdStorage,
    @Default(null) String? recipientBucket,
    @Default(null) StorageType? recipientStorageType,
  }) = _BootloaderCopy;
}

enum BootloaderStatus {
  proccess,
  error,
  done,
  none;

  bool get isProccess => this == proccess;
  bool get isError => this == error;
  bool get isDone => this == done;
  bool get isNone => this == none;
}
