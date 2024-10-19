import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';

class LoadingSectionEmpty extends StatefulWidget {
  const LoadingSectionEmpty({super.key});

  @override
  State<LoadingSectionEmpty> createState() => _LoadingSectionEmptyState();
}

class _LoadingSectionEmptyState extends State<LoadingSectionEmpty> {
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
          margin: const EdgeInsets.only(left: 2, top: 14, bottom: 14),
          decoration: BoxDecoration(
            borderRadius: borderRadius4,
            color: const Color(AppColors.bgLightGrayOpacity10),
          ),
          child: Center(
            child: Text(
              'ОЧЕРЕДЬ\r\nЗАГРУЗКИ',
              textAlign: TextAlign.center,
              style: appTheme.textTheme.title3.bold.onDark1,
            ),
          ),
        ),
      ),
    );
  }
}
