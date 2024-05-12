import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';

class MainMenuItemButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const MainMenuItemButton({
    required this.child,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 64,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: Color(AppColors.borderLineOnLight0),
            ),
          ),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
