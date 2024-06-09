import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/core/page_dto/storage_page_dto.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:roflit/feature/common/providers/storage_service.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/action_menu_button.dart';
import 'package:roflit/feature/presentation/menu/router/router.dart';
import 'package:roflit/feature/presentation/menu/widgets/menu_button.dart';
import 'package:roflit/feature/presentation/menu/widgets/menu_item_button.dart';
import 'package:roflit/feature/presentation/menu/widgets/text_field.dart';

class MenuStorage extends HookConsumerWidget {
  final MenuStorageDto menuStorageDto;

  const MenuStorage({
    required this.menuStorageDto,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocSession = ref.watch(sessionBlocProvider.notifier);
    final blocStorage = ref.read(storageServiceProvider);

    final account = ref.watch(sessionBlocProvider.select((v) {
      return blocSession.getAccount(getActive: true);
    }));

    final storage = ref.watch(sessionBlocProvider.select((v) {
      return blocSession.getStorage(getActive: false, getByIdStorage: menuStorageDto.idStorage);
    }));

    final titleStorageController = useTextEditingController(
      text: storage?.title,
      keys: [storage?.idStorage],
    );

    final accessKeyStorageController = useTextEditingController(
      text: storage?.accessKey,
      keys: [storage?.idStorage],
    );

    final secretKeyStorageController = useTextEditingController(
      text: storage?.secretKey,
      keys: [storage?.idStorage],
    );

    final regionKeyStorageController = useTextEditingController(
      text: storage?.region,
      keys: [storage?.idStorage],
    );

    final typeStorageState = useState<StorageType>(
      storage?.storageType ?? StorageType.yxCloud,
    );

    Future<void> onTapTypeStorage() async {
      final typeStorage = await context.pushNamed<StorageType?>(
        RouteEndPoints.accounts.account.storages.storage.type.name,
      );

      if (typeStorage != null) {
        typeStorageState.value = typeStorage;
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
                  onTap: () {
                    context.pop();
                  },
                ),
                Text(
                  'Хранилище'.translate,
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
                  //! Title cloud.
                  MainMenuItemButton(
                    onTap: () {},
                    child: MainMenuTextField(
                      hint: 'Название'.translate,
                      controller: titleStorageController,
                    ),
                  ),
                  //! Type Cloud.
                  MainMenuItemButton(
                    onTap: onTapTypeStorage,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AspectRatio(aspectRatio: 1),
                        Text(
                          typeStorageState.value.title,
                          overflow: TextOverflow.fade,
                          style: appTheme.textTheme.title2.bold.selected1,
                        ),
                        ActionMenuButton(onTap: onTapTypeStorage),
                      ],
                    ),
                  ),
                  //! Access key.
                  MainMenuItemButton(
                    onTap: () {},
                    child: MainMenuTextField(
                      hint: 'Ключ доступа'.translate,
                      controller: accessKeyStorageController,
                      maxLength: 128,
                    ),
                  ),
                  //! The secret key.
                  MainMenuItemButton(
                    onTap: () {},
                    child: MainMenuTextField(
                      hint: 'Секретный ключ'.translate,
                      controller: secretKeyStorageController,
                      maxLength: 128,
                    ),
                  ),
                  //! Cloud region.
                  MainMenuItemButton(
                    onTap: () {},
                    child: MainMenuTextField(
                      hint: 'Регион облака'.translate,
                      controller: regionKeyStorageController,
                    ),
                  ),
                ],
              ),
            ),
          ),
          //! Buttons.
          Flex(
            direction: Axis.horizontal,
            children: [
              if (!menuStorageDto.isCreateAccount) ...{
                Flexible(
                  child: MainMenuButton(
                    title: 'Удалить'.translate,
                    onTap: () async {
                      final response = await blocStorage.deleteStorage(
                        idStorage: menuStorageDto.idStorage ?? -1,
                      );

                      if (response && context.mounted) {
                        context.pop();
                      }
                    },
                  ),
                ),
              },
              Flexible(
                child: MainMenuButton(
                  title: switch (menuStorageDto.isCreateAccount) {
                    true => 'Добавить'.translate,
                    _ => 'Сохранить'.translate,
                  },
                  onTap: () async {
                    if (menuStorageDto.isCreateAccount && account?.idAccount != null) {
                      final response = await blocStorage.createStorage(
                        idAccount: account?.idAccount ?? -1,
                        title: titleStorageController.text,
                        storageType: typeStorageState.value,
                        accessKey: accessKeyStorageController.text,
                        secretKey: secretKeyStorageController.text,
                        region: regionKeyStorageController.text,
                      );

                      if (response && context.mounted) {
                        context.pop();
                      }
                    } else {
                      final response = await blocStorage.updateStorage(
                        idStorage: menuStorageDto.idStorage ?? -1,
                        title: titleStorageController.text,
                        storageType: typeStorageState.value,
                        accessKey: accessKeyStorageController.text,
                        secretKey: secretKeyStorageController.text,
                        region: regionKeyStorageController.text,
                      );

                      if (response && context.mounted) {
                        context.pop();
                      }
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
