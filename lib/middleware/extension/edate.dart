// import 'package:flutter/material.dart';

extension EDateTime on DateTime {
  String get yyyyMMdd {
    return '$year${month.toString().padLeft(2, '0')}${day.toString().padLeft(2, '0')}';
  }

  // String get inHeader {
  //   return '${formatWeekday(weekday)},'
  //       ' ${day.toString().padLeft(2, '0')} ${formatMonth(month)} $year '
  //       '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:'
  //       '${second.toString().padLeft(2, '0')} GMT';
  // }

  String get xAmzDate {
    final a =
        '$year${month.toString().padLeft(2, '0')}${day.toString().padLeft(2, '0')}T${hour.toString().padLeft(2, '0')}${minute.toString().padLeft(2, '0')}'
        '${second.toString().padLeft(2, '0')}Z';
    return a;
  }

  String formatWeekday(int weekday) {
    return daysOfWeek[weekday - 1]; // В Dart индексы дней недели начинаются с 1, а не с 0
  }

  String formatMonth(int month) {
    return months[month - 1]; // В Dart индексы месяцев начинаются с 1, а не с 0
  }

  static const daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
}
