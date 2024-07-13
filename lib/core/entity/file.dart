import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'file.freezed.dart';

@freezed
class FileEntity with _$FileEntity {
  const factory FileEntity({
    required String name,
    required File file,
  }) = _FileEntity;
}
