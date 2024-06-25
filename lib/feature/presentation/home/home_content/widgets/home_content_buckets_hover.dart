import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/presentation/home/home_content/home_content_buckets.dart';
import 'package:roflit/feature/presentation/home/home_content/widgets/home_content_buckets_create.dart';

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
                (!stateHover.value) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: const SizedBox.shrink(),
            secondChild: HomeContentCreateBucket(isHoverBuckets: stateHover.value),
          ),
        ],
      ),
    );
  }
}
