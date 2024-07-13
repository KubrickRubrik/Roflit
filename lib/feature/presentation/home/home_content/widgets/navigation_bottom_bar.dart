import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/config/tag_debounce.dart';
import 'package:roflit/feature/common/providers/file_manager/provider.dart';
import 'package:roflit/feature/common/providers/ui/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';

class SectionContentNavigationBottomBar extends HookConsumerWidget {
  const SectionContentNavigationBottomBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(uiBlocProvider.notifier);
    final stateLeftButtonHover = useState(false);
    final stateCenterButtonHover = useState(false);
    final stateRightButtonHover = useState(false);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          const SizedBox(width: 10),
          InkWell(
            onTap: bloc.menuBucket,
            onHover: (value) {
              stateLeftButtonHover.value = value;
            },
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                borderRadius: borderRadius10,
                color: stateLeftButtonHover.value
                    ? const Color(AppColors.bgDarkGrayHover)
                    : const Color(AppColors.bgDarkGray1),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: () {
                EasyThrottle.throttle(
                  Tags.selectFileManager,
                  const Duration(seconds: 1),
                  () {
                    ref.read(fileManagerBlocProvider.notifier).getFiles();
                  },
                );
              },
              onHover: (value) {
                stateCenterButtonHover.value = value;
              },
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.ease,
                  height: 48,
                  decoration: BoxDecoration(
                    color: stateCenterButtonHover.value
                        ? const Color(AppColors.bgDarkGrayHover)
                        : const Color(AppColors.bgDarkGray1),
                    borderRadius: borderRadius8,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Выбрать файлы для загрузки',
                    style: appTheme.textTheme.title2.bold.onDark2,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {},
            onHover: (value) {
              stateRightButtonHover.value = value;
            },
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                borderRadius: borderRadius10,
                color: stateRightButtonHover.value
                    ? const Color(AppColors.bgDarkGrayHover)
                    : const Color(AppColors.bgDarkGray1),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
