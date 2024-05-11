import 'package:flutter/material.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';

class ContentSectionMainMenu extends StatelessWidget {
  const ContentSectionMainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(AppColors.bgDarkBlue1).withOpacity(0.4),
        ),
        alignment: Alignment.center,
        child: Container(
          height: 500,
          width: 300,
          decoration: BoxDecoration(
            color: const Color(AppColors.bgDarkBlue1),
            borderRadius: borderRadius12,
          ),
          child: Column(
            children: [
              Container(
                height: 56,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 2,
                      color: Color(AppColors.borderLineOnLight0),
                    ),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Профили'.translate,
                  overflow: TextOverflow.fade,
                  style: appTheme.textTheme.title2.bold.onDark1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
