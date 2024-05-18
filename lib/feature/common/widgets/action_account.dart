import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/generated/assets.gen.dart';

class AccountAvatar extends StatelessWidget {
  final SvgGenImage icon;
  final bool isHover;
  final Color bgColor;
  final Color bgHoverColor;

  const AccountAvatar({
    required this.icon,
    required this.isHover,
    this.bgColor = const Color(AppColors.bgDarkGray1),
    this.bgHoverColor = const Color(AppColors.bgDarkGray1),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(vertical: 10),
      curve: Curves.ease,
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: borderRadius8,
        color: isHover ? bgHoverColor : bgColor,
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
    );
  }
}
