import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roflit/core/entity/storage.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/providers/di_service.dart';
import 'package:roflit/data/api_local_client.dart';
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
    ).toDto();

    final responseAccount = await apiLocalClient.storageDao.createStorage(storage: storage);

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
      link: const Uuid().v1(),
      accessKey: accessKey,
      secretKey: secretKey,
      region: region,
    ).toDto();

    final response = await apiLocalClient.storageDao.updateStorage(storage: storage);

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
