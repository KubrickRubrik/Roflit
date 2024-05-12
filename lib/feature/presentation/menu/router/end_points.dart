part of 'router.dart';

abstract class RouteEndPoints {
  static const _accounts = 'accounts';
  static const _account = 'account';
  static const _password = 'password';
  static const _storages = 'storages';
  static const _cloud = 'cloud';

  static const accounts = (
    name: _accounts,
    path: '/',
    go: '/',
    account: (
      name: _account,
      path: _account,
      go: '/$_account',
      password: (
        name: _password,
        path: _password,
        go: '/$_account/$_password',
      ),
      storages: (
        name: _storages,
        path: _storages,
        go: '/$_account/$_storages',
        cloud: (
          name: _cloud,
          path: _cloud,
          go: '/$_account/$_storages/$_cloud',
        ),
      ),
    ),
  );
}
