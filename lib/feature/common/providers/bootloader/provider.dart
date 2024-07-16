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
final class BootloaderBloc extends _$BootloaderBloc {
  @override
  BootloaderState build() {
    ref.onCancel(() async {
      await _listenerBootloaders?.cancel();
    });
    return const BootloaderState();
  }

  // Removable listeners.
  StreamSubscription<List<BootloaderEntity>>? _listenerBootloaders;

  Future<void> watchBootloader() async {
    final watchingDao = ref.read(diServiceProvider).apiLocalClient.watchingDao;
    await _listenerBootloaders?.cancel();

    _listenerBootloaders = watchingDao.watchBootloader().listen((event) {
      state = state.copyWith(bootloaders: event);
      _startBootloaderEngine();
    });
  }

  Future<void> _startBootloaderEngine() async {
    if (state.config.isActiveProccess) return;
    if (!state.config.isOn) return;
    state = state.copyWith(config: state.config.copyWith(isActiveProccess: true));
    do {
      // Формирование списка активности
      final bootloaders = _getBootloaders();
      if (bootloaders.isEmpty) {
        break;
      }
      // Выполнение активности над списком.
      final response = switch (bootloaders.first.action) {
        ActionBootloader.upload => await _uploadObject(bootloaders.first),
        ActionBootloader.download => await _downloadObject(bootloaders.first),
      };

      if (!response) break;
    } while (state.config.isOn && state.bootloaders.isNotEmpty);

    state = state.copyWith(config: state.config.copyWith(isActiveProccess: false));
  }

  List<BootloaderEntity> _getBootloaders() {
    final bootloaders = <BootloaderEntity>[];
    if (state.config.first.isUpload) {
      bootloaders.addAll(state.bootloaders.where((v) => v.action.isUpload));
      if (bootloaders.isEmpty) {
        bootloaders.addAll(state.bootloaders.where((v) => v.action.isDownload));
      }
    } else {
      bootloaders.addAll(state.bootloaders.where((v) => v.action.isDownload));
      if (bootloaders.isEmpty) {
        bootloaders.addAll(state.bootloaders.where((v) => v.action.isUpload));
      }
    }
    return bootloaders;
  }

  Future<bool> _uploadObject(BootloaderEntity bootloader) async {
    return false;
  }

  Future<bool> _downloadObject(BootloaderEntity bootloader) async {
    return false;
  }
}
