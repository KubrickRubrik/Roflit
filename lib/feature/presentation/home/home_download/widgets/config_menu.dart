import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/feature/common/providers/account_service.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:roflit/feature/common/providers/ui/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/widgets/menu_item_config_switch.dart';

class HomeDownloadConfigMenu extends ConsumerWidget {
  final BoxConstraints constrains;

  const HomeDownloadConfigMenu({
    required this.constrains,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(uiBlocProvider.notifier);
    final isDisplayedDownloadConfigMenu = ref.watch(
      uiBlocProvider.select((v) => v.isDisplayedDownloadConfigMenu),
    );

    return AnimatedPositioned(
      bottom: 12,
      left: isDisplayedDownloadConfigMenu ? 8 : constrains.maxWidth + 8,
      right: isDisplayedDownloadConfigMenu ? 0 : -constrains.maxWidth,
      duration: const Duration(milliseconds: 250),
      curve: Curves.ease,
      child: InkWell(
        onTap: () {},
        onHover: (value) {
          bloc.menuActivity(
            typeMenu: TypeMenu.downloadConfig,
            action: ActionMenu.hoverLeave,
            isHover: value,
          );
        },
        mouseCursor: MouseCursor.defer,
        child: Container(
          constraints: BoxConstraints(minHeight: 200, maxHeight: constrains.maxHeight * 0.38),
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
          child: const SectionDownloadConfigMenuContent(),
        ),
      ),
    );
  }
}

class SectionDownloadConfigMenuContent extends ConsumerWidget {
  const SectionDownloadConfigMenuContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocSession = ref.watch(sessionBlocProvider.notifier);
    final account = ref.watch(sessionBlocProvider.select((v) {
      return blocSession.getAccount(getActive: true);
    }));

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (account != null) ...[
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
          ],
        ],
      ),
    );
  }
}
