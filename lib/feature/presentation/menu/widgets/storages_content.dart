import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/core/page_dto/storage_page_dto.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/action_hover_button.dart';
import 'package:roflit/feature/common/widgets/loader.dart';
import 'package:roflit/feature/presentation/menu/router/router.dart';
import 'package:roflit/generated/assets.gen.dart';

class MainMenuStoragesContent extends ConsumerWidget {
  const MainMenuStoragesContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionBlocProvider);

    return state.maybeWhen(
      orElse: () => const SizedBox.shrink(),
      loading: () => const Loader(),
      loaded: (session, accounts) {
        return const _MainMenuStoragesContentList();
      },
    );
  }
}

class _MainMenuStoragesContentList extends ConsumerWidget {
  const _MainMenuStoragesContentList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocSession = ref.watch(sessionBlocProvider.notifier);
    final storages = ref.watch(sessionBlocProvider.select((v) {
      return blocSession.getAccount(getActive: true)?.storages ?? [];
    }));

    if (storages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Нет действующих хранилищ.'.translate,
                textAlign: TextAlign.center,
                style: appTheme.textTheme.body2.bold.onDark1,
              ),
              const SizedBox(height: 16),
              Text(
                'Добавьте новый профиль хранилища'.translate,
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
                      style: appTheme.textTheme.body2.bold.selected1,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.pushNamed(RouteEndPoints.info.name);
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
        itemCount: storages.length,
        itemBuilder: (context, index) {
          return _StoragesListItem(index);
        },
      );
    }
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
        rootNavigatorKey.currentContext?.goNamed(
          RouteEndPoints.accounts.account.storages.storage.name,
          extra: StoragePageDto(
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
