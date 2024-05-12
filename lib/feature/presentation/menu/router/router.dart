import 'package:go_router/go_router.dart';
import 'package:roflit/feature/presentation/menu/pages/account_page.dart';
import 'package:roflit/feature/presentation/menu/pages/account_password_page.dart';
import 'package:roflit/feature/presentation/menu/pages/account_storages_cloud_page.dart';
import 'package:roflit/feature/presentation/menu/pages/account_storages_page.dart';
import 'package:roflit/feature/presentation/menu/pages/accounts_page.dart';

part 'end_points.dart';

final class MainMenuRouter {
  static GoRouter getRoute(bool val) {
    return GoRouter(
      debugLogDiagnostics: false,
      routes: [
        GoRoute(
          name: RouteEndPoints.accounts.name,
          path: RouteEndPoints.accounts.path,
          builder: (context, state) {
            return const MainMenuAccountsPage();
          },
          routes: [
            GoRoute(
              name: RouteEndPoints.accounts.account.name,
              path: RouteEndPoints.accounts.account.path,
              builder: (context, state) {
                final extra = convert<bool>(value: state.extra, defaul: false);
                return MainMenuAccountPage(isCreateAccount: extra);
              },
              routes: [
                GoRoute(
                  name: RouteEndPoints.accounts.account.password.name,
                  path: RouteEndPoints.accounts.account.password.path,
                  builder: (context, state) {
                    return const MainMenuProfilePasswordPage();
                  },
                ),
                GoRoute(
                  name: RouteEndPoints.accounts.account.storages.name,
                  path: RouteEndPoints.accounts.account.storages.path,
                  builder: (context, state) {
                    return const MainMenuAccountStoragesPage();
                  },
                  routes: [
                    GoRoute(
                      name: RouteEndPoints.accounts.account.storages.cloud.name,
                      path: RouteEndPoints.accounts.account.storages.cloud.path,
                      builder: (context, state) {
                        return const MainMenuAccountStoragesCloudPage();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
      // extraCodec: _ExtraCodec(),
    );
  }

  static T convert<T>({
    required Object? value,
    required T defaul,
  }) {
    if (value == null || value is! T) return defaul;
    return value as T;
  }

  static T? convertWithNull<T>({
    required Object? val,
    T? defaul,
  }) {
    if (val == null || val is! T) {
      if (defaul != null) return defaul;
      return null;
    }
    return val as T;
  }
}
