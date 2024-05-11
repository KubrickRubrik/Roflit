import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/generated/assets.gen.dart';

class ActionSectionButton extends HookWidget {
  final SvgGenImage icon;
  final VoidCallback onTap;

  const ActionSectionButton({
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isHover = useState(false);

    return InkWell(
      onTap: onTap,
      onHover: (value) {
        isHover.value = value;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
        margin: const EdgeInsets.all(10),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: borderRadius8,
          color: isHover.value
              ? const Color(AppColors.bgDarkGrayHover)
              : const Color(AppColors.bgDarkGray1),
        ),
        alignment: Alignment.center,
        child: icon.svg(
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            Color(AppColors.textOnDark1),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
