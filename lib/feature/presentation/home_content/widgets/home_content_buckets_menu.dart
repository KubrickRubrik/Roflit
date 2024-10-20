import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/config/filter_text_constants.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/feature/common/providers/buckets/provider.dart';
import 'package:roflit/feature/common/providers/ui/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/content_text_field.dart';

class HomeContentBucketMenu extends HookConsumerWidget {
  const HomeContentBucketMenu();

  String title({required bool isOpen}) {
    if (isOpen) return 'Создать бакет'.translate;
    return 'Новый бакет'.translate;
  }

  Color? _color({required bool buttonHover, required bool menuHover}) {
    if (buttonHover) return const Color(AppColors.bgLightGrayOpacity10);
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(bucketsBlocProvider.notifier);
    final blocUI = ref.watch(uiBlocProvider.notifier);
    final controller = useTextEditingController();

    final stateCreateButtonHover = useState(false);
    final stateDeleteButtonHover = useState(false);
    final stateCopyButtonHover = useState(false);
    final stateDownloadButtonHover = useState(false);
    final stateActiveStatus = useState(BucketCreateAccess.private);
    final stateOpenSubMenu = useState(false);

    ref.listen(uiBlocProvider.select((v) => v.isDisplayBucketMenu), (previous, next) {
      if (!next) {
        controller.text = '';
        stateActiveStatus.value = BucketCreateAccess.private;
        stateOpenSubMenu.value = false;
        stateCreateButtonHover.value = false;
        stateDeleteButtonHover.value = false;
      }
    });

    return Column(
      children: [
        _HomeContentCreateBucket(
          controller: controller,
          stateOpenSubMenu: stateOpenSubMenu,
          stateBucketStatus: stateActiveStatus,
        ),
        InkWell(
          onTap: () async {
            if (!stateOpenSubMenu.value) {
              stateOpenSubMenu.value = true;
            } else {
              final result = await bloc.createBucket(
                bucketName: controller.text,
                access: stateActiveStatus.value,
              );
              if (result) {
                blocUI.menuBucket(action: ActionMenu.close);
              }
            }
          },
          onHover: (value) {
            stateCreateButtonHover.value = value;
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.ease,
            height: 40,
            margin: const EdgeInsets.only(left: 8, right: 8, bottom: 0),
            decoration: BoxDecoration(
              color: _color(
                  buttonHover: stateCreateButtonHover.value, menuHover: stateOpenSubMenu.value),
              borderRadius: borderRadius4,
            ),
            alignment: Alignment.center,
            child: Text(
              title(isOpen: stateOpenSubMenu.value),
              style: appTheme.textTheme.control2.onDark1,
            ),
          ),
        ),
        _HomeContentDeleteBucket(
          stateOpenSubMenu: stateOpenSubMenu,
          stateDeleteButtonHover: stateDeleteButtonHover,
        ),
        _HomeContentCopyBucket(
          stateOpenSubMenu: stateOpenSubMenu,
          stateCopyButtonHover: stateCopyButtonHover,
        ),
        _HomeContentDownloadBucket(
          stateOpenSubMenu: stateOpenSubMenu,
          stateDownloadButtonHover: stateDownloadButtonHover,
        ),
      ],
    );
  }
}

class _HomeContentCreateBucket extends StatelessWidget {
  final TextEditingController controller;
  final ValueNotifier<bool> stateOpenSubMenu;
  final ValueNotifier<BucketCreateAccess> stateBucketStatus;

