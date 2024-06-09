import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/action_menu_button.dart';
import 'package:roflit/feature/presentation/menu/router/router.dart';

class MenuInfo extends StatelessWidget {
  const MenuInfo({super.key});

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
                const AspectRatio(aspectRatio: 1),
                Text(
                  'Инфо'.translate,
                  overflow: TextOverflow.fade,
                  style: appTheme.textTheme.title2.bold.onDark1,
                ),
                ActionMenuButton(
                  onTap: () {
                    context.goNamed(RouteEndPoints.accounts.name);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
