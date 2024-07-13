import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/feature/common/providers/ui/provider.dart';
import 'package:roflit/feature/presentation/menu_file/pages/menu_file_list.dart';

class MenuFilesManager extends ConsumerWidget {
  const MenuFilesManager({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDisplayedFileManagerMenu = ref.watch(
      uiBlocProvider.select((v) => v.isDisplayedFileManagerMenu),
    );

    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        sizeCurve: Curves.ease,
        crossFadeState:
            (!isDisplayedFileManagerMenu) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        firstChild: const SizedBox.shrink(),
        secondChild: const MenuFileList(),
        layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
          return Stack(
            children: [
              Positioned.fill(
                key: bottomChildKey,
                child: bottomChild,
              ),
              Positioned.fill(
                key: topChildKey,
                child: topChild,
              ),
            ],
          );
        },
      ),
    );
  }
}
