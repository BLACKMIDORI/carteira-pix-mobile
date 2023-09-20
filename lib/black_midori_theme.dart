import 'package:flutter/material.dart';

/// Brand Color
const brandColor = Color(0xFF00a770);

const darkpurple = Color(0xFF493b6e);
const purple = Color(0xFF8c74d2);
const blue = Color(0xFF005588);
const lightblue = Color(0xFF0084d5);
const black = Color(0xFF1b1c1e);

const colorSwatch = MaterialColor(0xFF00a770, {
  50: Color(0xFFaeffe5),
  100: Color(0xFF7effd5),
  200: Color(0xFF4dffc4),
  300: Color(0xFF23ffb3),
  400: Color(0xFF10e69b),
  500: brandColor,
  600: Color(0xFF008056),
  700: Color(0xFF004e32),
  800: Color(0xFF001c0f),
  900: Color(0xFF001c0f),
});

/// Extension for Black Midori Theme
extension BlackMidoriTheme on ThemeData {
  /// Return a darkmode theme
  static ThemeData darkMode() {
    final defaultDarkTheme = ThemeData.dark();

    return ThemeData(
      fontFamily: "RobotoMono",
      scaffoldBackgroundColor: black,
      textTheme: defaultDarkTheme.textTheme,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: colorSwatch)
          .copyWith(background: defaultDarkTheme.colorScheme.background),
    );
  }
}
