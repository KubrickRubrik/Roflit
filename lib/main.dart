import 'dart:io';
import 'dart:ui';

import 'package:desktop_window/desktop_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/config/constants.dart';
import 'package:roflit/core/providers/di_service.dart';
import 'package:roflit/feature/common/providers/api_observer/provider.dart';
import 'package:roflit/feature/common/providers/bootloader/provider.dart';
import 'package:roflit/feature/common/providers/buckets/provider.dart';
import 'package:roflit/feature/common/providers/file_manager/provider.dart';
import 'package:roflit/feature/common/providers/file_upload/provider.dart';
import 'package:roflit/feature/common/providers/objects/provider.dart';
import 'package:roflit/feature/common/providers/observer/provider.dart';
import 'package:roflit/feature/common/providers/ui/provider.dart';
import 'package:roflit/feature/presentation/home/home.dart';

import 'core/utils/hooks.dart';
import 'feature/common/providers/session/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  if (Platform.isWindows) {
    await DesktopWindow.setMinWindowSize(Constants.minimumSizeWindow);
    await DesktopWindow.setMaxWindowSize(Constants.maximumSizeWindow);

    // DesktopWindow.setFullScreen(true);
  }

  final observer = BlocObserver(isUsed: false);
  runApp(
    ProviderScope(
      observers: [observer],
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
            home: const Home(),
            scrollBehavior: AppScrollBehavior(),
          );
        },
      ),
    );
  }
}

class _EagerInitialization extends HookConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(diServiceProvider);
    ref.watch(uiBlocProvider.notifier);
    final sessionBloc = ref.watch(sessionBlocProvider.notifier);
    final bucketsBloc = ref.watch(bucketsBlocProvider.notifier);
    final objectsBloc = ref.watch(objectsBlocProvider.notifier);
    final fileManagerBloc = ref.watch(fileManagerBlocProvider.notifier);
    final uploadBloc = ref.watch(uploadBlocProvider.notifier);
    final bootloaderBloc = ref.watch(bootloaderBlocProvider.notifier);
    ref.watch(apiObserverBlocProvider.notifier);

    useInitState(
      onBuild: () {
        sessionBloc.watchSessionAndAccounts();
        bucketsBloc.watchStorages();
        objectsBloc.watchStorages();
        fileManagerBloc.watchStorages();
        uploadBloc.watchUploadObjects();
        bootloaderBloc.watchBootloader();
      },
    );

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
