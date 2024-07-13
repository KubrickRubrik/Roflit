import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/feature/common/providers/file_manager/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/action_menu_button.dart';
import 'package:roflit/feature/common/widgets/home_content_text_field.dart';
import 'package:roflit/feature/common/widgets/label_banner_item.dart';
import 'package:roflit/feature/presentation/menu_file/pages/menu_file_list/widgets/menu_file_list_content_empty.dart';

class MenuFileListContentLoaded extends ConsumerWidget {
  const MenuFileListContentLoaded({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objects = ref.watch(fileManagerBlocProvider.select((v) {
      return v.objects;
    }));

    if (objects.isEmpty) {
      return const MenuFileListContentEmpty();
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: objects.length,
      itemBuilder: (context, index) {
        return _MenuFileListItem(index);
      },
    );
  }
}

class _MenuFileListItem extends HookConsumerWidget {
  final int index;
  const _MenuFileListItem(this.index);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(fileManagerBlocProvider.notifier);

    final object = ref.watch(fileManagerBlocProvider.select((v) {
      return v.objects.elementAtOrNull(index);
    }));
    final controller = useTextEditingController(
      text: object?.objectKey.objectName.split('.').firstOrNull ?? '',
    );

    if (object == null) return const SizedBox();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2,
            color: Color(AppColors.borderLineOnLight0),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            margin: const EdgeInsets.only(left: 6),
            child: LabelBannerItem(
              type: object.type,
              localPath: object.localPath ?? '',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: HomeContentTextField(
              controller: controller,
              hint: 'Название объекта'.translate,
              style: appTheme.textTheme.title3.bold.onDark1,
              hintStyle: appTheme.textTheme.title3.bold.onDark2,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox.square(
            dimension: 40,
            child: ActionMenuButton(
              onTap: () {
                bloc.deleteFileFromList(index);
              },
              color: const Color(AppColors.bgLight0),
            ),
          ),
        ],
      ),
    );
  }
}
