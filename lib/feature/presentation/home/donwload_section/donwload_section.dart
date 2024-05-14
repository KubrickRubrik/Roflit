import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roflit/feature/common/providers/ui/provider.dart';
import 'package:roflit/feature/common/widgets/action_section_button.dart';
import 'package:roflit/generated/assets.gen.dart';

import 'widgets/config_button.dart';
import 'widgets/objects_hover.dart';
import 'widgets/objects_list.dart';
import 'widgets/storage_menu.dart';

class DonwloadSection extends ConsumerWidget {
  const DonwloadSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(uiBlocProvider.notifier);
    return LayoutBuilder(builder: (context, constr) {
      return Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 64,
            alignment: Alignment.bottomRight,
            child: ActionSectionButton(
              icon: Assets.icons.cloud,
              onTap: () {
                bloc.menuActivity(
                  typeMenu: TypeMenu.storage,
                  action: ActionMenu.open,
                );
              },
            ),
          ),
          Flexible(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.only(right: 2, top: 14, bottom: 14),
              child: DonwloadSectionHoverObjects(
                child: Stack(
                  children: [
                    Center(
                      child: DonwloadSectionObjectsList(),
                    ),
                    DownloadSectionStorageMenu(width: constr.maxWidth),
                  ],
                ),
              ),
            ),
            // DonwloadSectionEmpty(),
          ),
          Container(
            height: 64,
            alignment: Alignment.topRight,
            child: const DonwloadSectionConfigButton(),
          ),
        ],
      );
    });
  }
}
