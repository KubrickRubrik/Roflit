import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/core/page_dto/storage_page_dto.dart';
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

class DownloadSectionStorageMenu extends ConsumerWidget {
  final double width;

  const DownloadSectionStorageMenu({
    required this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(uiBlocProvider.notifier);
    final isDisplayedStorageMenu = ref.watch(
      uiBlocProvider.select((v) => v.isDisplayedStorageMenu),
    );

    return AnimatedPositioned(
      top: 0,
      left: isDisplayedStorageMenu ? 0 : width,
      right: isDisplayedStorageMenu ? 0 : -width,
      duration: const Duration(milliseconds: 250),
      curve: Curves.ease,
      child: InkWell(
        onTap: () {},
        onHover: (value) {
          bloc.menuActivity(
            typeMenu: TypeMenu.storage,
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
                        'Хранилище'.translate,
                        overflow: TextOverflow.fade,
                        style: appTheme.textTheme.title2.bold.onDark1,
                      ),
                    ),
                    ActionMenuButton(
                      onTap: () {
                        bloc.menuActivity(
                          typeMenu: TypeMenu.storage,
                          action: ActionMenu.close,
                        );
                        rootNavigatorKey.currentContext?.goNamed(
                          RouteEndPoints.accounts.name,
                        );
                        bloc.menuActivity(
                          typeMenu: TypeMenu.main,
                          action: ActionMenu.open,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SectionStoragesMenuContent(),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionStoragesMenuContent extends ConsumerWidget {
  const SectionStoragesMenuContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionBlocProvider);

    return state.maybeWhen(
      orElse: () => const SizedBox.shrink(),
      loading: () => const Loader(),
      loaded: (session, accounts) {
        return const SectionStoragesMenuContentList();
      },
    );
  }
}

class SectionStoragesMenuContentList extends ConsumerWidget {
  const SectionStoragesMenuContentList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocUI = ref.watch(uiBlocProvider.notifier);
    final blocSession = ref.watch(sessionBlocProvider.notifier);

    final account = ref.watch(sessionBlocProvider.select((v) {
      return blocSession.getAccount(getActive: true);
    }));

    if (account == null || account.storages.isEmpty) {
      return SizedBox(
        height: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Нет активных хранилищ'.translate,
                  textAlign: TextAlign.center,
                  style: appTheme.textTheme.body2.bold.onDark1,
                ),
              ),
            ),
            CreateMenuButton(
              title: 'Создать хранилище'.translate,
              onTap: () {
                blocUI.menuActivity(
                  typeMenu: TypeMenu.account,
                  action: ActionMenu.close,
                );
                rootNavigatorKey.currentContext?.goNamed(
                  RouteEndPoints.accounts.account.storages.storage.name,
                  extra: StoragePageDto(isCreateAccount: true),
                );
                blocUI.menuActivity(
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
        itemCount: account.storages.length,
        itemBuilder: (context, index) {
          return _StorageListItem(index);
        },
      );
    }
  }
}

class _StorageListItem extends HookConsumerWidget {
  final int index;
  const _StorageListItem(this.index);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocSession = ref.watch(sessionBlocProvider.notifier);
    final blocUI = ref.watch(uiBlocProvider.notifier);

    final storage = ref.watch(sessionBlocProvider.select((v) {
      return blocSession.getStorage(getActive: false, getByIndex: index);
    }));

    final isActiveStorage = ref.watch(sessionBlocProvider.select((v) {
      return blocSession.isActiveStorage(getByIdStorage: storage?.idStorage);
    }));

    final isHover = useState(false);

    final getBgColor = useMemoized(
      () {
        if (isActiveStorage) {
          return const Color(AppColors.bgDarkSelected1);
        } else if (isHover.value) {
          return const Color(AppColors.bgDarkHover).withOpacity(0.6);
        } else if (index.isOdd) {
          return const Color(AppColors.bgDarkHover).withOpacity(0.4);
        }
        return null;
      },
      [isActiveStorage, isHover.value],
    );

    final getTextColor = useMemoized(
      () {
        if (isActiveStorage) {
          return appTheme.textTheme.title2.bold.onLight1;
        } else {
          return appTheme.textTheme.title2.bold.onDark2;
        }
      },
      [isActiveStorage, isHover.value],
    );

    return InkWell(
      onTap: () async {
        await blocSession.setActiveStorage(storage?.idStorage ?? -1);
        // Future.delayed(const Duration(milliseconds: 300), () {
        //   blocUI.menuActivity(
        //     typeMenu: TypeMenu.storage,
        //     action: ActionMenu.close,
        //   );
        // });
      },
      onDoubleTap: () {
        rootNavigatorKey.currentContext?.goNamed(
          RouteEndPoints.accounts.storageEdit.name,
          extra: StoragePageDto(
            isCreateAccount: false,
            idStorage: storage?.idStorage,
          ),
        );
        blocUI.menuActivity(
          typeMenu: TypeMenu.main,
          action: ActionMenu.open,
        );
        blocUI.menuActivity(
          typeMenu: TypeMenu.storage,
          action: ActionMenu.close,
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
        ),
        child: Row(
          children: [
            ActionHoverButton(
              icon: Assets.icons.cloud,
              bgColor: const Color(AppColors.bgDarkGray3),
              isHover: isHover.value,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                storage?.title ?? '',
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
