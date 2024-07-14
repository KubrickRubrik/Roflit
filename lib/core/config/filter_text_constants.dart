import 'package:flutter/services.dart';

abstract final class FilterTextConstant {
  static final nameBucket = FilteringTextInputFormatter.allow(RegExp('[0-9a-z-]'));
  static final nameObject = FilteringTextInputFormatter.allow(RegExp('[0-9a-z-]'));
}
  //  filterInputFormatters: [
  //    FilterTextConstant.nameObject,
  //  ],