import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/providers/di_service.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:roflit/feature/common/widgets/lines.dart';
import 'package:roflit/helper_remove/main/widgets/background.dart';
import 'package:roflit/middleware/zip_utils.dart';

import 'content_section/content_section.dart';
import 'download_section/download_section.dart';
import 'loading_section/loading_section.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionBlocProvider);
    final bloc = ref.watch(sessionBlocProvider.notifier);

    useInitState(
      onBuild: () {
        bloc.watchSessionAndAccounts();
      },
    );

    return Material(
      child: MainBackgaround(
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: const AspectRatio(
                  aspectRatio: 1.3,
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Flexible(
                        flex: 3,
                        child: DonwloadSection(),
                      ),
                      Lines.vertical(),
                      Flexible(
                        flex: 10,
                        child: ContentSection(),
                      ),
                      Lines.vertical(),
                      Flexible(
                        flex: 3,
                        child: LoadingSection(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // GestureDetector(
                    //   onTap: () {
                    //     final db = ref.read(diProvider).apiLocalClient.
                    //     Navigator.of(context).push(MaterialPageRoute(
                    //       builder: (context) => DriftDbViewer(db),
                    //     ));
                    //   },
                    //   child: Container(
                    //     height: 100,
                    //     decoration: const BoxDecoration(color: Colors.red),
                    //     alignment: Alignment.center,
                    //     child: const Text('Добавить профили'),
                    //   ),
                    // ),
                    // const SizedBox(width: 8),
                    // GestureDetector(
                    //   onTap: () {
                    //     final db = ref.read(diProvider).apiLocalClient.dbInstance;
                    //     Navigator.of(context).push(MaterialPageRoute(
                    //       builder: (context) => DriftDbViewer(db),
                    //     ));
                    //   },
                    //   child: Container(
                    //     height: 100,
                    //     decoration: const BoxDecoration(color: Colors.red),
                    //     alignment: Alignment.center,
                    //     child: const Text('Удалить профили'),
                    //   ),
                    // ),
                    // const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        final db = ref.read(diServiceProvider).apiLocalClient.dbInstance;
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DriftDbViewer(db),
                        ));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        height: 100,
                        decoration: const BoxDecoration(color: Colors.red),
                        alignment: Alignment.center,
                        child: const Text('Смотреть базу'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
