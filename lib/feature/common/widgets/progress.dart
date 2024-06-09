import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:roflit/core/utils/await.dart';
import 'package:roflit/core/utils/hooks.dart';

class AppBarProgress extends HookWidget {
  const AppBarProgress({super.key});
  final numberDots = 10;
  final timeForMove = 2;
  final gapMilliseconds = 150;
  @override
  Widget build(BuildContext context) {
    final listUpdate = useState(false);
    final listDot = useMemoized(() {
      return List.generate(
        numberDots,
        (index) => _Dot(
          index: index,
          moveToEnd: false,
          isStart: true,
          timeForMove: timeForMove,
        ),
      );
    });

    final move = useMemoized(() {
      return () {
        for (var i = 0; i < listDot.length; i++) {
          Await.millisecond(i * gapMilliseconds).then((value) {
            listDot[i]
              ..moveToEnd = !listDot[i].moveToEnd
              ..isStart = false;
            if (context.mounted) listUpdate.value = !listUpdate.value;
          });
        }
      };
    });

    useInitState(
      initState: () {
        final timer = Timer.periodic(Duration(seconds: timeForMove), (timer) => move());
        return timer.cancel;
      },
      onBuild: move,
    );

    return SizedBox(
      height: 15,
      child: Stack(
        children: listDot.map((e) {
          return _DotWidget(
            index: e.index,
            isStart: e.isStart,
            moveToEndKey: e.moveToEnd,
            timeForMove: timeForMove,
          );
        }).toList(),
      ),
    );
  }
}

class _DotWidget extends HookWidget {
  const _DotWidget({
    required this.index,
    required this.moveToEndKey,
    required this.timeForMove,
    required this.isStart,
  });
  final bool moveToEndKey;
  final bool isStart;
  final int index;
  final int timeForMove;

  @override
  Widget build(BuildContext context) {
    final moveToEnd = useState(false);

    useInitState(
      onBuild: () {
        if (!isStart) {
          moveToEnd.value = !moveToEnd.value;
        }
      },
      keys: [moveToEndKey],
    );
    return Positioned(
        top: 0,
        bottom: 0,
        left: -10,
        right: -10,
        child: AnimatedContainer(
          duration: Duration(seconds: timeForMove),
          curve: const Cubic(0.45, 0.8, 0.55, 0.1),
          alignment: (!moveToEnd.value) ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFffffff),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ));
  }
}

final class _Dot {
  final int index;
  bool moveToEnd;
  bool isStart;
  final int timeForMove;
  _Dot({
    required this.index,
    required this.moveToEnd,
    required this.timeForMove,
    required this.isStart,
  });
}


// Selector<ProgressModel, int>(
//         selector: (_, Model) => Model.listDot.length,
//         builder: (_, length, __) {
//           return Stack(
//             children: List.generate(length, (index) {
//               return Selector<ProgressModel, bool>(
//                 selector: (_, Model) => Model.listDot[index].moveToEnd,
//                 builder: (_, moveToEnd, __) {
//                   return Positioned(
//                       top: 0,
//                       bottom: 0,
//                       left: -10,
//                       right: -10,
//                       child: AnimatedContainer(
//                         duration: Duration(milliseconds: context.read<ProgressModel>().listDot[index].duration),
//                         curve: const Cubic(0.45, 0.8, 0.55, 0.1),
//                         alignment: (!moveToEnd) ? Alignment.centerLeft : Alignment.centerRight,
//                         child: Container(
//                           height: 6,
//                           width: 6,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFffffff),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ));
//                 },
//               );
//             }),
//           );
//         },
//       )