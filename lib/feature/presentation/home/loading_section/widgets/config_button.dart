import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';

class LoadingSectionConfigButton extends StatefulWidget {
  const LoadingSectionConfigButton({super.key});

  @override
  State<LoadingSectionConfigButton> createState() => _LoadingSectionConfigButtonState();
}

class _LoadingSectionConfigButtonState extends State<LoadingSectionConfigButton> {
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
        margin: const EdgeInsets.only(left: 10, top: 10),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              isHover ? const Color(AppColors.bgDarkGrayHover) : const Color(AppColors.bgDarkGray1),
        ),
      ),
    );
  }
}
