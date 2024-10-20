import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/feature/common/providers/file_manager/provider.dart';
import 'package:roflit/feature/common/providers/search/provider.dart';
import 'package:roflit/feature/common/providers/session/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/generated/assets.gen.dart';

class SectionContentNavigationHeaderBar extends ConsumerWidget {
  const SectionContentNavigationHeaderBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocSession = ref.watch(sessionBlocProvider.notifier);

    final storage = ref.watch(sessionBlocProvider.select((v) {
      return blocSession.getStorage(getActive: true);
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
                  InkWell(
                    onTap: () {
                      if (storage != null) {
                        EasyThrottle.throttle(
                          'select_upload_files',
                          const Duration(seconds: 2),
                          () {
                            ref.read(fileManagerBlocProvider.notifier).setPathToUploadFiles(
                                  idStorage: storage.idStorage,
                                  isRequiredInstallation: false,
                                );
                          },
                        );
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 22,
                          width: 22,
                          decoration: BoxDecoration(
                            color: const Color(AppColors.bgOnRed),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.upload_rounded,
                            size: 16,
                            color: Color(AppColors.textOnLight1),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            switch (storage?.pathSelectFiles?.isNotEmpty == true) {
                              true => 'CD: ${storage?.pathSelectFiles ?? ''}',
                              _ => 'CD: Каталог для загрузки',
                            },
                            overflow: TextOverflow.ellipsis,
                            style: appTheme.textTheme.title3.bold.onDark2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () {
                      if (storage != null) {
                        EasyThrottle.throttle(
                          'select_upload_files',
                          const Duration(seconds: 2),
                          () {
                            ref.read(fileManagerBlocProvider.notifier).setPathToSaveFiles(
                                  idStorage: storage.idStorage,
                                  isRequiredInstallation: false,
                                );
                          },
                        );
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 22,
                          width: 22,
                          decoration: BoxDecoration(
                            color: const Color(AppColors.bgOnOrange),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.download,
                            size: 16,
                            color: Color(AppColors.textOnLight1),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            switch (storage?.pathSaveFiles?.isNotEmpty == true) {
                              true => 'CD: ${storage?.pathSaveFiles ?? ''}',
                              _ => 'CD: Каталог для скачивания',
                            },
                            overflow: TextOverflow.ellipsis,
                            style: appTheme.textTheme.title3.bold.onDark2,
                          ),
                        ),
                      ],
                    ),
                  ),
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

class _ContentSectionNavigationHEaderBarSearch extends HookConsumerWidget {
  final double maxWidth;

  const _ContentSectionNavigationHEaderBarSearch({
    required this.maxWidth,
  });

  String sourceString(SearchSource source) {
    return switch (source) {
      SearchSource.bucket => ':: бакет / ',
      SearchSource.object => ':: объект / ',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActiveSeek = useState(false);
    final stateHover = useState(false);
    final controller = useTextEditingController();

    final sourceSearch = ref.watch(searchBlocProvider.select((v) {
      return v.source;
    }));

    return InkWell(
      onTap: () {},
      onHover: (value) {
        stateHover.value = value;
      },
      mouseCursor: MouseCursor.defer,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
        margin: const EdgeInsets.only(right: 10, top: 2),
        height: 40,
        width: isActiveSeek.value ? maxWidth * 0.5 : 40,
        decoration: BoxDecoration(
          borderRadius: borderRadius8,
          color: stateHover.value
              ? const Color(AppColors.bgDarkGrayHover)
              : const Color(AppColors.bgDarkGray1),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  isActiveSeek.value = !isActiveSeek.value;
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AnimatedDefaultTextStyle(
                    style: appTheme.textTheme.title2.copyWith(
                      color: isActiveSeek.value
                          ? const Color(AppColors.textOnDark2)
                          : Colors.transparent,
                    ),
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      sourceString(sourceSearch),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  isActiveSeek.value = !isActiveSeek.value;
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
                  controller: controller,
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
                    prefixText: sourceString(sourceSearch),
                    prefixStyle: const TextStyle(color: Colors.transparent),
                    counterText: '',
                    hintText: 'найти',
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
