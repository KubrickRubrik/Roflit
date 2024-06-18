import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/extension/edate.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/feature/common/providers/buckets/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/label_banner_item.dart';

class BucketItem extends HookConsumerWidget {
  final int index;

  const BucketItem({
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(bucketsBlocProvider.notifier);

    final bucket = ref.watch(bucketsBlocProvider.select((value) {
      return value.buckets[index];
    }));

    final isActiveBucket = ref.watch(bucketsBlocProvider.select((v) {
      return bloc.isActiveBucket(getByIndex: index);
    }));

    final stateHover = useState(false);

    final getBgColor = useMemoized(
      () {
        if (isActiveBucket) {
          return const Color(AppColors.bgDarkGray2).withOpacity(0.5);
        } else if (stateHover.value) {
          return const Color(AppColors.bgDarkGray2).withOpacity(0.4);
        } else if (index.isOdd) {
          return const Color(AppColors.bgDarkGray2).withOpacity(0.1);
        }
        return null;
      },
      [isActiveBucket, stateHover.value],
    );

    return InkWell(
      onTap: () {
        bloc.setActiveBucket(index);
      },
      onHover: (value) {
        stateHover.value = value;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: borderRadius12,
          color: getBgColor,
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Container(
              height: 40,
              width: 40,
              margin: const EdgeInsets.only(left: 6),
              child: const LabelBannerItem(type: IconSourceType.bucket),
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
                      bucket.creationDate.toDateTime?.dayMonYear ?? '',
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
