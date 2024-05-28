import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roflit/core/page_dto/account_page_dto.dart';
import 'package:roflit/core/page_dto/login_page_dto.dart';
import 'package:roflit/core/page_dto/storage_page_dto.dart';
import 'package:roflit/feature/presentation/menu/pages/account_localization_page.dart';
import 'package:roflit/feature/presentation/menu/pages/account_page.dart';
import 'package:roflit/feature/presentation/menu/pages/account_storages_page.dart';
import 'package:roflit/feature/presentation/menu/pages/accounts_page.dart';
import 'package:roflit/feature/presentation/menu/pages/info_page.dart';
import 'package:roflit/feature/presentation/menu/pages/login_page.dart';
import 'package:roflit/feature/presentation/menu/pages/storage_page.dart';
import 'package:roflit/feature/presentation/menu/pages/storage_type_page.dart';

part 'end_points.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

abstract final class MainMenuRouter {
  static GoRouter getRoute() {
    return GoRouter(
      debugLogDiagnostics: false,
      navigatorKey: rootNavigatorKey,
      // initialLocation: RouteEndPoints.accounts.account.storages.go,
      initialLocation: RouteEndPoints.accounts.go,
      routes: [
        GoRoute(
          name: RouteEndPoints.info.name,
          path: RouteEndPoints.info.path,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              transitionDuration: const Duration(milliseconds: 150),
              transitionsBuilder: _transitSlideLeft,
              child: const MainMenuInfoPage(),
            );
          },
        ),
        GoRoute(
          name: RouteEndPoints.accounts.name,
          path: RouteEndPoints.accounts.path,
          builder: (context, state) {
            return const MainMenuAccountsPage();
          },
          routes: [
            GoRoute(
              name: RouteEndPoints.accounts.login.name,
              path: RouteEndPoints.accounts.login.path,
              builder: (context, state) {
                final extra = convert<LoginPageDto>(
                  value: state.extra,
                  defaul: LoginPageDto.empty(),
                );
                return MainMenuLoginPage(loginPageDto: extra);
              },
            ),
            GoRoute(
              name: RouteEndPoints.accounts.account.name,
              path: RouteEndPoints.accounts.account.path,
              builder: (context, state) {
                final extra = convert<AccountPageDto>(
                  value: state.extra,
                  defaul: AccountPageDto.empty(),
                );
                return MainMenuAccountPage(accountPageDto: extra);
              },
              routes: [
                GoRoute(
                  name: RouteEndPoints.accounts.account.localization.name,
                  path: RouteEndPoints.accounts.account.localization.path,
                  builder: (context, state) {
                    return const MainMenuAccountLocalizationPage();
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
                      name: RouteEndPoints.accounts.account.storages.storage.name,
                      path: RouteEndPoints.accounts.account.storages.storage.path,
                      builder: (context, state) {
                        final extra = convert<StoragePageDto>(
                          value: state.extra,
                          defaul: StoragePageDto.empty(),
                        );
                        return MainMenuStoragePage(storagePageDto: extra);
                      },
                      routes: [
                        GoRoute(
                          name: RouteEndPoints.accounts.account.storages.storage.type.name,
                          path: RouteEndPoints.accounts.account.storages.storage.type.path,
                          builder: (context, state) {
                            return const MainMenuStorageTypePage();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              name: RouteEndPoints.accounts.storageEdit.name,
              path: RouteEndPoints.accounts.storageEdit.path,
              builder: (context, state) {
                final extra = convert<StoragePageDto>(
                  value: state.extra,
                  defaul: StoragePageDto.empty(),
                );
                return MainMenuStoragePage(storagePageDto: extra);
              },
              routes: [
                GoRoute(
                  name: RouteEndPoints.accounts.storageEdit.typeEdit.name,
                  path: RouteEndPoints.accounts.storageEdit.typeEdit.path,
                  builder: (context, state) {
                    return const MainMenuStorageTypePage();
                  },
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

  static Widget _transitSlideLeft(
    _,
    Animation<double> animation,
    Animation<double> secAnimation,
    Widget child,
  ) {
    const begin = Offset(-1, 0);
    const end = Offset(0, 0);
    const curve = Curves.easeOut;

    final tween = Tween(begin: begin, end: end);
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );
    return SlideTransition(
      position: tween.animate(curvedAnimation),
      child: child,
    );
  }
}
