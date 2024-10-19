import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/entity/bootloader.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/providers/di_service.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';
part 'state.dart';

@riverpod
final class DownloadBloc extends _$DownloadBloc {
  @override
  DownloadState build() {
    ref.onCancel(() async {
      await _listenerDownloadsObjects?.cancel();
    });
    return const DownloadState();
  }

  // Removable listeners.
  StreamSubscription<List<BootloaderEntity>>? _listenerDownloadsObjects;

  Future<void> watchUploadObjects() async {
    final watchingDao = ref.read(diServiceProvider).apiLocalClient.watchingDao;
    await _listenerDownloadsObjects?.cancel();

    _listenerDownloadsObjects =
        watchingDao.watchBootloader(ActionBootloader.download).listen(_prepareDownloadsFile);
  }

  Future<void> _prepareDownloadsFile(List<BootloaderEntity> downloads) async {
    state = state.copyWith(items: downloads);
  }

  void updateDownloadsObjectStatus(
    BootloaderEntity bootloader, {
    required BootloaderStatus status,
  }) {
    final bootloaders = state.items.map((v) {
      if (v.id != bootloader.id) return v;
      return v.copyWith(status: status);
    }).toList();

    state = state.copyWith(
      items: bootloaders,
    );
  }

  Future<void> removeAllDownloads() async {
    final dao = ref.read(diServiceProvider).apiLocalClient.bootloaderDao;
    final ids = state.items
        .where(
          (v) => !v.status.isProccess,
        )
        .map((v) => v.id)
        .toList();
    await dao.removeBootloader(ids);
  }
}
