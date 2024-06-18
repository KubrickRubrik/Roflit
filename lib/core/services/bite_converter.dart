final class ByteConverter {
  int _bytes = 0;
  int _bits = 0;

  ByteConverter(this._bytes) {
    _bits = (_bytes * 8.0).ceil();
  }

  ByteConverter.withBits(this._bits) {
    _bytes = _bits ~/ 8;
  }

  /// Method to round the double value to the given precision.
  ///  returns the same value if the precision is greater
  /// than the length of the value.
  double _withPrecision(double value, {int precision = 2}) {
    final valString = '$value';
    // ignore: parameter_assignments
    final endingIndex = valString.indexOf('.') + (precision++);

    if (valString.length < endingIndex) {
      return value;
    }

    return double.tryParse(valString.substring(0, endingIndex)) ?? value;
  }

  double get kiloBytes => _bytes / 1024;

  double get megaBytes => _bytes / 1048576;

  double get gigaBytes => _bytes / 1073741824;

  factory ByteConverter.fromBytes(int value) => ByteConverter(value);

  ByteConverter add(ByteConverter value) => this + value;

  ByteConverter subtract(ByteConverter value) => this - value;

  ByteConverter addBytes(int value) => this + ByteConverter.fromBytes(value);

  ByteConverter operator +(ByteConverter instance) => ByteConverter(instance._bytes + _bytes);

  ByteConverter operator -(ByteConverter instance) => ByteConverter(_bytes - instance._bytes);

  bool operator >(ByteConverter instance) => _bits > instance._bits;

  bool operator <(ByteConverter instance) => _bits < instance._bits;

  bool operator <=(ByteConverter instance) => _bits <= instance._bits;

  bool operator >=(ByteConverter instance) => _bits >= instance._bits;

  static int compare(ByteConverter a, ByteConverter b) => a._bits.compareTo(b._bits);

  static bool isEqual(ByteConverter a, ByteConverter b) => a.isEqualTo(b);

  int compareTo(ByteConverter instance) => compare(this, instance);

  bool isEqualTo(ByteConverter instance) => _bits == instance._bits;

  String toHumanReadable(SizeUnit unit, {int precision = 2}) {
    var value = _withPrecision(gigaBytes, precision: precision);
    if (value != 0) {
      return '$value GB';
    }
    value = _withPrecision(megaBytes, precision: precision);
    if (value != 0) {
      return '$value MB';
    }
    value = _withPrecision(kiloBytes, precision: precision);
    if (value != 0) {
      return '$value Kb';
    }
    return '';
  }
}

enum SizeUnit {
  gB,
  mB,
  kB,
}
