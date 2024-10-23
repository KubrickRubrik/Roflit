// ignore_for_file: inference_failure_on_instance_creation, depend_on_referenced_packages

import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/providers/di_service.dart';
import 'package:roflit/feature/common/widgets/background.dart';
import 'package:roflit/feature/common/widgets/lines.dart';

import 'home_content/home_content.dart';
import 'home_download/home_download.dart';
import 'home_upload/home_upload.dart';

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                        child: HomeDownload(),
                      ),
                      Lines.vertical(),
                      Flexible(
                        flex: 10,
                        child: HomeContent(),
                      ),
                      Lines.vertical(),
                      Flexible(
                        flex: 3,
                        child: HomeUpload(),
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
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: const Text('DB'),
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
