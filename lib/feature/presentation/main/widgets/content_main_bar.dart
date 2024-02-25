import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';

import 'decoration_section.dart';

class ContentMainBar extends StatelessWidget {
  const ContentMainBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecorationSection(
          bottom: WrapDecorationSectionStyle(
            thickness: 1,
            padding: const WrapDecorationSectionPadding(start: 0, end: 0),
            dots: const WrapDecorationSectionDot(start: true, end: true, radius: 2),
          ),
          child: const SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PC | Локальный репозиторй/каталог',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(AppColors.grayText),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Фильтр файлов',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(AppColors.grayText),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'YC | Удаленный репозиторй/каталог/бакеты',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(AppColors.grayText),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Фильтр файлов',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(AppColors.grayText),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
