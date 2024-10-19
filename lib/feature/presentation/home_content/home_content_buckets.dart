import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/feature/common/providers/buckets/provider.dart';

import 'home_content_buckets/home_content_buckets_empty.dart';
import 'home_content_buckets/home_content_buckets_loaded.dart';
import 'home_content_buckets/home_content_buckets_loading.dart';

class HomeContentBuckets extends ConsumerWidget {
  const HomeContentBuckets({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bucketsBlocProvider.select((state) {
      return state.loaderPage;
    }));

    switch (state) {
      case ContentStatus.loading:
        return const HomeContentBucketsLoading();
      case ContentStatus.loaded:
      case ContentStatus.total:
        return const HomeContentBucketsLoaded();
      case ContentStatus.empty:
      case ContentStatus.error:
        return const HomeContentBucketsEmpty();
    }
  }
}
