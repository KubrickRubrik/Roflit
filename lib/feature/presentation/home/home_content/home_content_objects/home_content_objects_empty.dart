import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/text.dart';

class HomeContentObjectsEmpty extends StatelessWidget {
  const HomeContentObjectsEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'СПИСОК\r\nОБЪЕКТОВ\r\nПУСТ',
        textAlign: TextAlign.center,
        style: appTheme.textTheme.title3.bold.onDark1,
      ),
    );
  }
}
