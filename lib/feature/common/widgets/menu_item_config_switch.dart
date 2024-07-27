import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/menu_item_button.dart';

class MainMenuAccountBootloaderConfigItem extends StatelessWidget {
  final String label;
  final bool currentValue;
  final void Function({required bool value}) onSwitch;
  const MainMenuAccountBootloaderConfigItem({
    required this.label,
    required this.currentValue,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return MainMenuItemButton(
      onTap: () {
        onSwitch(value: !currentValue);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: appTheme.textTheme.title2.onDark1,
            ),
            SizedBox(
              child: Switch(
                value: currentValue,
                activeColor: const Color(AppColors.bgSuccess),
                activeTrackColor: const Color(AppColors.bgDarkBlue1),
                inactiveThumbColor: const Color(AppColors.bgLightGrayButton),
                inactiveTrackColor: const Color(AppColors.bgDarkBlue1),
                trackOutlineColor: const WidgetStatePropertyAll(
                  Color(AppColors.borderLineOnDart2),
                ),
                trackOutlineWidth: const WidgetStatePropertyAll(1),
                onChanged: (value) {
                  onSwitch(value: value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
