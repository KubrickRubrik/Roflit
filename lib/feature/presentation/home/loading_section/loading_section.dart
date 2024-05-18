import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:roflit/feature/common/providers/ui/provider.dart';
import 'package:roflit/feature/common/themes/text.dart';
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

    final account = ref.watch(sessionBlocProvider.select((v) {
      if (v is! SessionLoadedState) return null;

      return v.accounts.firstWhereOrNull((e) {
        return e.idAccount == v.session.activeIdAccount;
      });
    }));

    return LayoutBuilder(builder: (context, constr) {
      return Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 64,
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                ActionSectionButton(
                  icon: Assets.icons.profile,
                  onTap: () {
                    bloc.menuActivity(
                      typeMenu: TypeMenu.account,
                      action: ActionMenu.open,
                    );
                  },
                ),
                if (account != null)
                  InkWell(
                    onTap: () {
                      bloc.menuActivity(
                        typeMenu: TypeMenu.account,
                        action: ActionMenu.open,
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.name,
                          overflow: TextOverflow.ellipsis,
                          style: appTheme.textTheme.caption1.bold.onDark1,
                        ),
                        Text(
                          account.localization.name.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: appTheme.textTheme.caption3.bold.onDark1,
                        ),
                      ],
                    ),
                  ),
              ],
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
