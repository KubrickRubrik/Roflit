import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:roflit/feature/common/widgets/lines.dart';

import '../../menu/menu.dart';
import 'widgets/buckets_list.dart';
import 'widgets/navigation_bottom_bar.dart';
import 'widgets/navigation_header_bar.dart';
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
        const Lines.horMid(),
        Flexible(
          flex: 8,
          child: Stack(
            children: [
              Positioned.fill(
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
                    const Lines.verticalContent(),
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
              const MainMenu(),
            ],
          ),
        ),
        const Lines.horMid(),
        const SizedBox(
          height: 64,
          child: ContentSectionNavigationBottomBar(),
        ),
      ],
    );
  }
}
