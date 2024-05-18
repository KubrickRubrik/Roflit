import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roflit/feature/common/themes/colors.dart';

/// [letterSpacing1] provides -0.16px of letterSpacing, equals to -0.01em
const letterSpacing1 = -0.16;

/// [letterSpacing2] provides 0.16px of letterSpacing, equals to 0.01em
const letterSpacing2 = 0.16;

/// [letterSpacing3] provides 0.08px of letterSpacing, equals to 0.005em
const letterSpacing3 = 0.08;

/// [letterSpacing4] provides 0.08px of letterSpacing, equals to 0.03em
const letterSpacing4 = 0.48;

ThemeData appTheme = ThemeData(
  // fontFamily: inter,
  useMaterial3: false,
  brightness: Brightness.light,
  // scaffoldBackgroundColor: bgLight1,
  // colorScheme: ColorScheme.fromSwatch().copyWith(secondary: bgPrimary1.withOpacity(0.005)),
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
  // textButtonTheme: TextButtonThemeData(
  //   style: ButtonStyle(
  //     fixedSize: MaterialStateProperty.all<Size>(
  //       Size(double.infinity, w24),
  //     ),
  //     iconSize: MaterialStateProperty.all<double>(
  //       w24,
  //     ),
  //   ),
  // ),
);

extension TextStyleFontWeight on TextStyle {
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);

  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
}

extension TextStyleColor on TextStyle {
  TextStyle get onDark1 => copyWith(color: const Color(AppColors.textOnDark1));

  TextStyle get onDark2 => copyWith(color: const Color(AppColors.textOnDark2));

  // TextStyle get onDark3 => copyWith(color: const Color(AppColors.textOnDark3));

  // TextStyle get primary => copyWith(color: const Color(AppColors.textPrimary));

  TextStyle get onLight1 => copyWith(color: const Color(AppColors.textOnLight1));

  // TextStyle get onLight2 => copyWith(color: const Color(AppColors.textOnLight2));

  // TextStyle get onLight3 => copyWith(color: const Color(AppColors.textOnLight3));

  TextStyle get secondary0 => copyWith(color: const Color(AppColors.textSecondary));

  // TextStyle get secondary1 => copyWith(color: const Color(AppColors.textSecondary));

  // TextStyle get secondary2 => copyWith(color: const Color(AppColors.textSecondary2));
}

extension CustomTextTheme on TextTheme {
  TextStyle get display1 {
    return const TextStyle(
      fontSize: 28.0,
      letterSpacing: -0.03 * 28,
      fontWeight: FontWeight.bold,
      color: Color(AppColors.textOnLight1),
      // fontFamily: montserrat,
    );
  }

  TextStyle get title1 {
    return const TextStyle(
      fontSize: 18.0,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
      color: Color(AppColors.textOnLight1),
      // fontFamily: montserrat,
    );
  }

  TextStyle get title2 {
    return const TextStyle(
      fontSize: 16.0,
      letterSpacing: 0.005 * 14,
      fontWeight: FontWeight.w400,
      color: Color(AppColors.textOnLight1),
      // fontFamily: montserrat,
    );
  }

  TextStyle get title3 {
    return const TextStyle(
      fontSize: 14.0,
      letterSpacing: 0.005 * 14,
      fontWeight: FontWeight.w400,
      color: Color(AppColors.textOnLight1),
      // fontFamily: montserrat,
    );
  }

  TextStyle get subtitle {
    return const TextStyle(
      fontSize: 14.0,
      letterSpacing: 0.005 * 14,
      fontWeight: FontWeight.w400,
      color: Color(AppColors.textOnLight1),
      // fontFamily: inter,
    );
  }

  TextStyle get body1 {
    return const TextStyle(
      fontSize: 18.0,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
      color: Color(AppColors.textOnLight1),
      // fontFamily: inter,
    );
  }

  TextStyle get body2 {
    return const TextStyle(
      fontSize: 14.0,
      letterSpacing: 0.005 * 14,
      fontWeight: FontWeight.w400,
      color: Color(AppColors.textOnLight1),
      // fontFamily: inter,
    );
  }

  TextStyle get control1 {
    return const TextStyle(
      fontSize: 18.0,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
      color: Color(AppColors.textOnLight1),
      // fontFamily: montserrat,
    );
  }

  TextStyle get control2 {
    return const TextStyle(
      fontSize: 14.0,
      letterSpacing: 0.005 * 14,
      fontWeight: FontWeight.w400,
      color: Color(AppColors.textOnLight1),
      // fontFamily: montserrat,
    );
  }

  TextStyle get caption1 {
    return const TextStyle(
      fontSize: 14.0,
      letterSpacing: 0.005 * 14,
      fontWeight: FontWeight.w400,
      color: Color(AppColors.textOnLight1),
      // fontFamily: inter,
    );
  }

  TextStyle get caption2 {
    return const TextStyle(
      fontSize: 12.0,
      letterSpacing: 0.01 * 12,
      fontWeight: FontWeight.w400,
      color: Color(AppColors.textOnLight1),
      // fontFamily: inter,
    );
  }

  TextStyle get caption3 {
    return const TextStyle(
      fontSize: 10.0,
      letterSpacing: 0.01 * 12,
      fontWeight: FontWeight.w400,
      color: Color(AppColors.textOnLight1),
      // fontFamily: inter,
    );
  }
}
