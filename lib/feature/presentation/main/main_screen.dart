import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/feature/presentation/main/bloc/notifier.dart';
import 'package:roflit/middleware/zip_utils.dart';

import 'widgets/background.dart';
import 'widgets/content_download.dart';
import 'widgets/content_header.dart';
import 'widgets/content_loading.dart';
import 'widgets/content_main.dart';

class MainScreen extends HookConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(mainNotifierProvider.notifier);

    useInitState(
      onBuild: () {
        bloc.getData();
        return () {};
      },
    );

    return const Scaffold(
      body: MainBackgaround(
        child: Flex(
          direction: Axis.vertical,
          children: [
            ContentHeader(),
            Expanded(
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  ContentDownload(),
                  ContentMain(),
                  ContentLoading(),
                ],
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
