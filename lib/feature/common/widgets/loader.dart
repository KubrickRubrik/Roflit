import 'package:flutter/material.dart';
import 'package:roflit/feature/common/themes/colors.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(AppColors.borderLineOnDart0),
      ),
    );
  }
}
