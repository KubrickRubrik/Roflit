import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:roflit/feature/common/themes/background.dart';
import 'package:roflit/middleware/zip_utils.dart';

class MainBackgaround extends HookWidget {
  const MainBackgaround({
    required this.child,
    super.key,
  });
  final fones = BackgroundColors.listFones;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final activeIndex = useState(0);

    useInitState(initState: () {
      final timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        activeIndex.value = Random().nextInt(fones.length);
      });

      return timer.cancel;
    });

    return AnimatedContainer(
      duration: const Duration(seconds: 3),
      curve: Curves.ease,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          tileMode: TileMode.clamp,
          colors: fones[activeIndex.value].color.map(Color.new).toList(),
        ),
      ),
      child: child,
    );
  }
}
