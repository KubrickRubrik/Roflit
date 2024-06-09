extension EString on String {
  String get translate => this;

  DateTime? get toDateTime {
    final date = DateTime.tryParse(this);
    if (date == null) return null;
    return date;
  }
}