  const _HomeContentCreateBucket({
    required this.controller,
    required this.stateOpenSubMenu,
    required this.stateBucketStatus,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      sizeCurve: Curves.ease,
      crossFadeState:
          (!stateOpenSubMenu.value) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
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
              color: stateOpenSubMenu.value ? const Color(AppColors.bgDarkGray2) : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ContentTextField(
              controller: controller,
              hint: 'Название бакета'.translate,
              hintStyle: appTheme.textTheme.title2.onDark2,
              filterInputFormatters: [
                FilterTextConstant.nameBucket,
              ],
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

class _HomeContentDeleteBucket extends ConsumerWidget {
  final ValueNotifier<bool> stateOpenSubMenu;
  final ValueNotifier<bool> stateDeleteButtonHover;

  const _HomeContentDeleteBucket({
    required this.stateOpenSubMenu,
    required this.stateDeleteButtonHover,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocUI = ref.watch(uiBlocProvider.notifier);
    final bloc = ref.watch(bucketsBlocProvider.notifier);
    final isActiveBucket = ref.watch(bucketsBlocProvider.select((v) {
      return v.activeStorage?.activeBucket?.isNotEmpty == true;
    }));

    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      sizeCurve: Curves.ease,
      crossFadeState: (!stateOpenSubMenu.value && isActiveBucket)
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      firstChild: const SizedBox.shrink(),
      secondChild: InkWell(
        onTap: () async {
          final result = await bloc.deleteBucket();
          if (result) {
            blocUI.menuBucket(action: ActionMenu.close);
          }
        },
        onHover: (value) {
          stateDeleteButtonHover.value = value;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.ease,
          height: 40,
          margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
          decoration: BoxDecoration(
            color:
                stateDeleteButtonHover.value ? const Color(AppColors.bgLightGrayOpacity10) : null,
            borderRadius: borderRadius4,
          ),
          alignment: Alignment.center,
          child: Text(
            'Удалить'.translate,
            style: appTheme.textTheme.control2.onDark1,
          ),
        ),
      ),
    );
  }
}

class _HomeContentCopyBucket extends ConsumerWidget {
  final ValueNotifier<bool> stateOpenSubMenu;
  final ValueNotifier<bool> stateCopyButtonHover;

  const _HomeContentCopyBucket({
    required this.stateOpenSubMenu,
    required this.stateCopyButtonHover,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocUI = ref.watch(uiBlocProvider.notifier);
    final bloc = ref.watch(bucketsBlocProvider.notifier);
    final isActiveBucket = ref.watch(bucketsBlocProvider.select((v) {
      return v.activeStorage?.activeBucket?.isNotEmpty == true;
    }));

    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      sizeCurve: Curves.ease,
      crossFadeState: (!stateOpenSubMenu.value && isActiveBucket)
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      firstChild: const SizedBox.shrink(),
      secondChild: MouseRegion(
        cursor: SystemMouseCursors.forbidden,
        child: InkWell(
          onTap: () {},
          mouseCursor: MouseCursor.defer,
          onHover: (value) {
            stateCopyButtonHover.value = value;
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.ease,
            height: 40,
            margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
            decoration: BoxDecoration(
              color:
                  stateCopyButtonHover.value ? const Color(AppColors.bgLightGrayOpacity10) : null,
              borderRadius: borderRadius4,
            ),
            alignment: Alignment.center,
            child: Text(
              'Копировать'.translate,
              style: appTheme.textTheme.control2.copyWith(
                decoration: TextDecoration.lineThrough,
                color: const Color(AppColors.textOnDark1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeContentDownloadBucket extends ConsumerWidget {
  final ValueNotifier<bool> stateOpenSubMenu;
  final ValueNotifier<bool> stateDownloadButtonHover;

  const _HomeContentDownloadBucket({
    required this.stateOpenSubMenu,
    required this.stateDownloadButtonHover,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocUI = ref.watch(uiBlocProvider.notifier);
    final bloc = ref.watch(bucketsBlocProvider.notifier);
    final isActiveBucket = ref.watch(bucketsBlocProvider.select((v) {
      return v.activeStorage?.activeBucket?.isNotEmpty == true;
    }));

    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      sizeCurve: Curves.ease,
      crossFadeState: (!stateOpenSubMenu.value && isActiveBucket)
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      firstChild: const SizedBox.shrink(),
      secondChild: MouseRegion(
        cursor: SystemMouseCursors.forbidden,
        child: InkWell(
          onTap: () {},
          mouseCursor: MouseCursor.defer,
          onHover: (value) {
            stateDownloadButtonHover.value = value;
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.ease,
            height: 40,
            margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
            decoration: BoxDecoration(
              color: switch (stateDownloadButtonHover.value) {
                true => const Color(AppColors.bgLightGrayOpacity10),
                _ => null,
              },
              borderRadius: borderRadius4,
            ),
            alignment: Alignment.center,
            child: Text(
              'Скачать'.translate,
              style: appTheme.textTheme.control2.copyWith(
                decoration: TextDecoration.lineThrough,
                color: const Color(AppColors.textOnDark1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
