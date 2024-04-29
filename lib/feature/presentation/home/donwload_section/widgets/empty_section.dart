import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';

class DonwloadSectionEmpty extends StatefulWidget {
  const DonwloadSectionEmpty({super.key});

  @override
  State<DonwloadSectionEmpty> createState() => _DonwloadSectionEmptyState();
}

class _DonwloadSectionEmptyState extends State<DonwloadSectionEmpty> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onHover: (value) {
        isHover = value;
        setState(() {});
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
        opacity: isHover ? 1 : 0,
        child: Container(
          margin: EdgeInsets.only(top: h14, bottom: h14, right: h10),
          decoration: BoxDecoration(
            borderRadius: borderRadius4,
            color: const Color(AppColors.bgLightGrayOpacity10),
          ),
          child: const Center(
            child: Text(
              'ОЧЕРЕДЬ\r\nСКАЧИВАНИЯ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(AppColors.onLightText),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
