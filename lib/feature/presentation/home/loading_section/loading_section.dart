import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';

import 'widgets/account_button.dart';
import 'widgets/config_button.dart';
import 'widgets/empty_section.dart';

class LoadingSection extends StatelessWidget {
  const LoadingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 72,
          alignment: Alignment.bottomLeft,
          child: const LoadingSectionAccountButton(),
        ),
        const Flexible(
          flex: 8,
          child: LoadingSectionEmpty(),
        ),
        Container(
          height: 72,
          alignment: Alignment.topLeft,
          child: const LoadingSectionConfigButton(),
        ),
      ],
    );
  }
}
