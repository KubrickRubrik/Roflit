import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/feature/common/themes/text.dart';

class MenuFileListContentEmpty extends ConsumerWidget {
  const MenuFileListContentEmpty({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Выберите файлы для загрузки.'.translate,
            textAlign: TextAlign.center,
            style: appTheme.textTheme.title2.bold.onDark2,
          ),
        ),
      ),
    );
  }
}
