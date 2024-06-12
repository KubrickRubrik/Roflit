import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/services/bite_converter.dart';
import 'package:roflit/feature/common/providers/objects/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';

class ObjectItem extends HookConsumerWidget {
  final int index;

  const ObjectItem({
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(objectsBlocProvider.notifier);

    final object = ref.watch(objectsBlocProvider.select((value) {
      return value.objects[index];
    }));

    final stateHover = useState(false);

    final getBgColor = useMemoized(
      () {
        // if (isActiveBucket) {
        //   return const Color(AppColors.bgDarkGray2).withOpacity(0.5);
        // } else
        if (stateHover.value) {
          return const Color(AppColors.bgDarkGray2).withOpacity(0.4);
        } else if (index.isOdd) {
          return const Color(AppColors.bgDarkGray2).withOpacity(0.1);
        }
        return null;
      },
      [stateHover.value],
    );

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
          color: getBgColor,
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
                      object.keyObject,
                      overflow: TextOverflow.ellipsis,
                      style: appTheme.textTheme.caption1.bold.onDark1,
                    ),
                    if (object.size > 0)
                      Text(
                        ByteConverter.fromBytes(object.size).toHumanReadable(SizeUnit.mB),
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
