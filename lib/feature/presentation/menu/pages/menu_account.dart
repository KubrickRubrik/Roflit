import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/core/page_dto/account_page_dto.dart';
import 'package:roflit/feature/common/providers/account_service.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/action_menu_button.dart';
import 'package:roflit/feature/common/widgets/content_text_field.dart';
import 'package:roflit/feature/common/widgets/menu_item_button.dart';
import 'package:roflit/feature/presentation/menu/router/router.dart';
import 'package:roflit/feature/presentation/menu/widgets/menu_button.dart';

class MenuAccount extends HookConsumerWidget {
  final MenuAccountDto menuAccountDto;

  const MenuAccount({
    required this.menuAccountDto,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocSession = ref.watch(sessionBlocProvider.notifier);
    final blocAccount = ref.read(accountServiceProvider);

    final account = ref.watch(sessionBlocProvider.select((v) {
      return blocSession.getAccount(getActive: !menuAccountDto.isCreateProccessAccount);
    }));

    final nameController = useTextEditingController(
      text: account?.name,
      keys: [account?.idAccount],
    );

    final localizationState = useState<AppLocalization>(
      account?.localization ?? AppLocalization.ru,
    );

    final passwordController = useTextEditingController(
      keys: [account?.idAccount],
    );

    Future<void> onTapLocalization() async {
      final localization = await context.pushNamed<AppLocalization?>(
        RouteEndPoints.accounts.account.localization.name,
      );

      if (localization != null) {
        localizationState.value = localization;
      }
    }

    return Material(
      color: const Color(AppColors.bgDarkBlue1),
      borderRadius: borderRadius12,
      child: Column(
        children: [
          //! Appbar.
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
                  'Аккаунт'.translate,
                  overflow: TextOverflow.fade,
                  style: appTheme.textTheme.title2.bold.onDark1,
                ),
                const AspectRatio(aspectRatio: 1),
              ],
            ),
          ),
          //! Content list.
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //! Account name .
                  MenusItemButton(
                    onTap: () {},
                    child: ContentTextField(
                      controller: nameController,
                      hint: 'Имя'.translate,
                    ),
                  ),
                  //! Localization.
                  MenusItemButton(
                    onTap: onTapLocalization,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AspectRatio(aspectRatio: 1),
                        Text(
                          localizationState.value.name.toUpperCase(),
                          overflow: TextOverflow.fade,
                          style: appTheme.textTheme.title2.bold.selected1,
                        ),
                        ActionMenuButton(onTap: onTapLocalization),
                      ],
                    ),
                  ),
                  //! Account storages.
                  if (!menuAccountDto.isCreateProccessAccount) ...{
                    MenusItemButton(
                      onTap: () {
                        context.pushNamed(RouteEndPoints.accounts.account.storages.name);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const AspectRatio(aspectRatio: 1),
                          Text(
                            'Список хранилищ'.translate,
                            overflow: TextOverflow.fade,
                            style: appTheme.textTheme.title2.onDark1,
                          ),
                          ActionMenuButton(onTap: () {
                            context.pushNamed(
                              RouteEndPoints.accounts.account.storages.name,
                            );
                          }),
                        ],
                      ),
                    ),
                    //! Password.
                    MenusItemButton(
                      onTap: () {},
                      child: ContentTextField(
                        controller: passwordController,
                        hint: 'Пароль'.translate,
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
                    //! Bootloader.
                    MenusItemButton(
                      onTap: () {
                        context.pushNamed(
                          RouteEndPoints.accounts.account.bootloader.name,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const AspectRatio(aspectRatio: 1),
                          Text(
                            'Загрузчик'.translate,
                            overflow: TextOverflow.fade,
                            style: appTheme.textTheme.title2.onDark1,
                          ),
                          ActionMenuButton(onTap: () {
                            context.pushNamed(
                              RouteEndPoints.accounts.account.bootloader.name,
                            );
                          }),
                        ],
                      ),
                    ),
                  },
                ],
              ),
            ),
          ),
          //! Buttons.
          Flex(
            direction: Axis.horizontal,
            children: [
              if (!menuAccountDto.isCreateProccessAccount) ...{
                Flexible(
                  child: MainMenuButton(
                    title: 'Удалить'.translate,
                    onTap: () async {
                      final response =
                          await blocAccount.deleteAccount(idAccount: account!.idAccount);

                      if (response && context.mounted) {
                        context.pop();
                      }
                    },
                  ),
                ),
              },
              Flexible(
                child: MainMenuButton(
                  title: switch (menuAccountDto.isCreateProccessAccount) {
                    true => 'Создать'.translate,
                    _ => 'Сохранить'.translate,
                  },
                  onTap: () async {
                    if (menuAccountDto.isCreateProccessAccount) {
                      final response = await blocAccount.createAccount(
                        name: nameController.text,
                        localization: account?.localization ?? AppLocalization.ru,
                        password: passwordController.text,
                      );

                      if (response && context.mounted) {
                        context.pop();
                      }
                    } else {
                      final response = await blocAccount.updateAccount(
                        idAccount: menuAccountDto.idAccount,
                        name: nameController.text,
                        localization: localizationState.value,
                        password: passwordController.text,
                      );
                      if (response && context.mounted) context.pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
