import 'dart:async';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart' as drift;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/config/tag_debounce.dart';
import 'package:roflit/core/entity/bucket.dart';
import 'package:roflit/core/entity/storage.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/providers/di_service.dart';
import 'package:roflit/core/providers/roflit_service.dart';
import 'package:roflit/data/local/api_db.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';
part 'state.dart';

@riverpod
final class BucketsBloc extends _$BucketsBloc {
  @override
  BucketsState build() {
    ref.onCancel(() async {
      await _listenerActiveStorage?.cancel();
    });
    return const BucketsState();
  }

  // Removable listeners.
  StreamSubscription<StorageEntity?>? _listenerActiveStorage;

  bool isActiveBucket({int? getByIndex}) {
    if (getByIndex != null) {
      final bucket = state.buckets.firstWhereIndexedOrNull((index, element) {
        return index == getByIndex;
      });
      return bucket != null && bucket.bucket == state.activeStorage?.activeBucket;
    }
    return false;
  }

  Future<void> watchStorages() async {
    final watchingDao = ref.read(diServiceProvider).apiLocalClient.watchingDao;
    await _listenerActiveStorage?.cancel();

    _listenerActiveStorage = watchingDao.watchActiveStorage().listen((event) {
      if (event == null) return;
      if (state.activeStorage?.idStorage == event.idStorage) return;
      EasyDebounce.debounce(Tags.updateBuckets, const Duration(milliseconds: 500), () {
        state = state.copyWith(activeStorage: event);

        _updateContentBuckets();
      });
    });
  }

  Future<void> _updateContentBuckets() async {
    final roflitService = ref.read(roflitServiceProvider(state.activeStorage));

    final currentIdStorage = state.activeStorage!.idStorage;
    state = state.copyWith(
      loaderPage: ContentStatus.loading,
      buckets: [],
    );

    final dto = roflitService.roflit.buckets.get();

    final response = await ref.watch(diServiceProvider).apiRemoteClient.get(dto);

    state = state.copyWith(loaderPage: ContentStatus.loaded);

    if (currentIdStorage != state.activeStorage?.idStorage) return;

    final buckets = roflitService.serizalizer.buckets(response.success);
    state = state.copyWith(buckets: buckets);
  }

  Future<void> setActiveBucket(int indexBucket) async {
    final bucket = state.buckets.elementAt(indexBucket);
    if (state.loaderPage.isLoading) return;

    final updatedStorage = StorageTableCompanion(
      idStorage: drift.Value(state.activeStorage!.idStorage),
      activeBucket: drift.Value(bucket.bucket),
    );

    final response = await ref.read(diServiceProvider).apiLocalClient.storageDao.updateStorage(
          storage: updatedStorage,
        );

    if (!response) {
      //TODO SNACKBAR
      return;
    }
    state = state.copyWith(
      activeStorage: state.activeStorage!.copyWith(
        activeBucket: bucket.bucket,
      ),
    );
  }

  Future<bool> createBucket({
    required String bucketName,
    required BucketCreateAccess access,
  }) async {
    if (bucketName.isEmpty || bucketName.length < 3) {
      //TODO add snackbar
      return false;
    }
    final currentIdStorage = state.activeStorage!.idStorage;

    final roflitService = ref.read(roflitServiceProvider(state.activeStorage));

    final headerAcl = switch (access) {
      BucketCreateAccess.public => 'public-read',
      BucketCreateAccess.private => 'bucket-owner-full-control'
    };

    final dto = roflitService.roflit.buckets.create(
      bucketName: bucketName,
      headers: {
        'X-Amz-Acl': headerAcl,
      },
    );
    final response = await ref.watch(diServiceProvider).apiRemoteClient.get(
          dto,
        );

    print('>>>> ${response.statusCode}');
    if (response.statusCode != 200) {
      //TODO add snackbar
      return false;
    }

    final dtoBucket = roflitService.roflit.buckets.get();

    final responseBucket = await ref.watch(diServiceProvider).apiRemoteClient.get(dtoBucket);

    if (currentIdStorage != state.activeStorage?.idStorage) return false;

    final buckets = roflitService.serizalizer.buckets(responseBucket.success);

    state = state.copyWith(buckets: buckets);
    final indexBucket = state.buckets.indexWhere((bucket) {
      return bucket.bucket == bucketName;
    });
    unawaited(setActiveBucket(indexBucket));

    return true;
  }
  // state = state.copyWith(loaderPage: ContentStatus.loading);

  // final objectsDto =
  //     state.roflit.buckets.getObjects(bucketName: state.activeStorage!.activeBucket!);

  // final response2 = await ref.watch(diServiceProvider).apiRemoteClient.send(objectsDto);

  // if (response2.failed) {
  //   //TODO Add snackbar
  //   state = state.copyWith(loaderPage: ContentStatus.error);
  //   return;
  // }

  // final serializer = state.serizalizer.bucketObjects;

  // state = state.copyWith(loaderPage: ContentStatus.loaded);

  // if (currentIdStorage != state.activeStorage?.idStorage) return;

  // state = state.copyWith(buckets: serializer(response.success));
  // }
}
