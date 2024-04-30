import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';

class ContentSectionHoverObjects extends StatefulWidget {
  final Widget child;
  const ContentSectionHoverObjects({required this.child, super.key});

  @override
  State<ContentSectionHoverObjects> createState() => _ContentSectionHoverObjectsState();
}

class _ContentSectionHoverObjectsState extends State<ContentSectionHoverObjects> {
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
        decoration: BoxDecoration(
          color: isHover ? const Color(AppColors.bgLightGrayOpacity10) : null,
          borderRadius: borderRadius12,
        ),
        child: widget.child,
      ),
    );
  }
}
