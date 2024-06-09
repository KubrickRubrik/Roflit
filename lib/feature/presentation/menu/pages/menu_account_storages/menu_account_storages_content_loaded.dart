import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/page_dto/storage_page_dto.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/action_hover_button.dart';
import 'package:roflit/feature/presentation/menu/router/router.dart';
import 'package:roflit/generated/assets.gen.dart';

class MenuStoragesContentLoaded extends ConsumerWidget {
  const MenuStoragesContentLoaded({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocSession = ref.watch(sessionBlocProvider.notifier);
    final storages = ref.watch(sessionBlocProvider.select((v) {
      return blocSession.getAccount(getActive: true)?.storages ?? [];
    }));

    return ListView.builder(
      shrinkWrap: true,
      itemCount: storages.length,
      itemBuilder: (context, index) {
        return _StoragesListItem(index);
      },
    );
  }
}

class _StoragesListItem extends HookConsumerWidget {
  final int index;
  const _StoragesListItem(this.index);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocSession = ref.watch(sessionBlocProvider.notifier);

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
        await blocSession.setActiveStorage(storage?.idStorage);
      },
      onDoubleTap: () {
        rootMenuNavigatorKey.currentContext?.goNamed(
          RouteEndPoints.accounts.account.storages.storage.name,
          extra: MenuStorageDto(
            isCreateAccount: false,
            idStorage: storage?.idStorage ?? -1,
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
            Expanded(
              child: Text(
                storage?.title ?? '',
                overflow: TextOverflow.ellipsis,
                style: getTextColor,
              ),
            ),
            const SizedBox(width: 8),
            ActionHoverButton(
              icon: Assets.icons.cloud,
              bgColor: const Color(AppColors.bgDarkGray3),
              isHover: isHover.value,
            ),
          ],
        ),
      ),
    );
  }
}
