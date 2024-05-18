import 'package:flutter/material.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/core/page_dto/storage_page_dto.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';

class MainMenuAccountStoragesCloudPage extends StatelessWidget {
  final StoragePageDto storagePageDto;

  const MainMenuAccountStoragesCloudPage({
    required this.storagePageDto,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(AppColors.bgDarkBlue1),
      borderRadius: borderRadius12,
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
              'Хранилище'.translate,
              overflow: TextOverflow.fade,
              style: appTheme.textTheme.title2.bold.onDark1,
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}
