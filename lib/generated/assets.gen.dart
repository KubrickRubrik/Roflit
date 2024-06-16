/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/bucket.svg
  SvgGenImage get bucket => const SvgGenImage('assets/icons/bucket.svg');

  /// File path: assets/icons/cloud.svg
  SvgGenImage get cloud => const SvgGenImage('assets/icons/cloud.svg');

  /// File path: assets/icons/file_archive.svg
  SvgGenImage get fileArchive => const SvgGenImage('assets/icons/file_archive.svg');

  /// File path: assets/icons/file_doc.svg
  SvgGenImage get fileDoc => const SvgGenImage('assets/icons/file_doc.svg');

  /// File path: assets/icons/file_image.svg
  SvgGenImage get fileImage => const SvgGenImage('assets/icons/file_image.svg');

  /// File path: assets/icons/file_music.svg
  SvgGenImage get fileMusic => const SvgGenImage('assets/icons/file_music.svg');

  /// File path: assets/icons/file_other.svg
  SvgGenImage get fileOther => const SvgGenImage('assets/icons/file_other.svg');

  /// File path: assets/icons/file_program.svg
  SvgGenImage get fileProgram => const SvgGenImage('assets/icons/file_program.svg');

  /// File path: assets/icons/file_video.svg
  SvgGenImage get fileVideo => const SvgGenImage('assets/icons/file_video.svg');

  /// File path: assets/icons/folder.svg
  SvgGenImage get folder => const SvgGenImage('assets/icons/folder.svg');

  /// File path: assets/icons/profile.svg
  SvgGenImage get profile => const SvgGenImage('assets/icons/profile.svg');

  /// File path: assets/icons/search.svg
  SvgGenImage get search => const SvgGenImage('assets/icons/search.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        bucket,
        cloud,
        fileArchive,
        fileDoc,
        fileImage,
        fileMusic,
        fileOther,
        fileProgram,
        fileVideo,
        folder,
        profile,
        search
      ];
}

class $AssetsTranslationsGen {
  const $AssetsTranslationsGen();

  /// File path: assets/translations/ru.json
  String get ru => 'assets/translations/ru.json';

  /// List of all assets
  List<String> get values => [ru];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsTranslationsGen translations = $AssetsTranslationsGen();
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme theme = const SvgTheme(),
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      theme: theme,
      colorFilter: colorFilter,
      color: color,
      colorBlendMode: colorBlendMode,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
