import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/feature/common/providers/buckets/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/common/widgets/home_content_text_field.dart';
import 'package:roflit/feature/presentation/home/home_content/home_content_buckets.dart';

class HomeContentBucketsHover extends HookWidget {
  final HomeContentBuckets child;
  const HomeContentBucketsHover({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final stateHover = useState(false);

    return InkWell(
      onTap: () {},
      onHover: (value) {
        stateHover.value = value;
      },
      child: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.ease,
              margin: EdgeInsets.only(top: h8, left: h8, bottom: h8),
              decoration: BoxDecoration(
                color: stateHover.value ? const Color(AppColors.bgLightGrayOpacity10) : null,
              ),
              child: child,
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            sizeCurve: Curves.ease,
            crossFadeState:
                (!stateHover.value) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: const SizedBox.shrink(),
            secondChild: const HomeContentCreateBucket(),
          ),
        ],
      ),
    );
  }
}

class HomeContentCreateBucket extends HookConsumerWidget {
  const HomeContentCreateBucket({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = ref.watch(bucketsBlocProvider.notifier);
    final controller = useTextEditingController();
    final stateHover = useState(false);

    return InkWell(
      onTap: () {},
      onHover: (value) {
        stateHover.value = value;
      },
      child: Column(
        children: [
          Container(
            height: 200,
            margin: const EdgeInsets.only(bottom: 8, left: 24, right: 24),
            // color: Colors.blueGrey.shade800,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(AppColors.bgDarkGray2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: HomeContentTextField(
                    controller: controller,
                    hint: 'Название бакета'.translate,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              bloc.createBucket(bucketName: controller.text);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.ease,
              height: stateHover.value ? 64 : 48,
              margin: EdgeInsets.only(left: h8, bottom: 0),
              decoration: BoxDecoration(
                color: stateHover.value ? const Color(AppColors.bgLightGrayOpacity10) : null,
              ),
              alignment: Alignment.center,
              child: Text(
                'Создать бакет'.translate,
                style: appTheme.textTheme.title2.onDark1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
