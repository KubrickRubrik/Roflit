import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';

class Button extends HookWidget {
  final Size size;
  final Color? hoverColor;
  final Color? defaultColor;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? margin;
  final Widget child;
  final VoidCallback onTap;

  const Button({
    required this.onTap,
    required this.size,
    required this.child,
    this.hoverColor,
    this.defaultColor,
    this.borderRadius,
    this.margin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final stateHover = useState(false);

    return InkWell(
      onTap: onTap,
      onHover: (value) {
        stateHover.value = value;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 4),
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? borderRadius8,
          color: stateHover.value
              ? hoverColor ?? const Color(AppColors.bgDarkGrayHover)
              : defaultColor ?? const Color(AppColors.bgDarkGray1),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
