import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/entity/account.dart';
import 'package:roflit/core/page_dto/account_page_dto.dart';
import 'package:roflit/core/page_dto/login_page_dto.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/action_hover_button.dart';
import 'package:roflit/feature/common/widgets/action_menu_button.dart';
import 'package:roflit/feature/presentation/menu/router/router.dart';
import 'package:roflit/generated/assets.gen.dart';

class MenuAccountContentLoaded extends ConsumerWidget {
  const MenuAccountContentLoaded({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(sessionBlocProvider.select((v) {
      if (v is! SessionLoadedState) return <AccountEntity>[];
      return v.accounts;
    }));

    return ListView.builder(
      shrinkWrap: true,
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        return _AccountsListItem(index);
      },
    );
  }
}

class _AccountsListItem extends HookConsumerWidget {
  final int index;
  const _AccountsListItem(this.index);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocSession = ref.watch(sessionBlocProvider.notifier);

    final account = ref.watch(sessionBlocProvider.select((v) {
      return blocSession.getAccount(getActive: false, getByIndex: index);
    }));

    final isActiveAccount = ref.watch(sessionBlocProvider.select((v) {
      return blocSession.isActiveIdAccount(getByIndex: index);
    }));

    final isHover = useState(false);

    final getBgColor = useMemoized(
      () {
        if (isActiveAccount) {
          return const Color(AppColors.bgDarkSelected1);
        } else if (isHover.value) {
          return const Color(AppColors.bgDarkHover).withOpacity(0.6);
        } else if (index.isOdd) {
          return const Color(AppColors.bgDarkHover).withOpacity(0.4);
        }
        return null;
      },
      [isActiveAccount, isHover.value],
    );

    final getTextColor = useMemoized(
      () {
        if (isActiveAccount) {
          return appTheme.textTheme.title2.bold.onLight1;
        } else {
          return appTheme.textTheme.title2.bold.onDark2;
        }
      },
      [isActiveAccount, isHover.value],
    );

    Future<void> onDoubleTapAccount() async {
      final login = await blocSession.checkLogin(account?.idAccount ?? -1);
      if (login != null && !login) {
        rootMenuNavigatorKey.currentContext?.goNamed(
          RouteEndPoints.accounts.login.name,
          extra: MenuLoginDto(idAccount: account?.idAccount ?? -1),
        );
        return;
      }
      rootMenuNavigatorKey.currentContext?.goNamed(
        RouteEndPoints.accounts.account.name,
        extra: MenuAccountDto(
          isCreateProccessAccount: false,
          idAccount: account?.idAccount,
        ),
      );
    }

    return InkWell(
      onTap: () async {
        final login = await blocSession.checkLogin(account?.idAccount ?? -1);
        if (login != null && !login) {
          rootMenuNavigatorKey.currentContext?.goNamed(
            RouteEndPoints.accounts.login.name,
            extra: MenuLoginDto(idAccount: account?.idAccount ?? -1),
          );
          return;
        }
      },
      onDoubleTap: onDoubleTapAccount,
      onHover: (value) {
        isHover.value = value;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: getBgColor,
          borderRadius: borderRadius8,
        ),
        child: Row(
          children: [
            ActionHoverButton(
              icon: Assets.icons.profile,
              bgColor: const Color(AppColors.bgDarkGray3),
              isHover: isHover.value,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                account?.name ?? '',
                overflow: TextOverflow.ellipsis,
                style: getTextColor,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox.square(
              dimension: 40,
              child: ActionMenuButton(
                onTap: onDoubleTapAccount,
                color: isActiveAccount
                    ? const Color(AppColors.bgDarkGray1)
                    : const Color(AppColors.bgLight0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
