import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:roflit/feature/common/themes/colors.dart';

class ContentMainBuckets extends StatelessWidget {
  const ContentMainBuckets({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 8,
      children: [
        ContentMainBuckeysItem(0),
        ContentMainBuckeysItem(1),
        ContentMainBuckeysItem(2),
      ],
    );
  }
}

class ContentMainBuckeysItem extends HookWidget {
  const ContentMainBuckeysItem(this.index, {super.key});
  final int index;

  @override
  Widget build(BuildContext context) {
    final isHover = useState(false);
    final color = useMemoized(() {
      return index.isEven
          ? const Color(AppColors.bgDarkGray)
          : const Color(AppColors.bgDarkGray).withOpacity(0.2);
    });
    return InkWell(
      onTap: () {},
      onHover: (value) {
        isHover.value = value;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.ease,
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          color: isHover.value ? const Color(AppColors.bgDarkGrayHover) : color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
