import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/core/page_dto/account_page_dto.dart';
import 'package:roflit/core/page_dto/localization_page_dto.dart';
import 'package:roflit/feature/common/providers/account_service.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/action_menu_button.dart';
import 'package:roflit/feature/presentation/menu/router/router.dart';
import 'package:roflit/feature/presentation/menu/widgets/menu_button.dart';
import 'package:roflit/feature/presentation/menu/widgets/menu_item_button.dart';
import 'package:roflit/feature/presentation/menu/widgets/text_field.dart';

class MainMenuAccountPage extends HookConsumerWidget {
  final AccountPageDto accountPageDto;

  const MainMenuAccountPage({
    required this.accountPageDto,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocSession = ref.watch(sessionBlocProvider.notifier);
    final bloc = ref.read(accountServiceProvider);

    final account = ref.watch(sessionBlocProvider.select((v) {
      return blocSession.getAccount(getActive: true);
    }));

    final localizationState = useState<String?>(account?.localization.name.toUpperCase());

    final nameController = useTextEditingController(
      text: account?.name,
      keys: [account?.idAccount],
    );

    final passwordController = useTextEditingController(
      keys: [account?.idAccount],
    );

    Future<void> onTapLocalization() async {
      final localization = await context.pushNamed<String?>(
        RouteEndPoints.accounts.account.localization.name,
        extra: LocalizationPageDto(
          idAccount: account?.idAccount ?? -1,
          localizationType: account?.localization ?? AvailableAppLocale.ru,
        ),
      );

      if (localization != null) {
        localizationState.value = localization.toUpperCase();
      }
    }

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
                  switch (accountPageDto.isCreateAccount) {
                    true => 'Создание аккаунта'.translate,
                    _ => 'Изменение аккаунта'.translate,
                  },
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
                      hint: 'Имя'.translate,
                      controller: nameController,
                    ),
                  ),
                  MainMenuItemButton(
                    onTap: onTapLocalization,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AspectRatio(aspectRatio: 1),
                        Text(
                          localizationState.value ?? 'Локализация'.translate,
                          overflow: TextOverflow.fade,
                          style: appTheme.textTheme.title2.bold.onDark1,
                        ),
                        ActionMenuButton(onTap: onTapLocalization),
                      ],
                    ),
                  ),
                  if (!accountPageDto.isCreateAccount) ...{
                    MainMenuItemButton(
                      onTap: () {
                        context.pushNamed(RouteEndPoints.accounts.account.storages.name);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const AspectRatio(aspectRatio: 1),
                          Text(
                            'Хранилища'.translate,
                            overflow: TextOverflow.fade,
                            style: appTheme.textTheme.title2.bold.onDark1,
                          ),
                          ActionMenuButton(onTap: () {
                            context.pushNamed(
                              RouteEndPoints.accounts.account.storages.name,
                            );
                          }),
                        ],
                      ),
                    ),
                  },
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
            title: switch (accountPageDto.isCreateAccount) {
              true => 'Добавить'.translate,
              _ => 'Сохранить'.translate,
            },
            onTap: () async {
              if (accountPageDto.isCreateAccount) {
                final response = await bloc.createAccount(
                  name: nameController.text,
                  localization: account?.localization ?? AvailableAppLocale.ru,
                  password: passwordController.text,
                );

                if (response && context.mounted) {
                  context.pop();
                }
              } else {
                final response = await bloc.updateAccount(
                  idAccount: accountPageDto.idAccount,
                  name: nameController.text,
                  localization: AvailableAppLocale.ru.fromName(localizationState.value),
                  password: passwordController.text,
                );
                if (response && context.mounted) context.pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
