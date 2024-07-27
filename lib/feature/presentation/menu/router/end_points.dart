part of 'router.dart';

abstract class RouteEndPoints {
  static const _accounts = 'accounts';
  static const _login = 'login';
  static const _account = 'account';
  static const _localization = 'localization';
  static const _password = 'password';
  static const _storages = 'storages';
  static const _bootloader = 'bootloader';
  static const _storage = 'storage';
  static const _type = 'type';
  //
  static const _storageEdit = 'storage-edit';
  static const _typeEdit = 'type-edit';

  static const _info = 'info';

  static const accounts = (
    name: _accounts,
    path: '/',
    go: '/',
    login: (
      name: _login,
      path: _login,
      go: '/$_login',
    ),
    account: (
      name: _account,
      path: _account,
      go: '/$_account',
      localization: (
        name: _localization,
        path: _localization,
        go: '/$_account/$_localization',
      ),
      storages: (
        name: _storages,
        path: _storages,
        go: '/$_account/$_storages',
        storage: (
          name: _storage,
          path: _storage,
          go: '/$_account/$_storages/$_storage',
          type: (
            name: _type,
            path: _type,
            go: '/$_account/$_storages/$_storage/$_type',
          ),
        ),
      ),
      password: (
        name: _password,
        path: _password,
        go: '/$_account/$_password',
      ),
      bootloader: (
        name: _bootloader,
        path: _bootloader,
        go: '/$_account/$_bootloader',
      ),
    ),
    storageEdit: (
      name: _storageEdit,
      path: _storageEdit,
      go: '/$_account/$_storageEdit',
      typeEdit: (
        name: _typeEdit,
        path: _typeEdit,
        go: '/$_account/$_storageEdit/$_typeEdit',
      ),
    ),
  );

  static const info = (
    name: _info,
    path: '/$_info',
    go: '/$_info',
  );
}
