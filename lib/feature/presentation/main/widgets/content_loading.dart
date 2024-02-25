import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';

import 'item_file.dart';

class ContentLoading extends StatelessWidget {
  const ContentLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Очередь на \n загрузку файлов',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: const Color(AppColors.grayText),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              clipBehavior: Clip.hardEdge,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: 20,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8);
                },
                itemBuilder: (context, index) {
                  return ItemFile(index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
