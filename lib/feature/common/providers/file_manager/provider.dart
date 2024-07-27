import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart' as drift;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/config/tag_debounce.dart';
import 'package:roflit/core/entity/account.dart';
import 'package:roflit/core/entity/bootloader.dart';
import 'package:roflit/core/entity/storage.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/providers/di_service.dart';
import 'package:roflit/core/providers/roflit_service.dart';
import 'package:roflit/core/utils/await.dart';
import 'package:roflit/data/local/api_db.dart';
import 'package:roflit/feature/common/providers/ui/provider.dart';
import 'package:roflit/feature/common/providers/upload/provider.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';
part 'state.dart';

@riverpod
final class FileManagerBloc extends _$FileManagerBloc {
  @override
  FileManagerState build() {
    ref.onCancel(() async {
      await _listenerActiveAccount?.cancel();
      await _listenerActiveStorage?.cancel();
    });
    return const FileManagerState();
  }

  // Removable listeners.
  StreamSubscription<AccountEntity?>? _listenerActiveAccount;
  StreamSubscription<StorageEntity?>? _listenerActiveStorage;

  Future<void> watchStorages() async {
    final watchingDao = ref.read(diServiceProvider).apiLocalClient.watchingDao;
    await _listenerActiveStorage?.cancel();

    _listenerActiveAccount = watchingDao.watchActiveAccount().listen((event) {
      if (event == null) {
        state = state.copyWith(account: null);
        return;
      }
      EasyDebounce.debounce(Tags.updateFileManager, const Duration(milliseconds: 500), () {
        state = state.copyWith(account: event);
      });
    });
  }

  Future<void> deleteFileFromList(int index) async {
    final list = state.bootloaders.toList();
    final bootloader = list.removeAt(index);

    if (state.action.isEditBootloader) {
      final insertsResponse = await ref
          .read(diServiceProvider)
          .apiLocalClient
          .bootloaderDao
          .removeBootloader([bootloader.id]);
      if (!insertsResponse) return;
    }

    final action = switch (list.isEmpty) {
      true => FileManagerAction.addBootloader,
      false => state.action,
    };

    state = state.copyWith(
      bootloaders: list,
      action: action,
    );
  }

  Future<void> onGetFiles() async {
    if (ref.read(uiBlocProvider).isDisplayedFileManagerMenu) {
      closMenu();
      return;
    }
    final idStorage = state.account?.activeStorage?.idStorage;
    final roflitService = ref.read(roflitServiceProvider(state.account?.storages.first));
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      initialDirectory: state.account?.activeStorage?.pathSelectFiles,
    );

    if (result == null || idStorage == null) {
      //TODO: snackbar
      return;
    }

    final files = result.paths.map((path) => File(path!)).toList();

    final objects = await roflitService.serizalizer.objectsFromFiles(files);
    final bootloaders = objects.mapIndexed((index, object) {
      return BootloaderEntity(
        id: 0,
        idStorage: idStorage,
        object: object,
        action: ActionBootloader.upload,
      );
    }).toList();

