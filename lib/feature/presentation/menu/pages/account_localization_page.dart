import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/core/localization.dart';
import 'package:roflit/core/page_dto/localization_page_dto.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/action_menu_button.dart';
import 'package:roflit/feature/presentation/menu/widgets/menu_item_button.dart';

class MainMenuAccountLocalizationPage extends StatelessWidget {
  final LocalizationPageDto localizationPageDto;
  const MainMenuAccountLocalizationPage({
    required this.localizationPageDto,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(AppColors.bgDarkBlue1),
      borderRadius: borderRadius12,
      child: Column(
        children: [
          Container(
            height: 56,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 2,
                  color: Color(AppColors.borderLineOnLight0),
                ),
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ActionMenuButton(
                  onTap: () => context.pop(),
                ),
                Text(
                  'Локализация'.translate,
                  overflow: TextOverflow.fade,
                  style: appTheme.textTheme.title2.bold.onDark1,
                ),
                const AspectRatio(aspectRatio: 1),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: LocalizationController.defaultLanguage.length,
              itemBuilder: (context, index) {
                return MainMenuAccountLocalizationItem(
                  index,
                  localizationPageDto: localizationPageDto,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MainMenuAccountLocalizationItem extends ConsumerWidget {
  final int index;
  final LocalizationPageDto localizationPageDto;
  const MainMenuAccountLocalizationItem(
    this.index, {
    required this.localizationPageDto,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = LocalizationController.defaultLanguage.values.elementAt(index);

    return MainMenuItemButton(
      onTap: () {
        context.pop(localization.code);
      },
      child: Text(
        localization.title,
        style: appTheme.textTheme.title2.bold.onDark1,
      ),
    );
  }
}
