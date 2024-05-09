import 'package:flutter/material.dart';

extension EContext on BuildContext {
  // To simplify obtaining honey parameters
  MediaQueryData get media => MediaQuery.of(this);
  // To simplify obtaining honey parameters
  ThemeData get theme => Theme.of(this);
}
