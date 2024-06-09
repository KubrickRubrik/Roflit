import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/presentation/home/home_content/home_content_buckets.dart';

class HomeContentBucketsHover extends StatefulWidget {
  final HomeContentBuckets child;
  const HomeContentBucketsHover({required this.child, super.key});

  @override
  State<HomeContentBucketsHover> createState() => _HomeContentBucketsHoverState();
}

class _HomeContentBucketsHoverState extends State<HomeContentBucketsHover> {
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
