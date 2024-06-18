extension EString on String {
  String get translate => this;

  DateTime? get toDateTime {
    final date = DateTime.tryParse(this);
    if (date == null) return null;
    return date;
  }

  String get objectName {
    final title = split('/');
    if (title.last.isNotEmpty) return title.last;
    return title[title.length - 2];
  }
}
