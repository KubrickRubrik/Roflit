import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/config/constants.dart';

import 'feature/presentation/main/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    ProviderScope(
        child: EasyLocalization(
      supportedLocales: Constants.supportedLocales,
      path: Constants.supportedLocalesPath,
      fallbackLocale: Constants.fallackLocale,
      useOnlyLangCode: true,
      child: const MainApp(),
    )),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const MainScreen(),
    );
  }
}
