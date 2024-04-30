import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/generated/assets.gen.dart';

class LoadingSectionAccountButton extends StatefulWidget {
  const LoadingSectionAccountButton({super.key});

  @override
  State<LoadingSectionAccountButton> createState() => _LoadingSectionAccountButtonState();
}

class _LoadingSectionAccountButtonState extends State<LoadingSectionAccountButton> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onHover: (value) {
        isHover = value;
        setState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
        margin: const EdgeInsets.only(left: 10, bottom: 10),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: borderRadius8,
          color:
              isHover ? const Color(AppColors.bgDarkGrayHover) : const Color(AppColors.bgDarkGray1),
        ),
        alignment: Alignment.center,
        child: Assets.icons.profile.svg(
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
