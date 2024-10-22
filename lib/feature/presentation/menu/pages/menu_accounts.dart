import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/entity/account.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/core/page_dto/account_page_dto.dart';
import 'package:roflit/feature/common/providers/account_service.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:roflit/feature/common/providers/ui/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/action_menu_button.dart';
import 'package:roflit/feature/presentation/menu/pages/menu_accounts/menu_accounts_content.dart';
import 'package:roflit/feature/presentation/menu/router/router.dart';
import 'package:roflit/feature/presentation/menu/widgets/menu_button.dart';

class MenuAccounts extends HookConsumerWidget {
  const MenuAccounts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(sessionBlocProvider.select((v) {
      return v.maybeWhen(
        orElse: () => <AccountEntity>[],
        loaded: (_, accounts) => accounts,
      );
    }));

    ref.watch(sessionBlocProvider.select((v) {
      return v.maybeWhen(
        orElse: () => <AccountEntity>[],
        loaded: (_, accounts) {
          EasyDebounce.debounce('account_available', const Duration(seconds: 1), () {
            if (accounts.isEmpty) {
              ref.read(uiBlocProvider.notifier).menuActivity(
                    typeMenu: TypeMenu.main,
                    action: ActionMenu.open,
                  );
            }
          });
        },
      );
    }));

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
          if (accounts.isEmpty) ...[
            MainMenuButton(
              title: 'Дефолтные аккаунты'.translate,
              onTap: () async {
                await ref.read(accountServiceProvider).createDefaultAccount();
                ref.read(uiBlocProvider.notifier).menuActivity(
                      typeMenu: TypeMenu.main,
                      action: ActionMenu.close,
                    );
              },
            ),
          ],
          MainMenuButton(
            title: 'Создать аккаунт'.translate,
            onTap: () {
              context.pushNamed(
                RouteEndPoints.accounts.account.name,
                extra: MenuAccountDto(isCreateProccessAccount: true),
              );
            },
          ),
        ],
      ),
    );
  }
}
