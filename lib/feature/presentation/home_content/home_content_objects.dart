import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/feature/common/providers/objects/provider.dart';

import 'home_content_objects/home_content_objects_empty.dart';
import 'home_content_objects/home_content_objects_loaded.dart';
import 'home_content_objects/home_content_objects_loading.dart';

class HomeContentObjects extends ConsumerWidget {
  const HomeContentObjects({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(objectsBlocProvider.select((state) {
      return state.loaderPage;
    }));

    switch (state) {
      case ContentStatus.empty:
      case ContentStatus.error:
        return const HomeContentObjectsEmpty();
      case ContentStatus.loading:
        return const HomeContentObjectsLoading();
      case ContentStatus.loaded:
      case ContentStatus.total:
        return const HomeContentObjectsLoaded();
    }
  }
}
