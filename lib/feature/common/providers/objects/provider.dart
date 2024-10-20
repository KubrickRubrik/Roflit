import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/config/tag_debounce.dart';
import 'package:roflit/core/entity/meta_object.dart';
import 'package:roflit/core/entity/object.dart';
import 'package:roflit/core/entity/storage.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/providers/di_service.dart';
import 'package:roflit/core/providers/roflit_service.dart';
import 'package:roflit_s3/roflit_s3.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';
part 'state.dart';

@riverpod
final class ObjectsBloc extends _$ObjectsBloc {
  @override
  ObjectsState build() {
    ref.onCancel(() async {
      await _listenerActiveStorage?.cancel();
    });
    return const ObjectsState();
  }

  // Removable listeners.
  StreamSubscription<StorageEntity?>? _listenerActiveStorage;

  Future<void> watchStorages() async {
    final watchingDao = ref.read(diServiceProvider).apiLocalClient.watchingDao;
    await _listenerActiveStorage?.cancel();

    _listenerActiveStorage = watchingDao.watchActiveStorage().listen((event) {
      if (event == null) {
        state = state.copyWith(loaderPage: ContentStatus.empty);
        return;
      }
      if (state.activeStorage?.idStorage == event.idStorage &&
          state.activeStorage?.activeBucket == event.activeBucket) return;
      EasyDebounce.debounce(Tags.updateObjects, const Duration(milliseconds: 500), () {
        state = state.copyWith(activeStorage: event);

        _updateObjects();
      });
    });
  }

  Future<void> _updateObjects() async {
    final roflitService = ref.read(roflitServiceProvider(state.activeStorage));

    final currentIdStorage = state.activeStorage!.idStorage;
    final currentActiveBucket = state.activeStorage?.activeBucket;
    if (currentActiveBucket == null) {
      state = state.copyWith(
        items: [],
      );
      return;
    }

    state = state.copyWith(
      loaderPage: ContentStatus.loading,
      items: [],
    );

    final dto = roflitService.roflit.buckets.getObjects(
      bucketName: currentActiveBucket,
      queryParameters: const BucketListObjectParameters(maxKeys: 100),
    );

    final response = await ref.watch(diServiceProvider).apiRemoteClient.send(dto);
    state = state.copyWith(loaderPage: ContentStatus.loaded);

    if (currentIdStorage != state.activeStorage?.idStorage ||
        currentActiveBucket != state.activeStorage?.activeBucket) return;

    final items = roflitService.serizalizer.objects(response.success);
    state = state.copyWith(items: items);
  }

  Future<bool?> deleteAllObject({required String activeBucket}) async {
    final roflitService = ref.read(roflitServiceProvider(state.activeStorage));

    final listAllObjects = <String>[];
    var metaObjects = MetaObjectEntity.empty();
    var conditionToRead = true;
    var conditionToDelete = true;

    do {
      final dto = roflitService.roflit.buckets.getObjects(
        bucketName: activeBucket,
        queryParameters: BucketListObjectParameters(
          maxKeys: 1000,
          continuationToken: metaObjects.nextContinuationToken,
        ),
      );

      final response = await ref.watch(diServiceProvider).apiRemoteClient.send(dto);

      if (!response.sendOk) {
        conditionToRead = false;
        break;
      }
      //TODO Serial
      metaObjects = roflitService.serizalizer.metaObjects(response.success);
      final objects = roflitService.serizalizer.objects(response.success);

      if (objects.isEmpty) {
        conditionToRead = false;
        break;
      }
      listAllObjects.addAll(objects.map((e) => e.objectKey));
      if (!metaObjects.isTruncated) {
        conditionToRead = false;
        break;
      }
    } while (conditionToRead);

    if (listAllObjects.isEmpty) return null;
    var result = true;

    do {
      final end = listAllObjects.length < 1000 ? listAllObjects.length : 1000;

      final objectKeysString = listAllObjects.getRange(0, end).map((e) {
        return '<Object><Key>$e</Key></Object>';
      }).join('');

      final doc =
          '<?xml version="1.0" encoding="UTF-8"?><Delete><Quiet>true</Quiet>$objectKeysString</Delete>';

      final dto = roflitService.roflit.objects.deleteMultiple(
        bucketName: activeBucket,
        body: doc,
      );

      final response = await ref.watch(diServiceProvider).apiRemoteClient.send(dto);
      if (!response.sendOk) {
        conditionToDelete = false;
        result = false;
        break;
      }

      listAllObjects.removeRange(0, end);

      if (listAllObjects.isEmpty) {
        conditionToDelete = false;
        break;
      }
    } while (conditionToDelete);

    return result;
  }

  void selectObject({required String objectKey}) {
    final list = state.items.toList();
    final indexObject = list.indexWhere((v) {
      return v.objectKey == objectKey;
    });
    if (indexObject == -1) return;

    state = state.copyWith(
      items: getDirectoryObjects(
        objectKey: objectKey,
        list: list,
        isSelected: !list[indexObject].isSelected,
      ),
    );
    if (objectKey.endsWith('/')) {
    } else {
      list[indexObject] = list[indexObject].copyWith(
        isSelected: !list[indexObject].isSelected,
      );

      state = state.copyWith(
        items: list,
      );
    }
  }

  List<ObjectEntity> getDirectoryObjects({
    required String objectKey,
    required List<ObjectEntity> list,
    required bool isSelected,
  }) {
    final result = <ObjectEntity>[];
    for (final object in list) {
      final isExist = object.objectKey.startsWith(objectKey);
      if (!isExist) {
        result.add(object);
      } else {
        result.add(object.copyWith(isSelected: isSelected));
      }
    }
    return result;
  }
}
