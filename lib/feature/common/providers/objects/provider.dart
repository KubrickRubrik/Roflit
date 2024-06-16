import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/config/tag_debounce.dart';
import 'package:roflit/core/entity/object.dart';
import 'package:roflit/core/entity/storage.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/providers/di_service.dart';
import 'package:roflit/core/providers/roflit_service.dart';

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
      if (event == null) return;
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
        objects: [],
      );
      return;
    }

    state = state.copyWith(
      loaderPage: ContentStatus.loading,
      objects: [],
    );

    final dto = roflitService.roflit.buckets.getObjects(bucketName: currentActiveBucket);

    final response = await ref.watch(diServiceProvider).apiRemoteClient.send(dto);

    state = state.copyWith(loaderPage: ContentStatus.loaded);

    if (currentIdStorage != state.activeStorage?.idStorage ||
        currentActiveBucket != state.activeStorage?.activeBucket) return;

    final objects = roflitService.serizalizer.objects(response.success);
    state = state.copyWith(objects: objects);
  }
}
