import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/core/page_dto/storage_page_dto.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/action_menu_button.dart';
import 'package:roflit/feature/presentation/menu/router/router.dart';
import 'package:roflit/feature/presentation/menu/widgets/menu_button.dart';
import 'package:roflit/feature/presentation/menu/widgets/storages_content.dart';

class MainMenuAccountStoragesPage extends ConsumerWidget {
  const MainMenuAccountStoragesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final blocSession = ref.read(sessionBlocProvider.notifier);
    // final account = ref.watch(sessionBlocProvider.select((v) {
    //   return blocSession.getAccount(getActive: true);
    // }));

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
                  'Хранилища'.translate,
                  overflow: TextOverflow.fade,
                  style: appTheme.textTheme.title2.bold.onDark1,
                ),
                const AspectRatio(aspectRatio: 1),
              ],
            ),
          ),
          const Expanded(
            child: MainMenuStoragesContent(),
          ),
          MainMenuButton(
            title: 'Добавить хранилище'.translate,
            onTap: () {
              context.pushNamed(
                RouteEndPoints.accounts.account.storages.storage.name,
                extra: StoragePageDto(
                  isCreateAccount: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
