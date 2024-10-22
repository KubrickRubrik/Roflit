import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/entity/account.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:roflit/feature/common/themes/text.dart';

class MenuAccountContentEmpty extends ConsumerWidget {
  const MenuAccountContentEmpty({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(sessionBlocProvider.select((v) {
      return v.maybeWhen(
        orElse: () => <AccountEntity>[],
        loaded: (_, accounts) => accounts,
      );
    }));

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Нет активных аккаунтов.'.translate,
              textAlign: TextAlign.center,
              style: appTheme.textTheme.title2.onDark1,
            ),
            const SizedBox(height: 16),
            Text(
              'Создайте новый аккаунт, чтобы привязать к нему профиль хранилища.'.translate,
              textAlign: TextAlign.center,
              style: appTheme.textTheme.title2.onDark1,
            ),
            if (accounts.isEmpty) ...[
              const SizedBox(height: 40),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Или используйте '.translate,
                  style: appTheme.textTheme.title2.onDark1.copyWith(
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: 'дефолтные'.translate,
                      style: appTheme.textTheme.title2.bold.selected1,
                    ),
                    TextSpan(
                      text: ' аккаунты'.translate,
                      style: appTheme.textTheme.title2.onDark1.copyWith(
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
