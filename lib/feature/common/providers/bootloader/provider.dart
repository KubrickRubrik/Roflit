import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/entity/bootloader.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/providers/di_service.dart';
import 'package:roflit/core/providers/roflit_service.dart';
import 'package:roflit/core/utils/await.dart';
import 'package:s3roflit/s3roflit.dart';

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
    await Await.second(3);
    _listenerBootloaders = watchingDao.watchBootloader().listen((event) {
      state = state.copyWith(bootloaders: event);
      _startBootloaderEngine();
    });
  }

  Future<void> _startBootloaderEngine() async {
    if (state.config.isActiveProccess) return;
    if (state.bootloaders.isEmpty) return;
    if (!state.config.isOn) return;
    state = state.copyWith(config: state.config.copyWith(isActiveProccess: true));
    do {
      // Формирование списка активности
      final bootloader = _getBootloader();
      if (bootloader == null) break;

      // Выполнение активности над списком.
      final response = switch (bootloader.action) {
        ActionBootloader.upload => await _uploadObject(bootloader),
        ActionBootloader.download => await _downloadObject(bootloader),
      };

      if (!response) {
        if (bootloader.action.isUpload) {
          //TODO add snackbar
        } else {
          //TODO add snackbar
        }
        break;
      }
      final bootloaders = state.bootloaders.toList();
      state = state.copyWith(
        bootloaders: bootloaders..remove(bootloader),
      );
    } while (state.config.isOn && state.bootloaders.isNotEmpty);

    state = state.copyWith(config: state.config.copyWith(isActiveProccess: false));
  }

  BootloaderEntity? _getBootloader() {
    BootloaderEntity? bootloader;
    if (state.config.first.isUpload) {
      bootloader = state.bootloaders.firstWhereOrNull((v) => v.action.isUpload);
      bootloader ??= state.bootloaders.firstWhereOrNull((v) => v.action.isDownload);
    } else {
      bootloader = state.bootloaders.firstWhereOrNull((v) => v.action.isDownload);
      bootloader ??= state.bootloaders.firstWhereOrNull((v) => v.action.isUpload);
    }
    return bootloader;
  }

  Future<bool> _uploadObject(BootloaderEntity bootloader) async {
    final storage = await ref.read(diServiceProvider).apiLocalClient.storageDao.get(
          bootloader.idStorage,
        );

    if (storage == null) return false;
    File? file;
    try {
      file = File(bootloader.object.localPath!);
      if (!file.existsSync()) {
        await ref
            .read(diServiceProvider)
            .apiLocalClient
            .bootloaderDao
            .removeBootloader([bootloader.id]);

        return false;
      }
    } catch (e) {
      return false;
    }

    final roflitService = ref.read(roflitServiceProvider(storage));

    final dto = roflitService.roflit.objects.upload(
      bucketName: bootloader.object.bucket,
      objectKey: bootloader.object.objectKey,
      headers: ObjectUploadHadersParameters(bodyBytes: file.readAsBytesSync()),
      body: file.readAsBytesSync(),
    );

    final response = await ref.watch(diServiceProvider).apiRemoteClient.send(dto);

    if (!response.sendOk) return false;

    await ref
        .read(diServiceProvider)
        .apiLocalClient
        .bootloaderDao
        .removeBootloader([bootloader.id]);

    return true;
  }

  Future<bool> _downloadObject(BootloaderEntity bootloader) async {
    return false;
  }
}
