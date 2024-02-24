import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:roflit/feature/presentation/main/bloc/notifier.dart';
import 'package:roflit/feature/presentation/main/test/notifier.dart';

import 'widgets/background.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocMain = ref.watch(mainNotifierProvider.notifier);
    final blocTest = ref.watch(testNotifierProvider.notifier);

    final state = ref.watch(mainNotifierProvider);

    // state.maybeWhen(
    //   loading: () {},
    //   loaded: (counter) {},
    //   orElse: () {},
    // );

    return Scaffold(
      body: MainBackgaround(
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.blueGrey.shade800),
          child: Flex(
            direction: Axis.vertical,
            children: [
              DecorationSection(
                child: Container(
                  height: 100,
                  color: Colors.grey,
                ),
                bottom: DecorationSectionStyle(thickness: 10),
              ),
              Expanded(
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Container(
                      width: 250,
                      color: Colors.blue,
                    ),
                    Expanded(
                      child: DecorationSection(
                        child: Container(
                          color: Colors.orange,
                        ),
                        right: DecorationSectionStyle(thickness: 10, padding: 10),
                        left: DecorationSectionStyle(thickness: 10, padding: 10),
                      ),
                    ),
                    Container(
                      width: 250,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DecorationSection extends StatelessWidget {
  const DecorationSection({
    required this.child,
    super.key,
    this.left,
    this.right,
    this.top,
    this.bottom,
  });
  final DecorationSectionStyle? top;
  final DecorationSectionStyle? left;
  final DecorationSectionStyle? right;
  final DecorationSectionStyle? bottom;
  final Widget child;

  Widget horizontalEdge({
    required double padding,
    required double thickness,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: padding),
      height: thickness,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }

  Widget verticalEdge({
    required double padding,
    required double thickness,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: padding),
      width: thickness,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (top != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 10,
            child: horizontalEdge(
              padding: top!.padding,
              thickness: top!.thickness,
              color: top!.color,
            ),
          ),
        if (left != null)
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: verticalEdge(
              padding: left!.padding,
              thickness: left!.thickness,
              color: left!.color,
            ),
          ),
        if (right != null)
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: verticalEdge(
              padding: right!.padding,
              thickness: right!.thickness,
              color: right!.color,
            ),
          ),
        if (bottom != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: horizontalEdge(
              padding: bottom!.padding,
              thickness: bottom!.thickness,
              color: bottom!.color,
            ),
          ),
      ],
    );

    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.stretch,
    //   children: [
    //     if (top != null)
    //       horizontalEdge(
    //         padding: top!.padding,
    //         thickness: top!.thickness,
    //         color: top!.color,
    //       ),
    //     IntrinsicHeight(
    //       child: Row(
    //         // direction: Axis.horizontal,
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children: [
    //           if (left != null)
    //             verticalEdge(
    //               padding: left!.padding,
    //               thickness: left!.thickness,
    //               color: left!.color,
    //             ),
    //           Expanded(child: child),
    //           if (right != null)
    //             verticalEdge(
    //               padding: right!.padding,
    //               thickness: right!.thickness,
    //               color: right!.color,
    //             ),
    //         ],
    //       ),
    //     ),
    //     if (bottom != null)
    //       horizontalEdge(
    //         padding: bottom!.padding,
    //         thickness: bottom!.thickness,
    //         color: bottom!.color,
    //       ),
    //   ],
    // );
  }
}

final class DecorationSectionStyle {
  final double padding;
  final double thickness;
  final Color color;

  DecorationSectionStyle({
    this.padding = 250,
    this.thickness = 1,
    this.color = const Color(0xFFcccccc),
  });
}


// Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton.filled(
//                           onPressed: blocMain.actionMinus,
//                           icon: const Icon(Icons.exposure_minus_1),
//                         ),
//                         const SizedBox(width: 16),
//                         IconButton.filled(
//                           onPressed: blocMain.actionPlus,
//                           icon: const Icon(Icons.plus_one),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Consumer(
//                       builder: (context, ref, child) {
//                         final state = ref.watch(mainNotifierProvider);
//                         return Text(
//                           '${state.data?.counter}',
//                           style: const TextStyle(fontSize: 20),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 64),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton.filled(
//                           onPressed: blocTest.actionMinus,
//                           icon: const Icon(Icons.exposure_minus_1),
//                         ),
//                         const SizedBox(width: 16),
//                         IconButton.filled(
//                           onPressed: blocTest.actionPlus,
//                           icon: const Icon(Icons.plus_one),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Consumer(
//                       builder: (context, ref, child) {
//                         final state = ref.watch(testNotifierProvider);
//                         return Text(
//                           '${state.counter}',
//                           style: const TextStyle(fontSize: 20),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               )