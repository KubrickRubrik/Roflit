import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roflit/feature/common/providers/ui/provider.dart';
import 'package:roflit/feature/common/widgets/action_section_button.dart';
import 'package:roflit/generated/assets.gen.dart';

import 'widgets/account_menu.dart';
import 'widgets/config_button.dart';
import 'widgets/objects_hover.dart';
import 'widgets/objects_list.dart';

class LoadingSection extends ConsumerWidget {
  const LoadingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(uiBlocProvider.notifier);

    return LayoutBuilder(builder: (context, constr) {
      return Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 64,
            alignment: Alignment.bottomLeft,
            child: ActionSectionButton(
              icon: Assets.icons.profile,
              onTap: () {
                bloc.menuActivity(
                  typeMenu: TypeMenu.account,
                  action: ActionMenu.open,
                );
              },
            ),
          ),
          Flexible(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.only(left: 2, top: 14, bottom: 14),
              child: LoadingSectionHoverObjects(
                child: Stack(
                  children: [
                    Center(
                      child: LoadingSectionObjectsList(),
                    ),
                    LoadingSectionAccountsMenu(width: constr.maxWidth),
                  ],
                ),
              ),
            ),
            // child: LoadingSectionEmpty(),
          ),
          Container(
            height: 64,
            alignment: Alignment.topLeft,
            child: const LoadingSectionConfigButton(),
          ),
        ],
      );
    });
  }
}
