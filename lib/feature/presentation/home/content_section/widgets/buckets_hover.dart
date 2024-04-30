import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';

class ContentSectionHoverBuckets extends StatefulWidget {
  final Widget child;
  const ContentSectionHoverBuckets({required this.child, super.key});

  @override
  State<ContentSectionHoverBuckets> createState() => _ContentSectionHoverBucketsState();
}

class _ContentSectionHoverBucketsState extends State<ContentSectionHoverBuckets> {
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
        margin: EdgeInsets.only(top: h8, left: h8, bottom: h8),
        decoration: BoxDecoration(
          color: isHover ? const Color(AppColors.bgLightGrayOpacity10) : null,
        ),
        child: widget.child,
      ),
    );
  }
}
