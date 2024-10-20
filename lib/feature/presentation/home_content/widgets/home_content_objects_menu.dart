import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/feature/common/providers/file_manager/provider.dart';
import 'package:roflit/feature/common/providers/ui/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';

class HomeContentObjectsMenu extends HookConsumerWidget {
  const HomeContentObjectsMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateCopyButtonHover = useState(false);
    final stateDownloadButtonHover = useState(false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _HomeContentCopyObject(stateCopyButtonHover: stateCopyButtonHover),
        _HomeContentDownloadObject(stateDownloadButtonHover: stateDownloadButtonHover),
      ],
    );
  }
}

class _HomeContentCopyObject extends ConsumerWidget {
  final ValueNotifier<bool> stateCopyButtonHover;

  const _HomeContentCopyObject({
    required this.stateCopyButtonHover,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocUI = ref.watch(uiBlocProvider.notifier);
    final bloc = ref.watch(fileManagerBlocProvider.notifier);

    return InkWell(
      onTap: () async {
        await bloc.onDownloadBootloader();
        blocUI.menuBucket(action: ActionMenu.close);
      },
      onHover: (value) {
        stateCopyButtonHover.value = value;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
        height: 40,
        margin: const EdgeInsets.only(left: 8, right: 8),
        decoration: BoxDecoration(
          color: switch (stateCopyButtonHover.value) {
            true => const Color(AppColors.bgLightGrayOpacity10),
            _ => null,
          },
          borderRadius: borderRadius4,
        ),
        alignment: Alignment.center,
        child: Text(
          'Копировать'.translate,
          style: appTheme.textTheme.control2.onDark1,
        ),
      ),
    );
  }
}

class _HomeContentDownloadObject extends ConsumerWidget {
  final ValueNotifier<bool> stateDownloadButtonHover;

  const _HomeContentDownloadObject({
    required this.stateDownloadButtonHover,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocUI = ref.watch(uiBlocProvider.notifier);
    final bloc = ref.watch(fileManagerBlocProvider.notifier);

    return InkWell(
      onTap: () async {
        await bloc.onDownloadBootloader();
        blocUI.menuBucket(action: ActionMenu.close);
      },
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
          style: appTheme.textTheme.control2.onDark1,
        ),
      ),
    );
  }
}
