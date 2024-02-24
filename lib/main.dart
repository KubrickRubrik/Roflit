import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/config/constants.dart';
import 'package:roflit/feature/common/observer/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'feature/presentation/main/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    const windowOptions = WindowOptions(
      fullScreen: false,
      skipTaskbar: true,
      center: true,
      minimumSize: Constants.minimumSizeWindow,
      maximumSize: Constants.maximumSizeWindow,
      alwaysOnTop: false,
      backgroundColor: Colors.transparent,
      titleBarStyle: TitleBarStyle.normal,
      title: 'Roflit',
      windowButtonVisibility: false,
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const MainScreen(),
    );
  }
}
