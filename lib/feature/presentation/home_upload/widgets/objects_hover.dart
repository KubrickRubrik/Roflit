import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';

class LoadingSectionHoverObjects extends StatefulWidget {
  final Widget child;
  const LoadingSectionHoverObjects({required this.child, super.key});

  @override
  State<LoadingSectionHoverObjects> createState() => _LoadingSectionHoverObjectsState();
}

class _LoadingSectionHoverObjectsState extends State<LoadingSectionHoverObjects> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onHover: (value) {
        isHover = value;
        setState(() {});
      },
      mouseCursor: MouseCursor.defer,
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
