import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/feature/common/providers/ui/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/action_menu_button.dart';

class LoadingSectionAccountsMenu extends ConsumerWidget {
  final double width;
  const LoadingSectionAccountsMenu({required this.width, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(uiBlocProvider.notifier);
    final isDisplayedAccountMenu = ref.watch(
      uiBlocProvider.select((v) => v.isDisplayedAccountMenu),
    );

    return AnimatedPositioned(
      top: 0,
      left: isDisplayedAccountMenu ? 0 : -width,
      right: isDisplayedAccountMenu ? 0 : width,
      duration: const Duration(milliseconds: 250),
      curve: Curves.ease,
      child: InkWell(
        onTap: () {},
        onHover: (value) {
          bloc.hoverOrLeaveAccountMenu(isHover: value);
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
                        'Аккаунт'.translate,
                        overflow: TextOverflow.fade,
                        style: appTheme.textTheme.title2.bold.onDark1,
                      ),
                    ),
                    ActionMenuButton(
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
