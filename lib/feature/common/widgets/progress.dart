import 'package:flutter/material.dart';

class AppBarProgress extends StatelessWidget {
  const AppBarProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
    // return SizedBox(
    //   height: 15,
    //   child: Selector<ProgressModel, int>(
    //     selector: (_, Model) => Model.listDot.length,
    //     builder: (_, length, __) {
    //       return Stack(
    //         children: List.generate(length, (index) {
    //           return Selector<ProgressModel, bool>(
    //             selector: (_, Model) => Model.listDot[index].moveToEnd,
    //             builder: (_, moveToEnd, __) {
    //               return Positioned(
    //                   top: 0,
    //                   bottom: 0,
    //                   left: -10,
    //                   right: -10,
    //                   child: AnimatedContainer(
    //                     duration: Duration(milliseconds: context.read<ProgressModel>().listDot[index].duration),
    //                     curve: const Cubic(0.45, 0.8, 0.55, 0.1),
    //                     alignment: (!moveToEnd) ? Alignment.centerLeft : Alignment.centerRight,
    //                     child: Container(
    //                       height: 6,
    //                       width: 6,
    //                       decoration: BoxDecoration(
    //                         color: const Color(0xFFffffff),
    //                         borderRadius: BorderRadius.circular(10),
    //                       ),
    //                     ),
    //                   ));
    //             },
    //           );
    //         }),
    //       );
    //     },
    //   ),
    // );
  }
}
