import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:roflit/feature/common/providers/ui/provider.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/presentation/home/home_content/home_content_buckets.dart';
import 'package:roflit/feature/presentation/home/home_content/widgets/home_content_buckets_create.dart';

class HomeContentBucketsHover extends HookConsumerWidget {
  final HomeContentBuckets child;
  const HomeContentBucketsHover({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateHover = useState(false);

    final isDisplayBucketMenu = ref.watch(uiBlocProvider.select((v) => v.isDisplayBucketMenu));

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
              margin: const EdgeInsets.only(top: 8, left: 8, bottom: 8),
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
                (!isDisplayBucketMenu) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: const SizedBox.shrink(),
            secondChild: const HomeContentCreateBucket(),
          ),
        ],
      ),
    );
  }
}
