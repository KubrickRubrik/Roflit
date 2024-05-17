import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/dto/login_page_dto.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:roflit/feature/common/providers/ui/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/action_menu_button.dart';
import 'package:roflit/feature/presentation/menu/widgets/menu_button.dart';
import 'package:roflit/feature/presentation/menu/widgets/menu_item_button.dart';
import 'package:roflit/feature/presentation/menu/widgets/text_field.dart';

class MainMenuLoginPage extends HookConsumerWidget {
  final LoginPageDto loginPageDto;
  const MainMenuLoginPage({required this.loginPageDto, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocUi = ref.watch(uiBlocProvider.notifier);
    final blocSession = ref.watch(sessionBlocProvider.notifier);
    final passwordController = useTextEditingController();

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
                  'Введите пароль'.translate,
                  overflow: TextOverflow.fade,
                  style: appTheme.textTheme.title2.bold.onDark1,
                ),
                const AspectRatio(aspectRatio: 1),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MainMenuItemButton(
                    child: MainMenuTextField(
                      hint: 'Пароль'.translate,
                      controller: passwordController,
                      obscureText: true,
                      prefixIcon: const AspectRatio(aspectRatio: 1),
                      suffixIcon: const AspectRatio(
                        aspectRatio: 1,
                        child: Icon(
                          Icons.remove_red_eye,
                          color: Color(
                            AppColors.textOnDark1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          MainMenuButton(
            title: 'Войти'.translate,
            onTap: () async {
              final response = await blocSession.loginLockAccount(
                idAccount: loginPageDto.idAccount,
                password: passwordController.text,
              );

              if (response) {
                blocUi.menuActivity(
                  typeMenu: TypeMenu.main,
                  action: ActionMenu.close,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
