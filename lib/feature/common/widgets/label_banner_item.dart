import 'package:flutter/material.dart';
import 'package:roflit/core/enums.dart';
import 'package:roflit/feature/common/widgets/image.dart';
import 'package:roflit/generated/assets.gen.dart';

class ObjectItemBunner extends StatelessWidget {
  final IconSourceType type;
  final String? remotePath;
  final String? localPath;

  const ObjectItemBunner({
    required this.type,
    this.remotePath,
    this.localPath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      IconSourceType.bucket => Assets.icons.bucket.svg(),
      IconSourceType.image => ImageSection(
          mainRemoteImage: remotePath,
          mainLocalImage: localPath,
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
