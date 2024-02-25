import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:roflit/feature/common/themes/colors.dart';

class ItemFile extends HookWidget {
  const ItemFile(this.index, {super.key});
  final int index;

  @override
  Widget build(BuildContext context) {
    final isHover = useState(false);
    final color = useMemoized(() {
      return index.isEven
          ? const Color(AppColors.bgLightGray).withOpacity(0.3)
          : const Color(AppColors.bgLightGray).withOpacity(0.2);
    });
    return InkWell(
      onTap: () {},
      onHover: (value) {
        isHover.value = value;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.ease,
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isHover.value ? const Color(AppColors.bgLightGrayHover) : color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
