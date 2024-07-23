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
import 'package:roflit/feature/common/providers/api_observer/provider.dart';
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
    state = state.copyWith(
      config: state.config.copyWith(
        isActiveProccess: true,
      ),
    );

    for (var i = 0; i < state.bootloaders.length; i++) {
      if (!state.config.isOn || state.bootloaders.isEmpty) return;
      // Формирование списка активности
      final bootloader = _getBootloader();
      if (bootloader == null) break;
      // Выполнение активности над списком.
      final response = await switch (bootloader.action) {
        ActionBootloader.upload => _uploadObject(bootloader),
        ActionBootloader.download => _downloadObject(bootloader),
      };

      if (!response) {
        if (bootloader.action.isUpload) {
          //TODO add snackbar
          print('>>>> Error 1');
        } else {
          //TODO add snackbar
          print('>>>> Error 2');
        }
        break;
      }
      final bootloaders = state.bootloaders.toList();
      bootloaders.removeWhere((v) {
        return v.id == bootloader.id;
      });

      state = state.copyWith(
        bootloaders: bootloaders,
      );
    }

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

    setBootloadersStatus(bootloader, status: BootloaderStatus.proccess);

    final observer = ref.watch(apiObserverBlocProvider.notifier);

    observer.createUploadObserver(bootloader.id);
    final roflitService = ref.read(roflitServiceProvider(storage));

    final dto = roflitService.roflit.objects.upload(
      bucketName: bootloader.object.bucket,
      objectKey: bootloader.object.objectKey,
      headers: ObjectUploadHadersParameters(bodyBytes: file.readAsBytesSync()),
      body: file.readAsBytesSync(),
    );

    final response = await ref.read(diServiceProvider).apiRemoteClient.send(dto);

    observer.removeUploadObserver();

    if (!response.sendOk) {
      setBootloadersStatus(bootloader, status: BootloaderStatus.error);
      return false;
    }
    setBootloadersStatus(bootloader, status: BootloaderStatus.done);
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

  void setBootloadersStatus(
    BootloaderEntity bootloader, {
    required BootloaderStatus status,
  }) {
    final bootloaders = state.bootloaders.map((v) {
      if (v.id != bootloader.id) return v;
      return v.copyWith(status: status);
    }).toList();

    state = state.copyWith(
      bootloaders: bootloaders,
    );
  }
}
