import 'package:flutter/material.dart';

class HomeContentObjectsLoading extends StatelessWidget {
  const HomeContentObjectsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}
