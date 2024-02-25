extension EDateTime on DateTime {
  String get yyyyMMdd {
    return '$year${month.toString().padLeft(2, '0')}${day.toString().padLeft(2, '0')}';
  }

  String get inHeader {
    final now = toUtc();

    return '${formatWeekday(now.weekday)},'
        ' ${now.day.toString().padLeft(2, '0')} ${formatMonth(now.month)} ${now.year} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')} GMT';
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
