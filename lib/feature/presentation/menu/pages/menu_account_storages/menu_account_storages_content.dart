import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:roflit/feature/common/widgets/loader.dart';

import 'menu_account_storages_content_empty.dart';
import 'menu_account_storages_content_loaded.dart';

class MenuStoragesContent extends ConsumerWidget {
  const MenuStoragesContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionBlocProvider);

    return state.maybeWhen(
      orElse: () => const SizedBox.shrink(),
      loading: () => const Loader(),
      loaded: (session, accounts) {
        final blocSession = ref.watch(sessionBlocProvider.notifier);
        final storages = ref.watch(sessionBlocProvider.select((v) {
          return blocSession.getAccount(getActive: true)?.storages ?? [];
        }));

        if (storages.isEmpty) {
          return const MenuStoragesContentEmpty();
        }
        return const MenuStoragesContentLoaded();
      },
    );
  }
}
