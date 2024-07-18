import 'dart:async';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/entity/bootloader.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/providers/di_service.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';
part 'state.dart';

@riverpod
final class UploadBloc extends _$UploadBloc {
  @override
  UploadState build() {
    ref.onCancel(() async {
      await _listenerUploadsObjects?.cancel();
    });
    return const UploadState();
  }

  // Removable listeners.
  StreamSubscription<List<BootloaderEntity>>? _listenerUploadsObjects;

  Future<void> watchUploadObjects() async {
    final watchingDao = ref.read(diServiceProvider).apiLocalClient.watchingDao;
    await _listenerUploadsObjects?.cancel();

    _listenerUploadsObjects =
        watchingDao.watchBootloader(ActionBootloader.upload).listen(_prepareUploadsFile);
  }

  Future<void> _prepareUploadsFile(List<BootloaderEntity> uploads) async {
    final currentUploads = <BootloaderEntity>[];
    final removeErrorFileUploads = <BootloaderEntity>[];

    for (final upload in uploads) {
      try {
        final size = File(upload.object.localPath!).lengthSync();
        currentUploads.add(
          upload.copyWith(
            object: upload.object.copyWith(
              size: size,
            ),
          ),
        );
      } catch (e) {
        removeErrorFileUploads.add(upload);
      }
    }

    if (removeErrorFileUploads.isNotEmpty) {
      final removeUploadIds = removeErrorFileUploads.map((v) {
        return v.id;
      }).toList();
      await ref
          .read(diServiceProvider)
          .apiLocalClient
          .bootloaderDao
          .removeBootloader(removeUploadIds);
    }

    state = state.copyWith(
      uploads: currentUploads,
    );
  }
}
