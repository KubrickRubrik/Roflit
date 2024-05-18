import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/core/page_dto/account_page_dto.dart';
import 'package:roflit/core/page_dto/login_page_dto.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/action_account.dart';
import 'package:roflit/feature/common/widgets/loader.dart';
import 'package:roflit/feature/presentation/menu/router/router.dart';
import 'package:roflit/generated/assets.gen.dart';

class MainMenuAccountsContent extends ConsumerWidget {
  const MainMenuAccountsContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionBlocProvider);

    return state.maybeWhen(
      orElse: () => const SizedBox.shrink(),
      loading: () => const Loader(),
      loaded: (session, accounts) {
        return const _MainMenuAccountContentList();
      },
    );
  }
}

class _MainMenuAccountContentList extends ConsumerWidget {
  const _MainMenuAccountContentList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionBlocProvider);
    if (state is! SessionLoadedState) return const SizedBox.shrink();

    if (state.accounts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Нет активных аккаунтов.'.translate,
                textAlign: TextAlign.center,
                style: appTheme.textTheme.body2.bold.onDark1,
              ),
              const SizedBox(height: 16),
              Text(
                'Создайте новый аккаунт, чтобы привязать к нему профиль хранилища.'.translate,
                textAlign: TextAlign.center,
                style: appTheme.textTheme.body2.bold.onDark1,
              ),
              const SizedBox(height: 16),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'За подробной информацией обратитесь в раздел '.translate,
                  style: appTheme.textTheme.body2.bold.onDark1.copyWith(
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: 'Инфо'.translate,
                      style: appTheme.textTheme.body2.bold.secondary0,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.goNamed(RouteEndPoints.info.name);
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
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

    return InkWell(
      onTap: () async {
        final login = await blocSession.confirmLogin(account?.idAccount ?? -1);
        if (login != null && !login) {
          rootNavigatorKey.currentContext?.goNamed(
            RouteEndPoints.accounts.login.name,
            extra: LoginPageDto(idAccount: account?.idAccount ?? -1),
          );
          return;
        }

        rootNavigatorKey.currentContext?.goNamed(
          RouteEndPoints.accounts.account.name,
          extra: AccountPageDto(
            isCreateAccount: false,
            idAccount: account?.idAccount,
          ),
        );
      },
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
            AccountAvatar(
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
          ],
        ),
      ),
    );
  }
}
