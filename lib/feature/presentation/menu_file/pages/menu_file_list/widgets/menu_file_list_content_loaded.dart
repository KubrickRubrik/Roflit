import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/config/filter_text_constants.dart';
import 'package:roflit/core/config/tag_debounce.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/feature/common/providers/file_manager/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/button.dart';
import 'package:roflit/feature/common/widgets/content_text_field.dart';
import 'package:roflit/feature/common/widgets/label_banner_item.dart';
import 'package:roflit/feature/presentation/menu_file/pages/menu_file_list/widgets/menu_file_list_content_empty.dart';
import 'package:roflit/generated/assets.gen.dart';

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
        if (index < objects.length - 1) {
          return _MenuFileListItem(index);
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _MenuFileListItem(index),
            const SizedBox(height: 2),
            Button(
              onTap: () {
                EasyThrottle.throttle(
                  Tags.selectFileManager,
                  const Duration(seconds: 1),
                  () {
                    ref.read(fileManagerBlocProvider.notifier).addMoreFiles();
                  },
                );
              },
              size: const Size(double.infinity, 48),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '+',
                style: appTheme.textTheme.title1.onDark1,
              ),
            ),
          ],
        );
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

    final stateHover = useState(false);

    if (object == null) return const SizedBox();
    return InkWell(
      onTap: () {},
      onHover: (value) {
        stateHover.value = value;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: stateHover.value
              ? const Color(AppColors.bgDarkGrayHover)
              : const Color(AppColors.bgDarkGray1),
          border: const Border(
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
              child: ContentTextField(
                controller: controller,
                hint: 'Название объекта'.translate,
                textAlign: TextAlign.start,
                style: appTheme.textTheme.title3.bold.onDark1,
                hintStyle: appTheme.textTheme.title3.bold.onDark2,
                filterInputFormatters: [
                  FilterTextConstant.nameObject,
                ],
                onChanged: (String name) {
                  bloc.renameObject(index: index, name: name);
                },
              ),
            ),
            const SizedBox(width: 8),
            Button(
              onTap: () {
                bloc.deleteFileFromList(index);
              },
              hoverColor: const Color(AppColors.bgDarkHover),
              size: const Size.square(40),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Assets.icons.close.svg(
                height: 16,
                width: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
