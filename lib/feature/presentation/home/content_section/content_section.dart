import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/widgets/lines.dart';

import 'widgets/buckets_empty_content.dart';
import 'widgets/buckets_hover_content.dart';
import 'widgets/object_empty_content.dart';
import 'widgets/object_hover_content.dart';

class ContentSection extends StatelessWidget {
  const ContentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Container(
          height: 72,
        ),
        Lines.horMid(),
        Flexible(
          flex: 8,
          child: Flex(
            direction: Axis.horizontal,
            children: [
              const Expanded(
                child: ContentSectionHoverBuckets(
                  child: ContentSectionEmptyBuckets(),
                ),
              ),
              Lines.verticalContent(),
              const Expanded(
                child: ContentSectionHoverObjects(
                  child: ContentSectionEmptyObjects(),
                ),
              ),
            ],
          ),
        ),
        Lines.horMid(),
        Container(
          height: 72,
        ),
      ],
    );
  }
}
