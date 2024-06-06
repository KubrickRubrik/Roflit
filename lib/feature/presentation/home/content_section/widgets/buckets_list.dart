import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/feature/common/providers/storage/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';

class ContentSectionBucketsList extends StatelessWidget {
  ContentSectionBucketsList({super.key});
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
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
        child: Consumer(
          builder: (context, ref, child) {
            final buckets = ref.watch(storageBlocProvider.select((value) {
              return value.buckets;
            }));
            return ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: ListView.builder(
                controller: controller,
                primary: false,
                itemCount: buckets.length,
                padding: const EdgeInsets.only(left: 3, right: 3, bottom: 10),
                itemBuilder: (context, index) {
                  return ContenteSectionBucketsListItem(index: index);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class ContenteSectionBucketsListItem extends HookConsumerWidget {
  final int index;

  const ContenteSectionBucketsListItem({
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bucket = ref.watch(storageBlocProvider.select((value) {
      return value.buckets[index];
    }));

    final stateHover = useState(false);

    return InkWell(
      onTap: () {},
      onHover: (value) {
        stateHover.value = value;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: borderRadius12,
          color: stateHover.value ? const Color(AppColors.bgDarkGray2) : null,
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Container(
              height: 50,
              width: 50,
              margin: const EdgeInsets.only(left: 6),
              decoration: BoxDecoration(
                borderRadius: borderRadius8,
                color: const Color(
                  AppColors.bgDarkGray1,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bucket.bucket,
                      overflow: TextOverflow.ellipsis,
                      style: appTheme.textTheme.caption1.bold.onDark1,
                    ),
                    Text(
                      '${bucket.countObjects}',
                      overflow: TextOverflow.ellipsis,
                      style: appTheme.textTheme.caption2.onDark1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