    state = state.copyWith(
      bootloaders: bootloaders,
      loaderPage: ContentStatus.loaded,
      action: FileManagerAction.addBootloader,
    );
    ref.read(uiBlocProvider.notifier).menuFileManager(action: ActionMenu.open);
  }

  Future<void> onAddMoreFiles() async {
    final roflitService = ref.read(roflitServiceProvider(state.account?.activeStorage));

    final idStorage = state.account?.activeStorage?.idStorage;
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      initialDirectory: state.account?.activeStorage?.pathSelectFiles,
    );

    if (result == null || idStorage == null) {
      //TODO: snackbar
      return;
    }

    final files = result.paths.map((path) => File(path!)).toList();

    final objects = await roflitService.serizalizer.objectsFromFiles(files);
    final bootloaders = objects.mapIndexed((index, object) {
      return BootloaderEntity(
        id: 0,
        idStorage: idStorage,
        object: object,
        action: ActionBootloader.upload,
      );
    }).toList();

    final currentBootloaders = state.bootloaders.toList();
    currentBootloaders.addAll(bootloaders);

    state = state.copyWith(bootloaders: currentBootloaders.toSet().toList());
  }

  Future<void> onNextBootloader() async {
    final storage = state.account?.activeStorage;
    final storageType = state.account?.activeStorage?.storageType;

    if (storage?.activeBucket?.isNotEmpty != true || storageType == null) {
      //TODO: snackbar
      return;
    }

    final objects = state.bootloaders.map((v) {
      return ObjectTableCompanion.insert(
        objectKey: v.object.objectKey,
        bucket: storage!.activeBucket!,
        type: v.object.type.name,
        storageType: storageType.name,
        localPath: drift.Value(v.object.localPath),
      );
    }).toList();

    final objectWithError = objects.firstWhereOrNull((v) {
      return v.objectKey.value.length < 3;
    });

    if (objectWithError != null) {
      //TODO: snackbar
      return;
    }

    final response = await ref.read(diServiceProvider).apiLocalClient.bootloaderDao.saveBootloader(
          idStorage: storage!.idStorage,
          objects: objects,
          action: ActionBootloader.upload,
        );

    if (!response) {
      //TODO: snackbar
      return;
    }

    closMenu();
  }

  Future<void> onEditBootloader(int index) async {
    if (ref.read(uiBlocProvider).isDisplayedFileManagerMenu) {
      closMenu();
      return;
    }

    final uploads = ref.read(uploadBlocProvider).uploads;
    final bootloader = uploads.firstWhereIndexedOrNull((currentIndex, v) {
      return index == currentIndex;
    });
    if (bootloader == null) return;

    final bootloaders = <BootloaderEntity>[];

    for (final currentBootloader in uploads) {
      if (currentBootloader.status.isProccess) continue;
      if (currentBootloader.idStorage != bootloader.idStorage) continue;
      if (currentBootloader.object.bucket != bootloader.object.bucket) continue;

      bootloaders.add(currentBootloader);
    }

    state = state.copyWith(
      bootloaders: bootloaders,
      loaderPage: ContentStatus.loaded,
      action: FileManagerAction.editBootloader,
    );

    ref.read(uiBlocProvider.notifier).menuFileManager(action: ActionMenu.open);
  }

  Future<void> onNextEditBootloader() async {
    final storage = state.account?.activeStorage;
    final storageType = state.account?.activeStorage?.storageType;

    if (storage?.activeBucket?.isNotEmpty != true || storage?.storageType == null) {
      //TODO: snackbar
      return;
    }

    final objectWithError = state.bootloaders.firstWhereOrNull((v) {
      return v.object.objectKey.length < 3;
    });

    if (objectWithError != null) {
      //TODO: snackbar
      return;
    }

    final forUpdates = state.bootloaders.where((v) => v.object.idObject != 0).toList();
    final forInserts = state.bootloaders.where((v) => v.object.idObject == 0).toList();

    final updatesObjects = forUpdates.map((v) {
      return ObjectTableCompanion(
        idObject: drift.Value(v.object.idObject),
        objectKey: drift.Value(v.object.objectKey),
        bucket: drift.Value(storage!.activeBucket!),
        type: drift.Value(v.object.type.name),
        storageType: drift.Value(storage!.storageType.name),
        localPath: drift.Value(v.object.localPath),
      );
    }).toList();

    final insertsObjects = forInserts.map((v) {
      return ObjectTableCompanion.insert(
        objectKey: v.object.objectKey,
        bucket: storage!.activeBucket!,
        type: v.object.type.name,
        storageType: storage!.storageType.name,
        localPath: drift.Value(v.object.localPath),
      );
    }).toList();

    if (updatesObjects.isNotEmpty) {
      final updatesResponse =
          await ref.read(diServiceProvider).apiLocalClient.bootloaderDao.updateBootloader(
                objects: updatesObjects,
              );

      if (!updatesResponse) {
        //TODO: snackbar
      }
    }

    if (insertsObjects.isNotEmpty) {
      final insertsResponse =
          await ref.read(diServiceProvider).apiLocalClient.bootloaderDao.saveBootloader(
                idStorage: storage!.idStorage,
                objects: insertsObjects,
                action: ActionBootloader.upload,
              );
      if (!insertsResponse) {
        //TODO: snackbar
      }
    }

    closMenu();
  }

  void closMenu() {
    ref.read(uiBlocProvider.notifier).menuFileManager(action: ActionMenu.close);
    Await.millisecond(300, call: () {
      state = state.copyWith(
        bootloaders: [],
        loaderPage: ContentStatus.loading,
        action: FileManagerAction.addBootloader,
      );
    });
  }

  void renameObject({required int index, required String name}) {
    final bootloader = state.bootloaders.elementAtOrNull(index);
    if (bootloader == null) return;

    final mimeType = bootloader.object.objectKey.split('.').last;

    final newObject = bootloader.object.copyWith(objectKey: '$name.$mimeType');

    final currentBootloaders = state.bootloaders.toList();

    currentBootloaders[index] = currentBootloaders[index].copyWith(object: newObject);

    state = state.copyWith(
      bootloaders: currentBootloaders,
    );
  }
}
