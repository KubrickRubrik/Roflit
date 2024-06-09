import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/presentation/menu/router/router.dart';

class MenuStoragesContentEmpty extends ConsumerWidget {
  const MenuStoragesContentEmpty({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
  }
}
