import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';

class DecorationSection extends StatelessWidget {
  const DecorationSection({
    required this.child,
    super.key,
    this.left,
    this.right,
    this.top,
    this.bottom,
  });
  final WrapDecorationSectionStyle? top;
  final WrapDecorationSectionStyle? left;
  final WrapDecorationSectionStyle? right;
  final WrapDecorationSectionStyle? bottom;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (top != null)
          Positioned(
            top: 0,
            left: top!.padding.start,
            right: top!.padding.end,
            height: top!.constraints,
            child: HorizontalEdge(style: top!),
          ),
        if (left != null)
          Positioned(
            top: left!.padding.start,
            bottom: left!.padding.end,
            left: 0,
            width: left!.constraints,
            child: VerticalEdge(style: left!),
          ),
        if (right != null)
          Positioned(
            top: left!.padding.start,
            bottom: left!.padding.end,
            right: 0,
            width: right!.constraints,
            child: VerticalEdge(style: right!),
          ),
        if (bottom != null)
          Positioned(
            bottom: 0,
            left: bottom!.padding.start,
            right: bottom!.padding.end,
            height: bottom!.constraints,
            child: HorizontalEdge(style: bottom!),
          ),
      ],
    );
  }
}

class HorizontalEdge extends StatelessWidget {
  final WrapDecorationSectionStyle style;
  const HorizontalEdge({
    required this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: style.gapSide,
          bottom: style.gapSide,
          left: style.dots.start ? style.dots.radius : 0,
          right: style.dots.end ? style.dots.radius : 0,
          child: Container(
            height: style.thickness,
            decoration: BoxDecoration(
              color: style.color,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ),
        if (style.dots.start) dotWIdget,
        if (style.dots.end)
          Align(
            alignment: Alignment.centerRight,
            child: dotWIdget,
          ),
      ],
    );
  }

  Widget get dotWIdget {
    return Container(
      height: style.dots.diameter,
      width: style.dots.diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: style.dots.color,
      ),
    );
  }
}

class VerticalEdge extends StatelessWidget {
  final WrapDecorationSectionStyle style;
  const VerticalEdge({
    required this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: style.dots.start ? style.dots.radius : 0,
          bottom: style.dots.end ? style.dots.radius : 0,
          left: style.gapSide,
          right: style.gapSide,
          child: Container(
            width: style.thickness,
            decoration: BoxDecoration(
              color: style.color,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ),
        if (style.dots.start) dotWIdget,
        if (style.dots.end) Align(alignment: Alignment.bottomCenter, child: dotWIdget),
      ],
    );
  }

  Widget get dotWIdget {
    return Container(
      height: style.dots.diameter,
      width: style.dots.diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: style.dots.color,
      ),
    );
  }
}

final class WrapDecorationSectionStyle {
  final WrapDecorationSectionPadding padding;
  final double thickness;
  final Color color;
  final WrapDecorationSectionDot dots;

  WrapDecorationSectionStyle({
    this.thickness = 1,
    this.color = const Color(AppColors.grayBorder),
    this.padding = const WrapDecorationSectionPadding(
      start: 250,
      end: 250,
    ),
    this.dots = const WrapDecorationSectionDot(
      start: false,
      end: false,
      radius: 10,
    ),
  });

  double? get gapSide => (dots.diameter != null) ? (dots.diameter! - thickness) / 2 : 0;

  double get constraints => (dots.diameter != null) ? dots.diameter! : thickness;
}

final class WrapDecorationSectionPadding {
  final double start;
  final double end;

  const WrapDecorationSectionPadding({required this.start, required this.end});
}

final class WrapDecorationSectionDot {
  final bool start;
  final bool end;
  final double radius;
  final Color color;

  const WrapDecorationSectionDot({
    this.start = false,
    this.end = false,
    this.radius = 10,
    this.color = const Color(AppColors.grayBorderDot),
  });

  bool get hasDots => start || end;
  double? get diameter => hasDots ? radius * 2 : null;
}
