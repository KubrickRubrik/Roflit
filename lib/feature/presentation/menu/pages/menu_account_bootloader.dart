import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/feature/common/providers/account_service.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/action_menu_button.dart';
import 'package:roflit/feature/common/widgets/menu_item_button.dart';
import 'package:roflit/feature/common/widgets/menu_item_config_switch.dart';

class MenuAccountBootloader extends ConsumerWidget {
  const MenuAccountBootloader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocSession = ref.watch(sessionBlocProvider.notifier);
    final account = ref.watch(sessionBlocProvider.select((v) {
      return blocSession.getAccount(getActive: true);
    }));

    if (account == null) return const SizedBox.shrink();

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
                  'Загрузчик'.translate,
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
                children: [
                  MainMenuAccountBootloaderConfigItem(
                    label: 'Cкачивание'.translate,
                    currentValue: account.config.isOnUpload,
                    onSwitch: ({required bool value}) {
                      ref.read(accountServiceProvider).setConfig(
                            idAccount: account.idAccount,
                            isOnUpload: value,
                          );
                    },
                  ),
                  MainMenuAccountBootloaderConfigItem(
                    label: 'Загрузка'.translate,
                    currentValue: account.config.isOnDownload,
                    onSwitch: ({required bool value}) {
                      ref.read(accountServiceProvider).setConfig(
                            idAccount: account.idAccount,
                            isOnDownload: value,
                          );
                    },
                  ),
                  MainMenuAccountBootloaderConfigAction(
                    currentValue: account.config.action,
                    onSwitch: () {
                      ref.read(accountServiceProvider).setConfig(
                            idAccount: account.idAccount,
                            action: switch (account.config.action) {
                              ActionFirst.upload => ActionFirst.download,
                              ActionFirst.download => ActionFirst.upload,
                            },
                          );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MainMenuAccountBootloaderConfigAction extends StatelessWidget {
  final ActionFirst currentValue;
  final void Function() onSwitch;

  const MainMenuAccountBootloaderConfigAction({
    required this.currentValue,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return MainMenuItemButton(
        onTap: onSwitch,
        child: Stack(
          children: [
            AnimatedPositioned(
              top: currentValue.isUpload ? 0 : -64,
              left: 0,
              right: 0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
              child: Column(
                children: [
                  Container(
                    height: 64,
                    alignment: Alignment.center,
                    child: Text(
                      'Приоритет - скачивание'.translate,
                      overflow: TextOverflow.ellipsis,
                      style: appTheme.textTheme.title2.onDark1,
                    ),
                  ),
                  Container(
                    height: 64,
                    alignment: Alignment.center,
                    child: Text(
                      'Приоритет - загрузки'.translate,
                      overflow: TextOverflow.ellipsis,
                      style: appTheme.textTheme.title2.onDark1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
