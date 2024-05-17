import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/dto/account_page_dto.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/loader.dart';
import 'package:roflit/feature/presentation/menu/router/router.dart';
import 'package:roflit/generated/assets.gen.dart';

class MainMenuContent extends ConsumerWidget {
  const MainMenuContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionBlocProvider);

    return state.maybeWhen(
      orElse: () => const SizedBox.shrink(),
      loading: () => const Loader(),
      loaded: (session, accounts) {
        return const MainMenuAccountContentList();
      },
    );
  }
}

class MainMenuAccountContentList extends ConsumerWidget {
  const MainMenuAccountContentList({super.key});

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
    final account = ref.watch(sessionBlocProvider.select((value) {
      value as SessionLoadedState;
      return value.accounts.elementAt(index);
    }));

    final isHover = useState(false);

    return InkWell(
      onTap: () {
        //TODO: проверка наличия парроля
        rootNavigatorKey.currentContext?.goNamed(
          RouteEndPoints.accounts.account.name,
          extra: AccountPageDto(
            isCreateAccount: false,
            idAccount: account.idAccount,
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
          color: isHover.value
              ? const Color(AppColors.bgDarkHover).withOpacity(0.6)
              : index.isOdd
                  ? const Color(AppColors.bgDarkHover).withOpacity(0.4)
                  : null,
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: borderRadius8,
                color: const Color(AppColors.bgDarkGray4),
              ),
              alignment: Alignment.center,
              child: Assets.icons.profile.svg(
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  Color(AppColors.textOnDark1),
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                account.name,
                style: appTheme.textTheme.body2.bold.onDark2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
