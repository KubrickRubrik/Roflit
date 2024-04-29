import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';

class ContentSectionEmptyBuckets extends StatelessWidget {
  const ContentSectionEmptyBuckets();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'СПИСОК\r\nБАКЕТОВ\r\nПУСТ',
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
