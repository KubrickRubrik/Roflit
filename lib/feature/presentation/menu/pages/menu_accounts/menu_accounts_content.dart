import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:roflit/feature/common/widgets/loader.dart';

import 'menu_accounts_content_empty.dart';
import 'menu_accounts_content_loaded.dart';

class MenuAccountsContent extends ConsumerWidget {
  const MenuAccountsContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionBlocProvider);

    return state.maybeWhen(
      orElse: () => const SizedBox.shrink(),
      loading: () => const Loader(),
      loaded: (session, accounts) {
        if (accounts.isEmpty) {
          return const MenuAccountContentEmpty();
        } else {
          return const MenuAccountContentLoaded();
        }
      },
    );
  }
}
