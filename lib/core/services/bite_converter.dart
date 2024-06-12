final class ByteConverter {
  double _bytes = 0.0;
  int _bits = 0;

  ByteConverter(this._bytes) {
    _bits = (_bytes * 8.0).ceil();
  }

  ByteConverter.withBits(this._bits) {
    _bytes = _bits / 8;
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

  double get megaBytes => _bytes / 1000000;

  double get gigaBytes => _bytes / 1000000000;

  factory ByteConverter.fromBytes(double value) => ByteConverter(value);

  ByteConverter add(ByteConverter value) => this + value;

  ByteConverter subtract(ByteConverter value) => this - value;

  ByteConverter addBytes(double value) => this + ByteConverter.fromBytes(value);

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
    switch (unit) {
      case SizeUnit.gB:
        return '${_withPrecision(gigaBytes, precision: precision)} GB';
      case SizeUnit.mB:
        return '${_withPrecision(megaBytes, precision: precision)} MB';
    }
  }
}

enum SizeUnit {
  gB,
  mB,
}
