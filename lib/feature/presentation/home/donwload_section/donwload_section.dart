import 'package:flutter/material.dart';

import 'widgets/objects_list.dart';
import 'widgets/cloud_button.dart';
import 'widgets/config_button.dart';
import 'widgets/empty_section.dart';
import 'widgets/objects_hover.dart';

class DonwloadSection extends StatelessWidget {
  const DonwloadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: 64,
          alignment: Alignment.bottomRight,
          child: const DonwloadSectionCloudButton(),
        ),
        Flexible(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.only(right: 2, top: 14, bottom: 14),
            child: DonwloadSectionHoverObjects(
              child: Align(
                alignment: Alignment.centerRight,
                child: DonwloadSectionObjectsList(),
              ),
            ),
          ),
          // DonwloadSectionEmpty(),
        ),
        Container(
          height: 64,
          alignment: Alignment.topRight,
          child: const DonwloadSectionConfigButton(),
        ),
      ],
    );
  }
}
