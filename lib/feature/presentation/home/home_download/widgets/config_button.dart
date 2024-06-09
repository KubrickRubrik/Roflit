import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';

class DownloadSectionConfigButton extends StatefulWidget {
  const DownloadSectionConfigButton({super.key});

  @override
  State<DownloadSectionConfigButton> createState() => _DownloadSectionConfigButtonState();
}

class _DownloadSectionConfigButtonState extends State<DownloadSectionConfigButton> {
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
        margin: const EdgeInsets.only(right: 10, top: 10),
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
