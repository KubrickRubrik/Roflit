import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/services/bite_converter.dart';
import 'package:roflit/feature/common/providers/api_observer/provider.dart';
import 'package:roflit/feature/common/providers/file_download/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/label_banner_item.dart';

class DownloadObjectItem extends HookConsumerWidget {
  final int index;
  const DownloadObjectItem({
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final bloc = ref.watch(fileManagerBlocProvider.notifier);
    final downloadObject = ref.watch(downloadBlocProvider.select((v) {
      return v.items.elementAtOrNull(index);
    }));

    final stateHover = useState(false);

    if (downloadObject == null) return const SizedBox();

    return DownloadProgressBar(
      idBootloader: downloadObject.id,
      child: InkWell(
        onTap: () {},
        onHover: (value) {
          stateHover.value = value;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.ease,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: borderRadius12,
            color: stateHover.value ? const Color(AppColors.bgDarkGray2) : null,
          ),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Container(
                height: 36,
                width: 36,
                margin: const EdgeInsets.only(left: 6),
                decoration: BoxDecoration(
                  borderRadius: borderRadius8,
                  color: const Color(
                    AppColors.bgDarkGray1,
                  ),
                ),
                child: ObjectItemBunner(
                  type: downloadObject.object.type,
                  localPath: downloadObject.object.localPath ?? '',
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
                        downloadObject.object.objectKey,
                        overflow: TextOverflow.ellipsis,
                        style: appTheme.textTheme.caption1.bold.onDark1,
                      ),
                      Text(
                        ByteConverter.fromBytes(downloadObject.object.size).toHumanReadable(),
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
      ),
    );
  }
}

class DownloadProgressBar extends ConsumerWidget {
  final int idBootloader;
  final Widget child;
  const DownloadProgressBar({
    required this.child,
    required this.idBootloader,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final percentage = ref.watch(apiObserverBlocProvider.select((v) {
      if (v.download?.idBootloader == idBootloader) {
        return v.download?.observe.percentage;
      }
      return null;
    }));

    if (percentage == null) return child;

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(borderRadius: borderRadius8),
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  flex: 100 - percentage,
                  child: const SizedBox.shrink(),
                ),
                Flexible(
                  flex: percentage,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: borderRadius8,
                      gradient: const LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          Color(0x42000000),
                          Color(0x0A000000),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        child,
      ],
    );
  }
}
