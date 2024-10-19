import 'dart:ui';

final class Constants {
  static const minimumSizeWindow = Size(1280, 900);
  static const maximumSizeWindow = Size(1280, 900);

  static const supportedLocalesPath = 'assets/translations';
  static const fallackLocale = Locale('ru');
  static const supportedLocales = [
    Locale('en', 'US'),
    Locale('ru', 'RU'),
  ];

  static const maxFileLength = 10485760;
}
