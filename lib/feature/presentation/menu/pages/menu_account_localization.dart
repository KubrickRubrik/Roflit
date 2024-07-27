import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/action_menu_button.dart';
import 'package:roflit/feature/common/widgets/menu_item_button.dart';

class MenuAccountLocalization extends StatelessWidget {
  const MenuAccountLocalization({super.key});

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
              itemCount: AppLocalization.values.length,
              itemBuilder: (context, index) {
                // return MainMenuAccountLocalizationItem(index);
                return MainMenuItemButton(
                  onTap: () {
                    context.pop(AppLocalization.values[index]);
                  },
                  child: Text(
                    AppLocalization.values[index].title,
                    style: appTheme.textTheme.title2.onDark1,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
