import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/core/services/bite_converter.dart';
import 'package:roflit/feature/common/providers/objects/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/label_banner_item.dart';

class ObjectItem extends HookConsumerWidget {
  final int index;

  const ObjectItem({
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.read(objectsBlocProvider.notifier);
    final object = ref.watch(objectsBlocProvider.select((v) {
      return v.items.elementAtOrNull(index);
    }));

    final stateHover = useState(false);

    final getBgColor = useMemoized(
      () {
        if (stateHover.value) {
          return const Color(AppColors.bgDarkGray2).withOpacity(0.4);
        } else if (object?.isSelected == true) {
          return const Color(AppColors.bgDarkGray2).withOpacity(0.8);
        } else if (index.isOdd) {
          return const Color(AppColors.bgDarkGray2).withOpacity(0.1);
        }
        return null;
      },
      [stateHover.value, object?.isSelected, index.isOdd],
    );

    if (object == null) return const SizedBox();

    return InkWell(
      onTap: () {
        bloc.selectObject(objectKey: object.objectKey);
      },
      onHover: (value) {
        stateHover.value = value;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: borderRadius12,
          color: getBgColor,
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            // Directory gaps
            if (object.nesting >= 1)
              SizedBox(
                width: object.nesting * 38,
              ),
            // Object bunner
            if (object.type.isImage) ...[
              CachedNetworkImage(
                imageUrl: object.signedUrl ?? '',
                fit: BoxFit.cover,
                height: 30,
                width: 39,
                placeholder: (context, _) {
                  return const DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(AppColors.bgPlaceholder1),
                    ),
                  );
                },
                errorWidget: (_, mes, obj) {
                  return const DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(AppColors.bgPlaceholder1),
                    ),
                  );
                },
              ),
            ] else ...[
              Container(
                height: 30,
                width: 30,
                margin: const EdgeInsets.only(left: 6),
                child: ObjectItemBunner(
                  type: object.type,
                  remotePath: object.remotePath ?? '',
                ),
              ),
            ],
            const SizedBox(width: 8),
            // Object label
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      object.objectKey.objectName,
                      overflow: TextOverflow.ellipsis,
                      style: appTheme.textTheme.caption1.bold.onDark1,
                    ),
                    if (object.size > 0)
                      Text(
                        ByteConverter.fromBytes(object.size).toHumanReadable(),
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
