import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';

class ContentSectionNavigationBottomBar extends StatelessWidget {
  const ContentSectionNavigationBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContentSectionSelectFilesButton();
  }
}

class ContentSectionSelectFilesButton extends StatefulWidget {
  const ContentSectionSelectFilesButton({super.key});

  @override
  State<ContentSectionSelectFilesButton> createState() => _ContentSectionSelectFilesButtonState();
}

class _ContentSectionSelectFilesButtonState extends State<ContentSectionSelectFilesButton> {
  bool isHover = false;

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onHover: (value) {
        isHover = value;
        setState(() {});
      },
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.ease,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 4),
          height: 48,
          decoration: BoxDecoration(
            color: isHover
                ? const Color(AppColors.bgDarkGrayHover)
                : const Color(AppColors.bgDarkGray1),
            borderRadius: borderRadius8,
          ),
          alignment: Alignment.center,
          child: Text(
            'Выбрать файлы для загрузки',
            style: appTheme.textTheme.title2.bold.onDark2,
          ),
        ),
      ),
    );
  }
}
