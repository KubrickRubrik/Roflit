import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/feature/common/providers/storage/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/widgets/bucket_item.dart';

import 'home_content_buckets_empty.dart';

class HomeContentBucketsLoaded extends HookConsumerWidget {
  const HomeContentBucketsLoaded({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useScrollController();

    final buckets = ref.watch(storageBlocProvider.select((value) {
      return value.buckets;
    }));

    if (buckets.isEmpty) {
      return const HomeContentBucketsEmpty();
    }

    return ClipRRect(
      borderRadius: borderRadius8,
      child: RawScrollbar(
        controller: controller,
        scrollbarOrientation: ScrollbarOrientation.left,
        interactive: true,
        minThumbLength: 18,
        thumbVisibility: true,
        mainAxisMargin: 0,
        crossAxisMargin: 0,
        padding: const EdgeInsets.all(0),
        thumbColor: const Color(AppColors.bgDarkGray1),
        radius: const Radius.circular(4),
        trackVisibility: true,
        trackBorderColor: Colors.transparent,
        thickness: 4,
        trackRadius: const Radius.circular(4),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: ListView.builder(
            controller: controller,
            primary: false,
            itemCount: buckets.length,
            padding: const EdgeInsets.only(left: 3, right: 3, bottom: 10),
            itemBuilder: (context, index) {
              return BucketItem(index: index);
            },
          ),
        ),
      ),
    );
  }
}
