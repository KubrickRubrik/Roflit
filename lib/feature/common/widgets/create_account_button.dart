import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';

class CreateAccountButton extends HookWidget {
  final String title;
  final VoidCallback onTap;
  final VoidCallback? onDoubleTap;

  const CreateAccountButton({
    required this.title,
    required this.onTap,
    this.onDoubleTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isHover = useState(false);

    return InkWell(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onHover: (value) {
        isHover.value = value;
      },
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.ease,
          margin: const EdgeInsets.all(10),
          height: 56,
          decoration: BoxDecoration(
            borderRadius: borderRadius8,
            color: isHover.value
                ? const Color(AppColors.bgDarkGrayHover)
                : const Color(AppColors.bgDarkGray1),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            overflow: TextOverflow.fade,
            style: appTheme.textTheme.title2.bold.onDark1,
          )),
    );
  }
}
