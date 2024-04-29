import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:roflit/feature/common/themes/sizes.dart';

class Lines extends StatelessWidget {
  final LinesType type;
  final widthContentLine = w1;
  final widthLine = h2;
  final widthSectionLine = h6;
  final color = const Color(0xFFC2C2C2);
  final colorDark = Color(0xFF292929);

  Lines.vertical() : type = LinesType.vertical;
  Lines.verticalContent() : type = LinesType.verticalContent;
  Lines.horMid() : type = LinesType.horizontalMid;

  double get _centerLinePos => (widthSectionLine - widthLine) / 2;

  double get _moreSideWidth => widthSectionLine / 2 + 72;

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
                color: color,
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
              color: color,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: widthSectionLine,
              width: widthSectionLine,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
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
                color: color,
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
              color: color,
            ),
          ),
          Positioned(
            right: -_moreSideWidth,
            child: Container(
              height: widthSectionLine,
              width: widthSectionLine,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
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
