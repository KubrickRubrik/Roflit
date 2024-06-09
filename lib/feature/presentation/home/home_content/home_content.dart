import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:roflit/feature/common/widgets/lines.dart';
import 'package:roflit/feature/presentation/menu/menu.dart';

import 'home_content_buckets.dart';
import 'home_content_objects.dart';
import 'widgets/home_content_buckets_hover.dart';
import 'widgets/home_content_objects_hover.dart';
import 'widgets/navigation_bottom_bar.dart';
import 'widgets/navigation_header_bar.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Flex(
      direction: Axis.vertical,
      children: [
        SizedBox(
          height: 64,
          child: SectionContentNavigationHeaderBar(),
        ),
        Lines.horMid(),
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
                        padding: EdgeInsets.fromLTRB(2, 8, 0, 8),
                        child: HomeContentBucketsHover(
                          child: HomeContentBuckets(),
                        ),
                      ),
                    ),
                    Lines.verticalContent(),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 2, 8),
                        child: HomeContentObjectsHover(
                          child: HomeContentObjects(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              MainMenu(),
            ],
          ),
        ),
        Lines.horMid(),
        SizedBox(
          height: 64,
          child: SectionContentNavigationBottomBar(),
        ),
      ],
    );
  }
}
