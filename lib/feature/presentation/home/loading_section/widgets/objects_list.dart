import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';

class LoadingSectionObjectsList extends StatelessWidget {
  LoadingSectionObjectsList({super.key});
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius8,
      child: RawScrollbar(
        controller: controller,
        scrollbarOrientation: ScrollbarOrientation.left,
        interactive: true,
        minThumbLength: 18,
        thumbVisibility: true,
        mainAxisMargin: 0,
        crossAxisMargin: 0,
        padding: const EdgeInsets.all(0),
        thumbColor: const Color(AppColors.bgDarkGray1),
        radius: const Radius.circular(4),
        trackVisibility: true,
        trackBorderColor: Colors.transparent,
        thickness: 4,
        trackRadius: const Radius.circular(4),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: ListView.builder(
            controller: controller,
            shrinkWrap: true,
            primary: false,
            itemCount: 5,
            padding: const EdgeInsets.only(left: 3, right: 3, bottom: 10),
            itemBuilder: (context, index) {
              return ContenteSectionBucketsListItem(index);
            },
          ),
        ),
      ),
    );
  }
}

class ContenteSectionBucketsListItem extends StatefulWidget {
  final int index;
  const ContenteSectionBucketsListItem(this.index, {super.key});

  @override
  State<ContenteSectionBucketsListItem> createState() => _ContenteSectionBucketsListItemState();
}

class _ContenteSectionBucketsListItemState extends State<ContenteSectionBucketsListItem> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onHover: (value) {
        isHover = value;
        setState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: borderRadius12,
          color: isHover ? const Color(AppColors.bgDarkGray2) : null,
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Container(
              height: 40,
              width: 40,
              margin: const EdgeInsets.only(left: 6),
              decoration: BoxDecoration(
                borderRadius: borderRadius8,
                color: const Color(
                  AppColors.bgDarkGray1,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Название объкта',
                      overflow: TextOverflow.ellipsis,
                      style: appTheme.textTheme.caption1.bold.onDark1,
                    ),
                    Text(
                      '2.5 Mb',
                      overflow: TextOverflow.ellipsis,
                      style: appTheme.textTheme.caption2.onDark1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
