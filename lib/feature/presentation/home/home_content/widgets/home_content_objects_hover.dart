import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/presentation/home/home_content/home_content_objects.dart';

class HomeContentObjectsHover extends StatefulWidget {
  final HomeContentObjects child;
  const HomeContentObjectsHover({required this.child, super.key});

  @override
  State<HomeContentObjectsHover> createState() => _HomeContentObjectsHoverState();
}

class _HomeContentObjectsHoverState extends State<HomeContentObjectsHover> {
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
