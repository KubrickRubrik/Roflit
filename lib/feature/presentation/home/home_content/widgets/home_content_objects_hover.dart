import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:roflit/core/extension/estring.dart';
import 'package:roflit/feature/common/themes/colors.dart';
import 'package:roflit/feature/common/themes/sizes.dart';
import 'package:roflit/feature/common/themes/text.dart';
import 'package:roflit/feature/presentation/home/home_content/home_content_objects.dart';

class HomeContentObjectsHover extends HookWidget {
  final HomeContentObjects child;
  const HomeContentObjectsHover({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final stateHover = useState(false);
    return InkWell(
      onTap: () {},
      onHover: (value) {
        stateHover.value = value;
      },
      child: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.ease,
              margin: EdgeInsets.only(top: h8, left: h8, bottom: h8),
              decoration: BoxDecoration(
                color: stateHover.value ? const Color(AppColors.bgLightGrayOpacity10) : null,
                borderRadius: borderRadius12,
              ),
              child: child,
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            sizeCurve: Curves.ease,
            crossFadeState:
                (!stateHover.value) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: const SizedBox.shrink(),
            secondChild: const HomeContentObjectSettings(),
          ),
        ],
      ),
    );
  }
}

class HomeContentObjectSettings extends HookWidget {
  const HomeContentObjectSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final stateHover = useState(false);

    return InkWell(
      onTap: () {},
      onHover: (value) {
        stateHover.value = value;
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.ease,
            height: stateHover.value ? 64 : 48,
            margin: EdgeInsets.only(left: h8, bottom: 0),
            decoration: BoxDecoration(
              color: stateHover.value ? const Color(AppColors.bgLightGrayOpacity10) : null,
            ),
            alignment: Alignment.center,
            child: Text(
              'Изменить обьект'.translate,
              style: appTheme.textTheme.title2.onDark1,
            ),
          ),
        ],
      ),
    );
  }
}
