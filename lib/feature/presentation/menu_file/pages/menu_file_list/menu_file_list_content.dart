import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/feature/common/providers/file_manager/provider.dart';
import 'package:roflit/feature/common/widgets/loader.dart';
import 'package:roflit/feature/presentation/menu_file/pages/menu_file_list/widgets/menu_file_list_content_empty.dart';
import 'package:roflit/feature/presentation/menu_file/pages/menu_file_list/widgets/menu_file_list_content_loaded.dart';

class MenuFileListContent extends ConsumerWidget {
  const MenuFileListContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loaderPage = ref.watch(fileManagerBlocProvider.select((v) {
      return v.loaderPage;
    }));

    return switch (loaderPage) {
      ContentStatus.loading => const Loader(),
      ContentStatus.loaded => const MenuFileListContentLoaded(),
      _ => const MenuFileListContentEmpty(),
    };
  }
}
