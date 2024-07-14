import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/core/page_dto/account_page_dto.dart';
import 'package:roflit/core/page_dto/login_page_dto.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:roflit/feature/common/providers/ui/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/action_hover_button.dart';
import 'package:roflit/feature/common/widgets/action_menu_button.dart';
import 'package:roflit/feature/common/widgets/create_menu_button.dart';
import 'package:roflit/feature/common/widgets/loader.dart';
import 'package:roflit/feature/presentation/menu/router/router.dart';
import 'package:roflit/generated/assets.gen.dart';

class HomeUploadAccountsMenu extends ConsumerWidget {
  final double width;
  const HomeUploadAccountsMenu({required this.width, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(uiBlocProvider.notifier);
    final isDisplayedAccountMenu = ref.watch(
      uiBlocProvider.select((v) => v.isDisplayedAccountMenu),
    );

    return AnimatedPositioned(
      top: 0,
      left: isDisplayedAccountMenu ? 0 : -width,
      right: isDisplayedAccountMenu ? 0 : width,
      duration: const Duration(milliseconds: 250),
      curve: Curves.ease,
      child: InkWell(
        onTap: () {},
        onHover: (value) {
          bloc.menuActivity(
            typeMenu: TypeMenu.account,
            action: ActionMenu.hoverLeave,
            isHover: value,
          );
        },
        mouseCursor: MouseCursor.defer,
        child: Container(
          constraints: const BoxConstraints(minHeight: 200),
          decoration: BoxDecoration(
            color: const Color(AppColors.bgDarkBlue1),
            borderRadius: borderRadius10,
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 8,
                spreadRadius: -1,
              ),
            ],
          ),
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
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Аккаунт'.translate,
                        overflow: TextOverflow.fade,
                        style: appTheme.textTheme.title2.bold.onDark1,
                      ),
                    ),
                    ActionMenuButton(
                      onTap: () {
                        bloc.menuActivity(
                          typeMenu: TypeMenu.account,
                          action: ActionMenu.close,
                        );
                        rootMenuNavigatorKey.currentContext?.goNamed(RouteEndPoints.accounts.name);
                        bloc.menuActivity(
                          typeMenu: TypeMenu.main,
                          action: ActionMenu.open,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SectionAccountsMenuContent(),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionAccountsMenuContent extends ConsumerWidget {
  const SectionAccountsMenuContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionBlocProvider);

    return state.maybeWhen(
      orElse: () => const SizedBox.shrink(),
      loading: () => const Loader(),
      loaded: (session, accounts) {
        return const SectionAccountsMenuContentList();
      },
    );
  }
}

class SectionAccountsMenuContentList extends ConsumerWidget {
  const SectionAccountsMenuContentList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(uiBlocProvider.notifier);
    final state = ref.watch(sessionBlocProvider) as SessionLoadedState;

    if (state.accounts.isEmpty) {
      return SizedBox(
        height: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Нет активных аккаунтов'.translate,
                  textAlign: TextAlign.center,
                  style: appTheme.textTheme.body2.bold.onDark1,
                ),
              ),
            ),
            CreateMenuButton(
              title: 'Создать аккаунт'.translate,
              onTap: () {
                bloc.menuActivity(
                  typeMenu: TypeMenu.account,
                  action: ActionMenu.close,
                );
                rootMenuNavigatorKey.currentContext?.goNamed(
                  RouteEndPoints.accounts.account.name,
                  extra: MenuAccountDto(isCreateAccount: true),
                );
                bloc.menuActivity(
                  typeMenu: TypeMenu.main,
                  action: ActionMenu.open,
                );
              },
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: state.accounts.length,
        itemBuilder: (context, index) {
          return _AccountsListItem(index);
        },
      );
    }
  }
}

class _AccountsListItem extends HookConsumerWidget {
  final int index;
  const _AccountsListItem(this.index);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocSession = ref.watch(sessionBlocProvider.notifier);
    final blocUI = ref.watch(uiBlocProvider.notifier);

    final account = ref.watch(sessionBlocProvider.select((v) {
      return blocSession.getAccount(getActive: false, getByIndex: index);
    }));

    final isActiveAccount = ref.watch(sessionBlocProvider.select((v) {
      return blocSession.isActiveIdAccount(getByIdAccount: account?.idAccount);
    }));

    final stateHover = useState(false);

    final getBgColor = useMemoized(
      () {
        if (isActiveAccount) {
          return const Color(AppColors.bgDarkSelected1);
        } else if (stateHover.value) {
          return const Color(AppColors.bgDarkHover).withOpacity(0.6);
        } else if (index.isOdd) {
          return const Color(AppColors.bgDarkHover).withOpacity(0.4);
        }
        return null;
      },
      [isActiveAccount, stateHover.value],
    );

    final getTextColor = useMemoized(
      () {
        if (isActiveAccount) {
          return appTheme.textTheme.title2.bold.onLight1;
        } else {
          return appTheme.textTheme.title2.bold.onDark2;
        }
      },
      [isActiveAccount, stateHover.value],
    );

    return InkWell(
      onTap: () async {
        final login = await blocSession.checkLogin(account?.idAccount ?? -1);
        if (login != null && !login) {
          rootMenuNavigatorKey.currentContext?.goNamed(
            RouteEndPoints.accounts.login.name,
            extra: MenuLoginDto(idAccount: account?.idAccount ?? -1),
          );
          blocUI.menuActivity(
            typeMenu: TypeMenu.main,
            action: ActionMenu.open,
          );
        }
        // Future.delayed(const Duration(milliseconds: 300), () {
        //   blocUI.menuActivity(
        //     typeMenu: TypeMenu.account,
        //     action: ActionMenu.close,
        //   );
        // });
      },
      onDoubleTap: () {
        rootMenuNavigatorKey.currentContext?.goNamed(
          RouteEndPoints.accounts.account.name,
          extra: MenuAccountDto(
            isCreateAccount: false,
            idAccount: account?.idAccount,
          ),
        );
        blocUI.menuActivity(
          typeMenu: TypeMenu.main,
          action: ActionMenu.open,
        );
        blocUI.menuActivity(
          typeMenu: TypeMenu.account,
          action: ActionMenu.close,
        );
      },
      onHover: (value) {
        stateHover.value = value;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: getBgColor,
        ),
        child: Row(
          children: [
            ActionHoverButton(
              icon: Assets.icons.profile,
              bgColor: const Color(AppColors.bgDarkGray3),
              isHover: stateHover.value,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                account?.name ?? '',
                overflow: TextOverflow.ellipsis,
                style: getTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
