part of 'router.dart';

abstract class RouteEndPoints {
  static const _accounts = 'accounts';
  static const _login = 'login';
  static const _account = 'account';
  static const _localization = 'localization';
  static const _password = 'password';
  static const _storages = 'storages';
  static const _cloud = 'cloud';

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

  static const info = (
    name: _info,
    path: '/$_info',
    go: '/$_info',
  );
}
