import 'dart:io';
import 'dart:ui';

import 'package:desktop_window/desktop_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/config/constants.dart';
import 'package:roflit/core/providers/di_service.dart';
import 'package:roflit/feature/common/providers/observer/provider.dart';
import 'package:roflit/feature/common/providers/ui/provider.dart';
import 'package:roflit/feature/presentation/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  if (Platform.isWindows) {
    await DesktopWindow.setMinWindowSize(Constants.minimumSizeWindow);
    await DesktopWindow.setMaxWindowSize(Constants.maximumSizeWindow);
    // DesktopWindow.setFullScreen(true);
  }
  // if (Platform.isWindows) {
  //   await windowManager.ensureInitialized();
  //   const windowOptions = WindowOptions(
  //     fullScreen: false,
  //     skipTaskbar: true,
  //     center: true,
  //     minimumSize: Constants.minimumSizeWindow,
  //     maximumSize: Constants.maximumSizeWindow,
  //     alwaysOnTop: false,
  //     backgroundColor: Colors.transparent,
  //     titleBarStyle: TitleBarStyle.normal,
  //     title: 'Roflit',
  //     windowButtonVisibility: false,
  //   );
  //   await windowManager.waitUntilReadyToShow(windowOptions, () async {
  //     await windowManager.show();
  //     await windowManager.focus();
  //   });
  // }
  runApp(
    ProviderScope(
      observers: [
        BlocObserver(isUsed: false),
      ],
      child: EasyLocalization(
        supportedLocales: Constants.supportedLocales,
        path: Constants.supportedLocalesPath,
        fallbackLocale: Constants.fallackLocale,
        useOnlyLangCode: true,
        child: const MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _EagerInitialization(
      child: ScreenUtilInit(
        designSize: const Size(1920, 1080),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: const HomeScreen(),
            scrollBehavior: AppScrollBehavior(),
          );
        },
      ),
    );
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(diServiceProvider);
    ref.watch(uiBlocProvider);
    return child;
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
