import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:roflit/feature/common/themes/colors.dart';

class ActionMenuButton extends HookWidget {
  final VoidCallback? onTap;

  const ActionMenuButton({
    this.onTap,
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
            height: hoverState.value ? 16 : 10,
            width: hoverState.value ? 16 : 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(AppColors.borderLineOnDart0),
              ),
            ),
            alignment: Alignment.center,
            child: Container(
              height: hoverState.value ? 6 : 10,
              width: hoverState.value ? 6 : 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(AppColors.bgLight0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
