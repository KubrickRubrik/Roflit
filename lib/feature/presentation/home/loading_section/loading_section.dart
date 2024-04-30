import 'package:flutter/material.dart';

import 'widgets/account_button.dart';
import 'widgets/config_button.dart';
import 'widgets/objects_empty.dart';
import 'widgets/objects_hover.dart';
import 'widgets/objects_list.dart';

class LoadingSection extends StatelessWidget {
  const LoadingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 64,
          alignment: Alignment.bottomLeft,
          child: const LoadingSectionAccountButton(),
        ),
        Flexible(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.only(left: 2, top: 14, bottom: 14),
            child: LoadingSectionHoverObjects(
              child: Align(
                alignment: Alignment.centerLeft,
                child: LoadingSectionObjectsList(),
              ),
            ),
          ),
          // child: LoadingSectionEmpty(),
        ),
        Container(
          height: 64,
          alignment: Alignment.topLeft,
          child: const LoadingSectionConfigButton(),
        ),
      ],
    );
  }
}
