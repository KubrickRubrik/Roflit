import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';

class Lines extends StatelessWidget {
  final LinesType type;
  final widthContentLine = 1.0;
  final widthLine = 1.6;
  final widthSectionLine = 6.0;
  final colorMainLine = const Color(AppColors.borderLineOnDart1);
  final colorDark = const Color(AppColors.borderLineOnLight1);

  Lines.vertical() : type = LinesType.vertical;
  Lines.verticalContent() : type = LinesType.verticalContent;
  Lines.horMid() : type = LinesType.horizontalMid;

  double get _centerLinePos => (widthSectionLine - widthLine) / 2;

  double get _moreSideWidth => widthSectionLine / 2 + 64;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      LinesType.vertical => _vericalLine,
      LinesType.horizontalMid => _horMidLine,
      LinesType.verticalContent => _vericalContentLine,
    };
  }

  Widget get _vericalLine {
    return SizedBox(
      width: widthSectionLine,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
              height: widthSectionLine,
              width: widthSectionLine,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorMainLine,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: _centerLinePos,
            right: _centerLinePos,
            bottom: 0,
            child: Container(
              width: widthLine,
              color: colorMainLine,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: widthSectionLine,
              width: widthSectionLine,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorMainLine,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _vericalContentLine {
    return Container(
      margin: EdgeInsets.symmetric(vertical: h80),
      width: widthContentLine,
      decoration: BoxDecoration(
        color: colorDark,
        borderRadius: borderRadius4,
      ),
    );
  }

  Widget get _horMidLine {
    return SizedBox(
      height: widthSectionLine,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -_moreSideWidth,
            child: Container(
              height: widthSectionLine,
              width: widthSectionLine,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorMainLine,
              ),
            ),
          ),
          Positioned(
            top: _centerLinePos,
            bottom: _centerLinePos,
            left: -_moreSideWidth,
            right: -_moreSideWidth,
            child: Container(
              height: widthLine,
              color: colorMainLine,
            ),
          ),
          Positioned(
            right: -_moreSideWidth,
            child: Container(
              height: widthSectionLine,
              width: widthSectionLine,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorMainLine,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum LinesType {
  vertical,
  horizontalMid,
  verticalContent,
}
