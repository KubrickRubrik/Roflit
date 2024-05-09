import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/text.dart';

class ContentSectionEmptyBuckets extends StatelessWidget {
  const ContentSectionEmptyBuckets();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'СПИСОК\r\nБАКЕТОВ\r\nПУСТ',
        textAlign: TextAlign.center,
        style: appTheme.textTheme.title3.bold.onLight1,
      ),
    );
  }
}
