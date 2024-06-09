import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/core/page_dto/account_page_dto.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/action_menu_button.dart';
import 'package:roflit/feature/presentation/menu/pages/menu_accounts/menu_accounts_content.dart';
import 'package:roflit/feature/presentation/menu/router/router.dart';
import 'package:roflit/feature/presentation/menu/widgets/menu_button.dart';

class MenuAccounts extends StatelessWidget {
  const MenuAccounts({super.key});

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
                  onTap: () {
                    context.pushNamed(RouteEndPoints.info.name);
                  },
                ),
                Text(
                  'Аккаунты'.translate,
                  overflow: TextOverflow.fade,
                  style: appTheme.textTheme.title2.bold.onDark1,
                ),
                const AspectRatio(aspectRatio: 1),
              ],
            ),
          ),
          const Expanded(
            child: MenuAccountsContent(),
          ),
          MainMenuButton(
            title: 'Создать аккаунт'.translate,
            onTap: () {
              context.pushNamed(
                RouteEndPoints.accounts.account.name,
                extra: MenuAccountDto(isCreateAccount: true),
              );
            },
          ),
        ],
      ),
    );
  }
}
