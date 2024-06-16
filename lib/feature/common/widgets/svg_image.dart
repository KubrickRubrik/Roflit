import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgImage extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final bool useIconThemeColor;

  /// parameter color takes precedence over colorMap, if set
  final Map<Color, Color>? colorMap;

  const SvgImage(
    this.assetName, {
    this.width,
    this.height,
    this.color,
    this.colorMap,
    this.fit = BoxFit.contain,
    this.useIconThemeColor = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentColor = useIconThemeColor ? IconTheme.of(context).color : color;
    return _ColorMappedSvgImage(
      assetName,
      width: width,
      height: height,
      fit: fit,
      colorFilter: useIconThemeColor || color != null
          ? ColorFilter.mode(currentColor!, BlendMode.srcIn)
          : null,
      colorMap: colorMap,
    );
  }
}

class _ColorMappedSvgImage extends SvgPicture {
  final Map<Color, Color>? colorMap;

  _ColorMappedSvgImage(
    String string, {
    this.colorMap,
    super.width,
    super.height,
    super.fit = BoxFit.contain,
    super.colorFilter,
    super.theme = const SvgTheme(),
  }) : super(
          SvgAssetLoader(
            string,
            theme: theme,
            colorMapper: colorMap != null ? _DynamicColorMapper(colorMap: colorMap) : null,
          ),
        );
}

class _DynamicColorMapper extends ColorMapper {
  final Map<Color, Color> colorMap;

  const _DynamicColorMapper({required this.colorMap});

  @override
  Color substitute(String? id, String elementName, String attributeName, Color color) {
    final substitutableColor = colorMap[color];
    return substitutableColor ?? color;
  }
}
