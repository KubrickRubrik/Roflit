import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/core/utils/hooks.dart';
import 'package:roflit/feature/common/providers/buckets/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/home_content_text_field.dart';

class HomeContentCreateBucket extends HookConsumerWidget {
  final bool isHoverBuckets;
  const HomeContentCreateBucket({required this.isHoverBuckets});

  String title({required bool isOpen}) {
    if (isOpen) return 'Создать бакет'.translate;
    return 'Новый бакет'.translate;
  }

  Color? _color({required bool buttonHover, required bool menuHover}) {
    if (menuHover) {
      if (buttonHover) return const Color(AppColors.bgLightGrayOpacity20);
      return const Color(AppColors.bgLightGrayOpacity10);
    }
    if (buttonHover) return const Color(AppColors.bgLightGrayOpacity10);
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(bucketsBlocProvider.notifier);
    final controller = useTextEditingController();

    final stateHover = useState(false);
    final stateOpenMenu = useState(false);
    final stateActiveStatus = useState(BucketCreateAccess.private);

    useInitState(
      onBuild: () {
        if (!isHoverBuckets) {
          stateOpenMenu.value = false;
          stateActiveStatus.value = BucketCreateAccess.private;
        }
      },
      keys: [isHoverBuckets],
    );

    return Column(
      children: [
        _HomeContentCreateBucket(
          controller: controller,
          stateOpen: stateOpenMenu,
          stateBucketStatus: stateActiveStatus,
        ),
        InkWell(
          onTap: () async {
            if (!stateOpenMenu.value) {
              stateOpenMenu.value = true;
            } else {
              final result = await bloc.createBucket(
                bucketName: controller.text,
                access: stateActiveStatus.value,
              );
              if (result) {
                controller.text = '';
                stateOpenMenu.value = false;
                stateActiveStatus.value = BucketCreateAccess.private;
              }
            }
          },
          onHover: (value) {
            stateHover.value = value;
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.ease,
            height: 40,
            margin: const EdgeInsets.only(left: 8, right: 8, bottom: 0),
            decoration: BoxDecoration(
              color: _color(buttonHover: stateHover.value, menuHover: stateOpenMenu.value),
              borderRadius: borderRadius4,
            ),
            alignment: Alignment.center,
            child: Text(
              title(isOpen: stateOpenMenu.value),
              style: appTheme.textTheme.control2.onDark1,
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeContentCreateBucket extends StatelessWidget {
  final TextEditingController controller;
  final ValueNotifier<bool> stateOpen;
  final ValueNotifier<BucketCreateAccess> stateBucketStatus;

  const _HomeContentCreateBucket({
    required this.controller,
    required this.stateOpen,
    required this.stateBucketStatus,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      sizeCurve: Curves.ease,
      crossFadeState: (!stateOpen.value) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: const SizedBox.shrink(),
      secondChild: secondChild,
    );
  }

  Widget get secondChild {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 8, right: 8),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: stateOpen.value ? const Color(AppColors.bgDarkGray2) : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: HomeContentTextField(
              controller: controller,
              hint: 'Название бакета'.translate,
              hintStyle: appTheme.textTheme.title2.onDark2,
            ),
          ),
          const SizedBox(height: 12),
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    stateBucketStatus.value = BucketCreateAccess.public;
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.ease,
                    height: 40,
                    decoration: BoxDecoration(
                      color: stateBucketStatus.value.isPublic
                          ? const Color(AppColors.bgLightGrayOpacity10)
                          : null,
                      borderRadius: borderRadius8,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Публичный'.translate,
                      style: appTheme.textTheme.control2.onDark1,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () {
                    stateBucketStatus.value = BucketCreateAccess.private;
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.ease,
                    height: 40,
                    decoration: BoxDecoration(
                      color: stateBucketStatus.value.isPrivate
                          ? const Color(AppColors.bgLightGrayOpacity10)
                          : null,
                      borderRadius: borderRadius8,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Приватный'.translate,
                      style: appTheme.textTheme.control2.onDark1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
