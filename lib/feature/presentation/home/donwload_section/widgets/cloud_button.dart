import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';

class DonwloadSectionCloudButton extends StatefulWidget {
  const DonwloadSectionCloudButton({super.key});

  @override
  State<DonwloadSectionCloudButton> createState() => _DonwloadSectionCloudButtonState();
}

class _DonwloadSectionCloudButtonState extends State<DonwloadSectionCloudButton> {
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
        margin: EdgeInsets.only(right: h10, bottom: h10),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: borderRadius4,
          color: isHover
              ? const Color(AppColors.bgLightGrayHover)
              : const Color(AppColors.bgLightGrayButton),
        ),
      ),
    );
  }
}
