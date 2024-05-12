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
    final isHover = useState(false);

    return InkWell(
      onTap: onTap,
      onHover: (value) {
        isHover.value = value;
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: isHover.value ? 18 : 12,
            width: isHover.value ? 18 : 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(AppColors.borderLineOnDart0),
              ),
            ),
            alignment: Alignment.center,
            child: Container(
              height: isHover.value ? 8 : 12,
              width: isHover.value ? 8 : 12,
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
