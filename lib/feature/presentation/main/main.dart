import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roflit/feature/presentation/main/bloc/notifier.dart';
import 'package:roflit/generated/locale_keys.g.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainNotifierProvider);
    final bloc = ref.watch(mainNotifierProvider.notifier);

    return Scaffold(
      body: Center(
        child: Text(
          LocaleKeys.app_name.tr(),
        ),
      ),
    );
  }
}
