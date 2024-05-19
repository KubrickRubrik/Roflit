import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:roflit/feature/common/themes/colors.dart';

class ActionMenuButton extends HookWidget {
  final VoidCallback? onTap;
  final Color color;

  const ActionMenuButton({
    this.onTap,
    this.color = const Color(AppColors.bgLight0),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final hoverState = useState(false);

    return InkWell(
      onTap: onTap,
      onHover: (value) {
        hoverState.value = value;
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: hoverState.value ? 14 : 8,
            width: hoverState.value ? 14 : 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color),
            ),
            alignment: Alignment.center,
            child: Container(
              height: hoverState.value ? 4 : 8,
              width: hoverState.value ? 4 : 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
