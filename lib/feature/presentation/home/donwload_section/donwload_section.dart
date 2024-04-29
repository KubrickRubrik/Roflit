import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';

import 'widgets/cloud_button.dart';
import 'widgets/config_button.dart';
import 'widgets/empty_section.dart';

class DonwloadSection extends StatelessWidget {
  const DonwloadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: 72,
          // color: Colors.orange,
          alignment: Alignment.bottomRight,
          child: const DonwloadSectionCloudButton(),
        ),
        const Flexible(
          flex: 8,
          child: DonwloadSectionEmpty(),
        ),
        Container(
          height: 72,
          // color: Colors.orange,
          alignment: Alignment.topRight,
          child: const DonwloadSectionConfigButton(),
        ),
      ],
    );
  }
}
