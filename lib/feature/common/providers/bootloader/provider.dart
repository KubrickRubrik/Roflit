import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/entity/account.dart';
import 'package:roflit/core/entity/bootloader.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/providers/di_service.dart';
import 'package:roflit/core/providers/roflit_service.dart';
import 'package:roflit/core/utils/await.dart';
import 'package:roflit/feature/common/providers/api_observer/provider.dart';
import 'package:roflit/feature/common/providers/file_download/provider.dart';
import 'package:roflit/feature/common/providers/file_manager/provider.dart';
import 'package:roflit/feature/common/providers/file_upload/provider.dart';
import 'package:roflit_s3/roflit_s3.dart';

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
  StreamSubscription<AccountEntity?>? _listenerActiveAccount;

  Future<void> watchBootloader() async {
    final watchingDao = ref.read(diServiceProvider).apiLocalClient.watchingDao;
    await _listenerBootloaders?.cancel();
    await _listenerActiveAccount?.cancel();

    await Await.second(3);

    _listenerActiveAccount = watchingDao.watchActiveAccount().listen((event) {
      if (event != null) {
        state = state.copyWith(config: event.config);
      }
    });

    _listenerBootloaders = watchingDao.watchBootloader().listen((event) {
      state = state.copyWith(bootloaders: event);
      _startBootloaderEngine();
    });
  }

  Future<void> _startBootloaderEngine() async {
    if (state.isActiveProccess) return;
    if (state.bootloaders.isEmpty) return;
    if (!state.config.isOn) return;
    state = state.copyWith(
      isActiveProccess: true,
    );

    for (var i = 0; i < state.bootloaders.length; i++) {
      if (!state.config.isOn || state.bootloaders.isEmpty) return;
      // Forming an activity list.
      final bootloader = _getPriorityBootloader();
      if (bootloader == null) break;
      // Performing an activity on a list.
      final response = await switch (bootloader.action) {
        ActionBootloader.upload => _uploadObject(bootloader),
        ActionBootloader.download => _downloadObject(bootloader),
        ActionBootloader.copyDownload => _copyDownloadObject(bootloader),
        ActionBootloader.copyUpload => _copyUploadObject(bootloader),
      };

      if (!response) {
        if (bootloader.action.isUpload) {
          //TODO add snackbar
          log('Error');
        } else {
          //TODO add snackbar
          log('Error');
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

    state = state.copyWith(isActiveProccess: false);
  }

  BootloaderEntity? _getPriorityBootloader() {
    BootloaderEntity? bootloader;
    // Priority loading of objects, if enabled.
    if (state.config.action.isUpload) {
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

    final observer = ref.read(apiObserverBlocProvider.notifier);

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
    var storage = await ref.read(diServiceProvider).apiLocalClient.storageDao.get(
          bootloader.idStorage,
        );

    if (storage == null) return false;

    if (storage.pathSaveFiles?.isNotEmpty != true) {
      final pathSaveFiles = await ref.read(fileManagerBlocProvider.notifier).setPathToSaveFiles(
            idStorage: storage.idStorage,
          );
      storage = storage.copyWith(
        pathSaveFiles: pathSaveFiles,
      );
    }

    setBootloadersStatus(bootloader, status: BootloaderStatus.proccess);

    final observer = ref.read(apiObserverBlocProvider.notifier);

    observer.createDownloadObserver(bootloader.id);

    final roflitService = ref.read(roflitServiceProvider(storage));

    final dto = roflitService.roflit.objects.get(
      bucketName: bootloader.object.bucket,
      objectKey: bootloader.object.objectKey,
      useSignedUrl: true,
    );
    final savedStr = '${storage.pathSaveFiles!}/${bootloader.object.objectKey}';

    final response = await ref.read(diServiceProvider).apiRemoteClient.download(dto, savedStr);
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

  Future<bool> _copyDownloadObject(BootloaderEntity bootloader) async {
    return true;
  }

  Future<bool> _copyUploadObject(BootloaderEntity bootloader) async {
    return true;
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

    if (bootloader.action.isUpload) {
      ref.read(uploadBlocProvider.notifier).updateObjectStatus(
            bootloader,
            status: status,
          );
    } else {
      ref.read(downloadBlocProvider.notifier).updateObjectStatus(
            bootloader,
            status: status,
          );
    }
  }
}
