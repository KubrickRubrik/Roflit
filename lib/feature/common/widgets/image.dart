import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';

class ImageSection extends StatelessWidget {
  final bool isSkeleton;

  /// The local image is displayed first if available.
  final String? mainLocalImage;

  /// If a local image is not available, the remote image is used.
  final String? mainRemoteImage;

  /// Placeholder image is displayed while the remote image is loading.
  final String? placeholderLocalImage;
  final Widget? placeholderWidget;

  /// An error image is displayed when the deleted image could not be loaded and displayed.
  final String? errorLocalImage;
  final Widget? errorWidget;
  //
  final Size? size;
  // To use aspectRatio, the dimensions of the parent widget must be set.
  final double? aspectRatio;
  //
  final BorderRadius borderRadius;

  const ImageSection({
    this.mainLocalImage,
    this.mainRemoteImage,
    this.placeholderLocalImage,
    this.placeholderWidget,
    this.errorLocalImage,
    this.errorWidget,
    this.size,
    this.aspectRatio,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.isSkeleton = false,
    super.key,
  }) : assert(!(mainLocalImage == null && mainRemoteImage == null && isSkeleton != true),
            'At least one image must be provided');

  Widget get _placeholder => const ColoredBox(
        color: Color(AppColors.bgPlaceholder1),
      );

  Widget get _image {
    if (isSkeleton) {
      return _placeholder;
    } else if (mainLocalImage?.isNotEmpty == true) {
      return Image.file(
        File(mainLocalImage!),
        fit: BoxFit.cover,
        height: size?.height,
        width: size?.width,
        errorBuilder: (context, _, e) => _placeholder,
      );
    } else if (mainRemoteImage?.isNotEmpty == true) {
      return CachedNetworkImage(
        imageUrl: mainRemoteImage!,
        fit: BoxFit.cover,
        height: size?.height,
        width: size?.width,
        placeholder: (context, _) {
          if (placeholderLocalImage?.isNotEmpty == true) {
            return Image.file(
              File(placeholderLocalImage!),
              fit: BoxFit.cover,
              height: size?.height,
              width: size?.width,
              errorBuilder: (context, _, e) => _placeholder,
            );
          } else if (placeholderWidget != null) {
            return placeholderWidget!;
          }
          return _placeholder;
        },
        errorWidget: (_, __, ___) {
          if (errorLocalImage?.isNotEmpty == true) {
            return Image.file(
              File(errorLocalImage!),
              fit: BoxFit.cover,
              height: size?.height,
              width: size?.width,
              errorBuilder: (context, _, e) => _placeholder,
            );
          } else if (errorWidget != null) {
            return errorWidget!;
          }
          return _placeholder;
        },
      );
    } else {
      return _placeholder;
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = SizedBox(
      height: size?.height,
      width: size?.width,
      child: ClipRRect(
        borderRadius: borderRadius,
        clipBehavior: Clip.hardEdge,
        child: _image,
      ),
    );

    if (aspectRatio != null) {
      return AspectRatio(
        aspectRatio: aspectRatio!,
        child: child,
      );
    }

    return child;
  }
}
