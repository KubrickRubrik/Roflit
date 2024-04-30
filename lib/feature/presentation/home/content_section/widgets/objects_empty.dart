import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/text.dart';

class ContentSectionEmptyObjects extends StatelessWidget {
  const ContentSectionEmptyObjects();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'СПИСОК\r\nОБЪЕКТОВ\r\nПУСТ',
        textAlign: TextAlign.center,
        style: appTheme.textTheme.title3.bold.onLight1,
      ),
    );
  }
}
