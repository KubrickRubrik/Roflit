import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';

class ContentSectionEmptyObjects extends StatelessWidget {
  const ContentSectionEmptyObjects();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'СПИСОК\r\nОБЪЕКТОВ\r\nПУСТ',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(AppColors.onDarkText),
        ),
      ),
    );
  }
}
