import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';

class ObjectItem extends StatefulWidget {
  final int index;
  const ObjectItem(this.index, {super.key});

  @override
  State<ObjectItem> createState() => _ObjectItemState();
}

class _ObjectItemState extends State<ObjectItem> {
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
        height: 64,
        decoration: BoxDecoration(
          borderRadius: borderRadius12,
          color: isHover ? const Color(AppColors.bgDarkGray2) : null,
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Container(
              height: 50,
              width: 50,
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
