import 'package:flutter/material.dart';

import 'tokens.dart';

/// Font families bundled as assets (see ADR 0002 for the heading font choice).
abstract final class AppFonts {
  static const String body = 'Manrope';
  static const String heading = 'RobotoCondensed';
}

abstract final class AppTypography {
  static TextTheme textTheme({required Color color, Color? mutedColor}) {
    TextStyle heading(double size, FontWeight weight) => TextStyle(
      fontFamily: AppFonts.heading,
      fontSize: size,
      fontWeight: weight,
      height: 1.05,
      color: color,
    );
    TextStyle body(double size, FontWeight weight, {Color? c}) => TextStyle(
      fontFamily: AppFonts.body,
      fontSize: size,
      fontWeight: weight,
      height: 1.5,
      color: c ?? color,
    );

    return TextTheme(
      displayLarge: heading(44, FontWeight.w700),
      headlineLarge: heading(34, FontWeight.w700),
      headlineMedium: heading(30, FontWeight.w700),
      headlineSmall: heading(24, FontWeight.w700),
      titleLarge: heading(22, FontWeight.w600),
      titleMedium: body(17, FontWeight.w800),
      titleSmall: body(15, FontWeight.w700),
      bodyLarge: body(16, FontWeight.w400),
      bodyMedium: body(14, FontWeight.w400),
      bodySmall: body(12, FontWeight.w400, c: mutedColor ?? AppColors.inkMuted),
      labelLarge: body(17, FontWeight.w800),
      labelMedium: body(14, FontWeight.w700),
      labelSmall: body(12, FontWeight.w700),
    );
  }
}
