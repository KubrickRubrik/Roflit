import 'dart:async';

import 'dart:io';
import 'dart:math';


import 'package:collection/collection.dart';
import 'package:drift/drift.dart' as drift;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/config/tag_debounce.dart';
import 'package:roflit/core/entity/bucket.dart';
import 'package:roflit/core/entity/meta_object.dart';
import 'package:roflit/core/entity/storage.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/providers/di_service.dart';
import 'package:roflit/core/providers/roflit_service.dart';
import 'package:roflit/data/local/api_db.dart';
import 'package:s3roflit/s3roflit.dart';

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

        _getBuckets();
      });
    });
  }

  Future<void> _getBuckets() async {
    final roflitService = ref.read(roflitServiceProvider(state.activeStorage));

    final currentIdStorage = state.activeStorage!.idStorage;
    state = state.copyWith(
      loaderPage: ContentStatus.loading,
      buckets: [],
    );

    final dto = roflitService.roflit.buckets.get();

    final response = await ref.watch(diServiceProvider).apiRemoteClient.send(dto);

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
    final response = await ref.watch(diServiceProvider).apiRemoteClient.send(
          dto,
        );

    print('>>>> ${response.sendOk} ${response.statusCode}');
    if (!response.sendOk) {
      //TODO add snackbar
      return false;
    }

    final dtoBucket = roflitService.roflit.buckets.get();

    final responseBucket = await ref.watch(diServiceProvider).apiRemoteClient.send(dtoBucket);

    if (currentIdStorage != state.activeStorage?.idStorage) return false;

    final buckets = roflitService.serizalizer.buckets(responseBucket.success);

    state = state.copyWith(buckets: buckets);
    final indexBucket = state.buckets.indexWhere((bucket) {
      return bucket.bucket == bucketName;
    });
    unawaited(setActiveBucket(indexBucket));

    return true;
  }

  Future<bool> deleteBucket() async {
    if (state.activeStorage?.activeBucket?.isNotEmpty == false) {
      return false;
    }

    final roflitService = ref.read(roflitServiceProvider(state.activeStorage));
    final currentIdStorage = state.activeStorage!.idStorage;
    final activeBucket = state.activeStorage!.activeBucket!;

    // Запрос всех обьектов
    final resultDeleteObjects = await _deleteAllObject(activeBucket: activeBucket);
    if (resultDeleteObjects == false) {
      return false;
    }

    final dto = roflitService.roflit.buckets.delete(bucketName: activeBucket);
    final response = await ref.watch(diServiceProvider).apiRemoteClient.send(dto);

    if (!response.sendOk) {
      if (response.statusCode == 409) {
        //TODO add snackbar удалить все обьекты сначала
      }
      //TODO add snackbar
      return false;
    }

    if (currentIdStorage != state.activeStorage?.idStorage) return false;

    final updatedStorage = StorageTableCompanion(
      idStorage: drift.Value(state.activeStorage!.idStorage),
      activeBucket: const drift.Value(null),
    );

    final responseBucket =
        await ref.read(diServiceProvider).apiLocalClient.storageDao.updateStorage(
              storage: updatedStorage,
            );

    if (!responseBucket) {
      //TODO SNACKBAR
      return false;
    }

    final bucketList = state.buckets.toList();
    bucketList.removeWhere((v) => v.bucket == activeBucket);

    state = state.copyWith(
      activeStorage: state.activeStorage!.copyWith(
        activeBucket: null,
      ),
      buckets: bucketList,
    );
    return true;
  }

  Future<bool?> _deleteAllObject({required String activeBucket}) async {
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
      return false;
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

  Future<void> getFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      //TODO: snackbar
      return;
    }

    final file = File(result.files.single.path!);
    await _upload(file);
  }

  Future<bool> _upload(File file) async {
    if (state.activeStorage?.activeBucket?.isNotEmpty == false) {
      return false;
    }
    final roflitService = ref.read(roflitServiceProvider(state.activeStorage));
    final currentIdStorage = state.activeStorage!.idStorage;
    final activeBucket = state.activeStorage!.activeBucket!;
    final mime = file.path.split('.').last;
    final mimeType = mime.isNotEmpty ? '.$mime' : '';
    final dto = roflitService.roflit.objects.upload(
      bucketName: activeBucket,
      objectKey: Random().nextInt(999).toString() + mimeType,
      headers: ObjectUploadHadersParameters(bodyBytes: file.readAsBytesSync()),
      body: file.readAsBytesSync(),
    );

    final response = await ref.watch(diServiceProvider).apiRemoteClient.send(dto);
    return false;
  }
}
