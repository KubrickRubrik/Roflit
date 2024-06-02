import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/config/tag_debounce.dart';
import 'package:roflit/core/entity/bucket.dart';
import 'package:roflit/core/entity/storage.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/providers/di_service.dart';
import 'package:roflit/feature/common/providers/s3_service.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';
part 'state.dart';

@riverpod
final class StorageBloc extends _$StorageBloc {
  @override
  StorageState build() {
    ref.onCancel(() async {
      await _listenerActiveStorage?.cancel();
    });
    return const StorageState();
  }

  // Removable listeners.
  StreamSubscription<StorageEntity?>? _listenerActiveStorage;

  Future<void> watchStorages() async {
    final watchingDao = ref.read(diServiceProvider).apiLocalClient.watchingDao;
    await _listenerActiveStorage?.cancel();

    _listenerActiveStorage = watchingDao.watchActiveStorage().listen((event) {
      if (event == null) return;
      if (state.activeStorage?.idStorage == event.idStorage) return;
      EasyDebounce.debounce(Tags.updateBuckets, const Duration(milliseconds: 500), () {
        state = state.copyWith(activeStorage: event);
        ref.read(s3ServiceProvider).setStorage(event);
        _updateBuckets();
      });
    });
  }

  Future<void> _updateBuckets() async {
    print('>>>> ${state.activeStorage?.title}');
    final currentIdStorage = state.activeStorage!.idStorage;
    state = state.copyWith(loading: ContentStatus.loading);

    final dto = ref.read(s3ServiceProvider).storage!.buckets.getList();
    print('>>>> ${dto.url}- ${dto.headers}');
    //TODO: перенести экземпляр S3Roflit в StorageState !!!!.
    state = state.copyWith(loading: ContentStatus.loaded);
    if (currentIdStorage != state.activeStorage?.idStorage) return;

    state = state.copyWith(
      buckets: [],
    );
  }
}
