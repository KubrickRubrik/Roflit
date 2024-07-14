import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/feature/common/providers/upload/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/widgets/upload_object_item.dart';

class HomeUploadObjectsList extends HookConsumerWidget {
  HomeUploadObjectsList({super.key});
  final controller = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useScrollController();

    final uploads = ref.watch(uploadBlocProvider.select((value) {
      return value.uploads;
    }));

    return ClipRRect(
      borderRadius: borderRadius8,
      child: RawScrollbar(
        controller: controller,
        scrollbarOrientation: ScrollbarOrientation.left,
        interactive: true,
        minThumbLength: 18,
        thumbVisibility: true,
        mainAxisMargin: 0,
        crossAxisMargin: 0,
        padding: const EdgeInsets.all(0),
        thumbColor: const Color(AppColors.bgDarkGray1),
        radius: const Radius.circular(4),
        trackVisibility: true,
        trackBorderColor: Colors.transparent,
        thickness: 4,
        trackRadius: const Radius.circular(4),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: ListView.builder(
            controller: controller,
            shrinkWrap: true,
            primary: false,
            itemCount: uploads.length,
            padding: const EdgeInsets.only(left: 3, right: 3, bottom: 10),
            itemBuilder: (context, index) {
              return UploadObjectItem(index: index);
            },
          ),
        ),
      ),
    );
  }
}
