import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:roflit/feature/common/widgets/lines.dart';

import 'widgets/buckets_empty.dart';
import 'widgets/buckets_hover.dart';
import 'widgets/buckets_list.dart';
import 'widgets/navigation_bottom_bar.dart';
import 'widgets/navigation_header_bar.dart';
import 'widgets/objects_empty.dart';
import 'widgets/objects_hover.dart';
import 'widgets/objects_list.dart';

class ContentSection extends StatelessWidget {
  const ContentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        const SizedBox(
          height: 64,
          child: ContentSectionNavigationHeaderBar(),
        ),
        Lines.horMid(),
        Flexible(
          flex: 8,
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(2, 8, 0, 8),
                  child: ContentSectionHoverObjects(
                    child: ContentSectionBucketsList(),
                  ),
                ),
              ),
              Lines.verticalContent(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 2, 8),
                  child: ContentSectionHoverObjects(
                    child: ContentSectionObjectsList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Lines.horMid(),
        const SizedBox(
          height: 64,
          child: ContentSectionNavigationBottomBar(),
        ),
      ],
    );
  }
}
