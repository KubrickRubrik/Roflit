import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roflit/core/page_dto/account_page_dto.dart';
import 'package:roflit/core/page_dto/login_page_dto.dart';
import 'package:roflit/core/page_dto/storage_page_dto.dart';
import 'package:roflit/feature/presentation/menu/pages/menu_account.dart';
import 'package:roflit/feature/presentation/menu/pages/menu_account_bootloader.dart';
import 'package:roflit/feature/presentation/menu/pages/menu_account_localization.dart';
import 'package:roflit/feature/presentation/menu/pages/menu_account_storages.dart';
import 'package:roflit/feature/presentation/menu/pages/menu_accounts.dart';
import 'package:roflit/feature/presentation/menu/pages/menu_info.dart';
import 'package:roflit/feature/presentation/menu/pages/menu_login.dart';
import 'package:roflit/feature/presentation/menu/pages/menu_storage.dart';
import 'package:roflit/feature/presentation/menu/pages/menu_storage_type.dart';

part 'end_points.dart';

final GlobalKey<NavigatorState> rootMenuNavigatorKey = GlobalKey<NavigatorState>();

abstract final class MenuSettingsRouter {
  static GoRouter getRoute() {
    return GoRouter(
      debugLogDiagnostics: false,
      navigatorKey: rootMenuNavigatorKey,
      // initialLocation: RouteEndPoints.accounts.account.bootloader.go,
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
              child: const MenuInfo(),
            );
          },
        ),
        GoRoute(
          name: RouteEndPoints.accounts.name,
          path: RouteEndPoints.accounts.path,
          builder: (context, state) {
            return const MenuAccounts();
          },
          routes: [
            GoRoute(
              name: RouteEndPoints.accounts.login.name,
              path: RouteEndPoints.accounts.login.path,
              builder: (context, state) {
                final extra = convert<MenuLoginDto>(
                  value: state.extra,
                  defaul: MenuLoginDto.empty(),
                );
                return MenuLogin(menuLoginDto: extra);
              },
            ),
            GoRoute(
              name: RouteEndPoints.accounts.account.name,
              path: RouteEndPoints.accounts.account.path,
              builder: (context, state) {
                final extra = convert<MenuAccountDto>(
                  value: state.extra,
                  defaul: MenuAccountDto.empty(),
                );
                return MenuAccount(menuAccountDto: extra);
              },
              routes: [
                GoRoute(
                  name: RouteEndPoints.accounts.account.localization.name,
                  path: RouteEndPoints.accounts.account.localization.path,
                  builder: (context, state) {
                    return const MenuAccountLocalization();
                  },
                ),
                GoRoute(
                  name: RouteEndPoints.accounts.account.storages.name,
                  path: RouteEndPoints.accounts.account.storages.path,
                  builder: (context, state) {
                    return const MenuAccountStorages();
                  },
                  routes: [
                    GoRoute(
                      name: RouteEndPoints.accounts.account.storages.storage.name,
                      path: RouteEndPoints.accounts.account.storages.storage.path,
                      builder: (context, state) {
                        final extra = convert<MenuStorageDto>(
                          value: state.extra,
                          defaul: MenuStorageDto.empty(),
                        );
                        return MenuStorage(menuStorageDto: extra);
                      },
                      routes: [
                        GoRoute(
                          name: RouteEndPoints.accounts.account.storages.storage.type.name,
                          path: RouteEndPoints.accounts.account.storages.storage.type.path,
                          builder: (context, state) {
                            return const MenuStorageType();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                GoRoute(
                  name: RouteEndPoints.accounts.account.bootloader.name,
                  path: RouteEndPoints.accounts.account.bootloader.path,
                  builder: (context, state) {
                    return const MenuAccountBootloader();
                  },
                ),
              ],
            ),
            GoRoute(
              name: RouteEndPoints.accounts.storageEdit.name,
              path: RouteEndPoints.accounts.storageEdit.path,
              builder: (context, state) {
                final extra = convert<MenuStorageDto>(
                  value: state.extra,
                  defaul: MenuStorageDto.empty(),
                );
                return MenuStorage(menuStorageDto: extra);
              },
              routes: [
                GoRoute(
                  name: RouteEndPoints.accounts.storageEdit.typeEdit.name,
                  path: RouteEndPoints.accounts.storageEdit.typeEdit.path,
                  builder: (context, state) {
                    return const MenuStorageType();
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
