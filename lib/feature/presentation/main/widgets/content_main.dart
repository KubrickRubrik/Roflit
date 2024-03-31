import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/presentation/main/bloc/notifier.dart';

import 'content_main_bar.dart';
import 'content_main_buckets.dart';
import 'content_main_progress.dart';
import 'decoration_section.dart';

class ContentMain extends StatelessWidget {
  const ContentMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DecorationSection(
        left: WrapDecorationSectionStyle(
            thickness: 1,
            padding: const WrapDecorationSectionPadding(start: 0, end: 100),
            dots: const WrapDecorationSectionDot(start: true, end: true, radius: 2)),
        right: WrapDecorationSectionStyle(
            thickness: 1,
            padding: const WrapDecorationSectionPadding(start: 64, end: 100),
            dots: const WrapDecorationSectionDot(start: true, end: true, radius: 2)),
        child: const Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContentMainBar(),
                    SizedBox(height: 32),
                    ContentMainBuckets(),
                  ],
                ),
              ),
            ),
            ContentMainProgress(),
            SizedBox(height: 16),
            SelectFilesButton(),
          ],
        ),
      ),
    );
  }
}

class SelectFilesButton extends HookConsumerWidget {
  const SelectFilesButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainNotifierProvider);
    final bloc = ref.watch(mainNotifierProvider.notifier);

    final isHover = useState(false);
    return InkWell(
      onTap: () {
        EasyThrottle.throttle('get-file', const Duration(seconds: 1), () async {
          // final file = await FilePicker.platform.pickFiles();
          await bloc.getData();
        });
      },
      onHover: (value) {
        isHover.value = value;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.ease,
        height: 56,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isHover.value
              ? const Color(AppColors.bgLightGrayHover)
              : const Color(AppColors.bgLightGray),
          borderRadius: BorderRadius.circular(4),
        ),
        constraints: const BoxConstraints(
          maxWidth: 1280,
        ),
        alignment: Alignment.center,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 350),
          curve: Curves.ease,
          style: isHover.value
              ? const TextStyle(
                  fontSize: 18,
                  color: Color(AppColors.onDarkText),
                  fontWeight: FontWeight.w600,
                )
              : const TextStyle(
                  fontSize: 18,
                  color: Color(AppColors.onLightText),
                  fontWeight: FontWeight.w600,
                ),
          child: const Text(
            'Выберите файлы для загрузки',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
