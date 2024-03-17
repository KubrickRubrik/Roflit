extension EDateTime on DateTime {
  String get yyyyMMdd {
    return '$year${month.toString().padLeft(2, '0')}${day.toString().padLeft(2, '0')}';
  }

  String get xAmzDate {
    return '$year${month.toString().padLeft(2, '0')}${day.toString().padLeft(2, '0')}T${hour.toString().padLeft(2, '0')}${minute.toString().padLeft(2, '0')}'
        '${second.toString().padLeft(2, '0')}Z';
  }
}
