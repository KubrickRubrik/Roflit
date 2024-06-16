import 'package:flutter/material.dart';
import 'package:roflit/core/services/format_converter.dart';
import 'package:roflit/feature/common/widgets/image.dart';
import 'package:roflit/generated/assets.gen.dart';

class LabelBannerItem extends StatelessWidget {
  final String? path;

  const LabelBannerItem({
    this.path,
    super.key,
  });

  IconSourceType get file => FormatConverter.converter(path);

  @override
  Widget build(BuildContext context) {
    return switch (file) {
      IconSourceType.bucket => Assets.icons.bucket.svg(),
      IconSourceType.image => ImageSection(
          mainRemoteImage: path,
          errorWidget: Assets.icons.fileImage.svg(),
        ),
      IconSourceType.doc => Assets.icons.fileDoc.svg(),
      IconSourceType.folder => Assets.icons.folder.svg(),
      IconSourceType.archive => Assets.icons.fileArchive.svg(),
      IconSourceType.program => Assets.icons.fileProgram.svg(),
      IconSourceType.music => Assets.icons.fileMusic.svg(),
      IconSourceType.video => Assets.icons.fileVideo.svg(),
      IconSourceType.other => Assets.icons.fileOther.svg(),
    };
  }
}
