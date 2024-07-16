import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart' as drift;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/config/tag_debounce.dart';
import 'package:roflit/core/entity/object.dart';
import 'package:roflit/core/entity/storage.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/providers/di_service.dart';
import 'package:roflit/core/providers/roflit_service.dart';
import 'package:roflit/core/utils/await.dart';
import 'package:roflit/data/local/api_db.dart';
import 'package:roflit/feature/common/providers/ui/provider.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';
part 'state.dart';

@riverpod
final class FileManagerBloc extends _$FileManagerBloc {
  @override
  FileManagerState build() {
    ref.onCancel(() async {
      await _listenerActiveStorage?.cancel();
    });
    return const FileManagerState();
  }

  // Removable listeners.
  StreamSubscription<StorageEntity?>? _listenerActiveStorage;

  Future<void> watchStorages() async {
    final watchingDao = ref.read(diServiceProvider).apiLocalClient.watchingDao;
    await _listenerActiveStorage?.cancel();

    _listenerActiveStorage = watchingDao.watchActiveStorage().listen((event) {
      if (event == null) return;
      if (state.activeStorage?.idStorage == event.idStorage &&
          state.activeStorage?.activeBucket == event.activeBucket) return;
      EasyDebounce.debounce(Tags.updateFileManager, const Duration(milliseconds: 500), () {
        state = state.copyWith(activeStorage: event);
      });
    });
  }

  void deleteFileFromList(int index) {
    final list = state.objects.toList();
    list.removeAt(index);
    state = state.copyWith(
      objects: list,
    );
  }

  Future<void> getFiles() async {
    if (ref.read(uiBlocProvider).isDisplayedFileManagerMenu) {
      closMenu();
      return;
    }

    final roflitService = ref.read(roflitServiceProvider(state.activeStorage));
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      initialDirectory: state.activeStorage?.pathSelectFiles,
    );
    if (result == null) {
      //TODO: snackbar
      return;
    }

    final files = result.paths.map((path) => File(path!)).toList();

    final objects = await roflitService.serizalizer.objectsFromFiles(files);

    state = state.copyWith(
      objects: objects,
      loaderPage: ContentStatus.loaded,
    );
    ref.read(uiBlocProvider.notifier).menuFileManager(action: ActionMenu.open);
  }

  Future<void> addMoreFiles() async {
    final roflitService = ref.read(roflitServiceProvider(state.activeStorage));
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      initialDirectory: state.activeStorage?.pathSelectFiles,
    );
    if (result == null) {
      //TODO: snackbar
      return;
    }

    final files = result.paths.map((path) => File(path!)).toList();

    final objects = await roflitService.serizalizer.objectsFromFiles(files);
    final currentObjects = state.objects.toList();
    currentObjects.addAll(objects);

    state = state.copyWith(objects: currentObjects.toSet().toList());
  }

  Future<void> addBootloader() async {
    if (state.activeStorage?.storageType == null ||
        state.activeStorage?.activeBucket?.isEmpty == true) {
      //TODO: snackbar
      return;
    }

    final objects = state.objects.map((v) {
      return ObjectTableCompanion.insert(
        objectKey: v.objectKey,
        bucket: state.activeStorage!.activeBucket!,
        type: v.type.name,
        storageType: state.activeStorage!.storageType.name,
        localPath: drift.Value(v.localPath),
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
          objects,
          ActionBootloader.upload,
        );

    if (!response) {
      //TODO: snackbar
      return;
    }

    closMenu();
  }

  Future<void> removeUploadObjects(List<int> removeUploadIds) async {
    final response = await ref
        .read(diServiceProvider)
        .apiLocalClient
        .bootloaderDao
        .removeBootloader(removeUploadIds);
  }

  void closMenu() {
    ref.read(uiBlocProvider.notifier).menuFileManager(action: ActionMenu.close);
    Await.millisecond(300, call: () {
      state = state.copyWith(
        objects: [],
        loaderPage: ContentStatus.loading,
      );
    });
  }

  void renameObject({required int index, required String name}) {
    final object = state.objects.elementAtOrNull(index);
    if (object == null) return;

    final mimeType = object.objectKey.split('.').last;

    final newObject = object.copyWith(objectKey: '$name.$mimeType');

    final currentObjects = state.objects.toList();

    currentObjects[index] = newObject;
    state = state.copyWith(
      objects: currentObjects,
    );
  }

  // Future<bool> _upload(File file) async {
  //   if (state.activeStorage?.activeBucket?.isNotEmpty == false) {
  //     return false;
  //   }
  //   final roflitService = ref.read(roflitServiceProvider(state.activeStorage));
  //   final currentIdStorage = state.activeStorage!.idStorage;
  //   final activeBucket = state.activeStorage!.activeBucket!;
  //   final mime = file.path.split('.').last;
  //   final mimeType = mime.isNotEmpty ? '.$mime' : '';
  //   final dto = roflitService.roflit.objects.upload(
  //     bucketName: activeBucket,
  //     objectKey: Random().nextInt(999).toString() + mimeType,
  //     headers: ObjectUploadHadersParameters(bodyBytes: file.readAsBytesSync()),
  //     body: file.readAsBytesSync(),
  //   );

  //   final response = await ref.watch(diServiceProvider).apiRemoteClient.send(dto);
  //   return false;
  // }
}
