import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/entity/storage.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/providers/di_service.dart';
import 'package:roflit/data/api_local_client.dart';
import 'package:roflit/data/local/api_db.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:uuid/uuid.dart';

part 'storage_service.g.dart';

@riverpod
StorageService storageService(StorageServiceRef ref) {
  return StorageService(
    sessionBloc: ref.watch(sessionBlocProvider.notifier),
    apiLocalClient: ref.watch(diServiceProvider).apiLocalClient,
  );
}

final class StorageService {
  final SessionBloc sessionBloc;
  final ApiLocalClient apiLocalClient;

  StorageService({
    required this.sessionBloc,
    required this.apiLocalClient,
  });

  Future<bool> createStorage({
    required int idAccount,
    required String title,
    required StorageType storageType,
    required String accessKey,
    required String secretKey,
    required String region,
  }) async {
    // if (name.isEmpty ||
    //     name.isNotEmpty && name.length < 3 ||
    //     password.isNotEmpty && password.length < 3) {
    //   //TODO snackbar
    //   return false;
    // }

    final storage = StorageEntity(
      idStorage: -1,
      idAccount: idAccount,
      title: title,
      storageType: storageType,
      link: const Uuid().v1(),
      accessKey: accessKey,
      secretKey: secretKey,
      region: region,
      activeBucket: '',
    ).toDto();

    final insertStorage = StorageTableCompanion.insert(
      idAccount: storage.idAccount,
      title: storage.title,
      storageType: storage.storageType.name,
      link: storage.link,
      accessKey: storage.accessKey,
      secretKey: storage.secretKey,
      region: storage.region,
    );

    final responseAccount = await apiLocalClient.storageDao.createStorage(storage: insertStorage);

    if (responseAccount == null) {
      return false;
      //TODO snackbar
    }

    // await Future.delayed(Duration(seconds: 3), () {});
    // await sessionBloc.loginFreeAccount(responseAccount);
    // });
    //TODO snackbar
    return true;
  }

  Future<bool> updateStorage({
    required int idStorage,
    required String title,
    required StorageType storageType,
    required String accessKey,
    required String secretKey,
    required String region,
  }) async {
    final storage = StorageEntity(
      idStorage: idStorage,
      idAccount: -1,
      title: title,
      storageType: storageType,
      activeBucket: null,
      link: const Uuid().v1(),
      accessKey: accessKey,
      secretKey: secretKey,
      region: region,
    ).toDto();

    final updateStorage = StorageTableCompanion(
      idStorage: Value(idStorage),
      title: Value(storage.title),
      storageType: Value(storage.storageType.name),
      link: Value(storage.link),
      accessKey: Value(storage.accessKey),
      secretKey: Value(storage.secretKey),
      region: Value(storage.region),
    );

    final response = await apiLocalClient.storageDao.updateStorage(storage: updateStorage);

    if (!response) {
      return false;
      //TODO snackbar
    }
    //TODO snackbar
    return true;
  }

  Future<bool> deleteStorage({required int idStorage}) async {
    final response = await apiLocalClient.storageDao.deleteStorage(idStorage: idStorage);

    if (!response) {
      return false;
      //TODO snackbar
    }
    //TODO snackbar
    return true;
  }
}
