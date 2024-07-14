import 'dart:async';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/entity/upload_object.dart';
import 'package:roflit/core/providers/di_service.dart';
import 'package:roflit/feature/common/providers/file_manager/provider.dart';

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
  StreamSubscription<List<UploadObjectEntity>>? _listenerUploadsObjects;

  Future<void> watchUploadObjects() async {
    final watchingDao = ref.read(diServiceProvider).apiLocalClient.watchingDao;
    await _listenerUploadsObjects?.cancel();

    _listenerUploadsObjects = watchingDao.watchUploadObjects().listen(_prepareUploadsFile);
  }

  Future<void> _prepareUploadsFile(List<UploadObjectEntity> uploads) async {
    final currentUploads = <UploadObjectEntity>[];
    final removeErrorFileUploads = <UploadObjectEntity>[];

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
        return v.idUpload;
      }).toList();

      await ref.read(fileManagerBlocProvider.notifier).removeUploadObjects(removeUploadIds);
    }

    state = state.copyWith(
      uploads: currentUploads,
    );
  }
}
