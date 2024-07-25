import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roflit/feature/common/providers/file_manager/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/generated/assets.gen.dart';

class SectionContentNavigationHeaderBar extends ConsumerWidget {
  const SectionContentNavigationHeaderBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultDirectory = ref.watch(fileManagerBlocProvider.select((v) {
      return (
        pathSelectFiles: v.account?.activeStorage?.pathSelectFiles,
        pathSaveFiles: v.account?.activeStorage?.pathSaveFiles,
      );
    }));

    return LayoutBuilder(builder: (context, constr) {
      return Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (defaultDirectory.pathSelectFiles != null) ...[
                    Text(
                      'CD: ${defaultDirectory.pathSelectFiles ?? ''}',
                      overflow: TextOverflow.ellipsis,
                      style: appTheme.textTheme.title2.bold.onDark2,
                    ),
                  ],
                  if (defaultDirectory.pathSaveFiles != null) ...[
                    Text(
                      'CD: ${defaultDirectory.pathSaveFiles ?? ''}',
                      overflow: TextOverflow.ellipsis,
                      style: appTheme.textTheme.title2.bold.onDark2,
                    ),
                  ],
                ],
              ),
            ),
          ),
          _ContentSectionNavigationHEaderBarSearch(maxWidth: constr.maxWidth),
        ],
      );
    });
  }
}

class _ContentSectionNavigationHEaderBarSearch extends StatefulWidget {
  final double maxWidth;
  const _ContentSectionNavigationHEaderBarSearch({required this.maxWidth});

  @override
  State<_ContentSectionNavigationHEaderBarSearch> createState() =>
      __ContentSectionNavigationHEaderBarSearchState();
}

class __ContentSectionNavigationHEaderBarSearchState
    extends State<_ContentSectionNavigationHEaderBarSearch> {
  bool isActiveSeek = false;
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onHover: (value) {
        isHover = value;
        setState(() {});
      },
      mouseCursor: MouseCursor.defer,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
        margin: const EdgeInsets.only(right: 10, top: 2),
        height: 40,
        width: isActiveSeek ? widget.maxWidth * 0.5 : 40,
        decoration: BoxDecoration(
          borderRadius: borderRadius8,
          color:
              isHover ? const Color(AppColors.bgDarkGrayHover) : const Color(AppColors.bgDarkGray1),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  isActiveSeek = !isActiveSeek;
                  setState(() {});
                },
                child: SizedBox(
                  height: 48,
                  width: 40,
                  child: Center(
                    child: Assets.icons.search.svg(
                        height: 20,
                        width: 20,
                        colorFilter: const ColorFilter.mode(
                          Color(AppColors.textOnDark1),
                          BlendMode.srcIn,
                        )),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 40,
              left: 0,
              child: Center(
                child: TextField(
                  maxLength: 32,
                  maxLines: 1,
                  style: appTheme.textTheme.title2.onDark1,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    isDense: true,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    counterText: '',
                    hintText: 'Поиск',
                    hintStyle: appTheme.textTheme.title2.onDark2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
