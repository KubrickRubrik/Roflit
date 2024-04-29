import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roflit/feature/common/async_state.dart';
import 'package:roflit/feature/common/widgets/progress.dart';
import 'package:roflit/helper_remove/main/bloc/notifier.dart';

class ContentMainProgress extends ConsumerWidget {
  const ContentMainProgress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainNotifierProvider);

    return state.maybeWhen(
      loading: ([value]) {
        return const AppBarProgress();
      },
      orElse: () {
        return const SizedBox.shrink();
      },
    );
  }
}
