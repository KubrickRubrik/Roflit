import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:roflit/feature/common/widgets/lines.dart';
import 'package:roflit/helper_remove/main/widgets/background.dart';
import 'package:roflit/middleware/zip_utils.dart';

import 'content_section/content_section.dart';
import 'donwload_section/donwload_section.dart';
import 'loading_section/loading_section.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionBlocProvider);
    final bloc = ref.watch(sessionBlocProvider.notifier);

    useInitState(
      onBuild: () {
        bloc.checkAuthentication();
      },
    );

    return Material(
      child: MainBackgaround(
        child: Center(
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
      ),
    );
  }
}
