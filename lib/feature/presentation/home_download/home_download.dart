import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roflit/feature/common/providers/file_download/provider.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:roflit/feature/common/providers/ui/provider.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/action_section_button.dart';
import 'package:roflit/feature/presentation/home_download/widgets/uploads_empty.dart';
import 'package:roflit/generated/assets.gen.dart';

import 'widgets/config_menu.dart';
import 'widgets/objects_hover.dart';
import 'widgets/objects_list.dart';
import 'widgets/storage_menu.dart';

class HomeDownload extends ConsumerWidget {
  const HomeDownload({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocSession = ref.watch(sessionBlocProvider.notifier);
    final blocUI = ref.watch(uiBlocProvider.notifier);

    final storage = ref.watch(sessionBlocProvider.select((v) {
      return blocSession.getStorage(getActive: true);
    }));

    final uploadsLength = ref.watch(downloadBlocProvider.select((value) {
      return value.items.length;
    }));

    return Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: 64,
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (storage != null)
                InkWell(
                  onTap: () {
                    blocUI.menuActivity(
                      typeMenu: TypeMenu.storage,
                      action: ActionMenu.open,
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        storage.title,
                        overflow: TextOverflow.ellipsis,
                        style: appTheme.textTheme.caption1.bold.onDark1,
                      ),
                      Text(
                        storage.storageType.title,
                        overflow: TextOverflow.ellipsis,
                        style: appTheme.textTheme.caption3.bold.onDark1,
                      ),
                    ],
                  ),
                ),
              ActionSectionButton(
                icon: Assets.icons.cloud,
                onTap: () {
                  blocUI.menuActivity(
                    typeMenu: TypeMenu.storage,
                    action: ActionMenu.open,
                  );
                },
              ),
            ],
          ),
        ),
        Flexible(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.only(right: 2, top: 14, bottom: 14),
            child: LayoutBuilder(builder: (context, constrains) {
              return DownloadSectionHoverObjects(
                child: Stack(
                  children: [
                    switch (uploadsLength) {
                      0 => const DownloadsSectionEmpty(),
                      _ => Center(
                          child: HomeDownloadObjectsList(),
                        ),
                    },
                    HomeDownloadStorageMenu(constrains: constrains),
                    HomeDownloadConfigMenu(constrains: constrains),
                  ],
                ),
              );
            }),
          ),
        ),
        Container(
          height: 64,
          alignment: Alignment.topRight,
          child: ActionSectionButton(
            icon: Assets.icons.cloud,
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              blocUI.menuActivity(
                typeMenu: TypeMenu.downloadConfig,
                action: ActionMenu.open,
              );
            },
          ),
        ),
      ],
    );
  }
}
