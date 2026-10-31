import 'package:flutter/material.dart';

/// Design tokens mirroring SPEC §5. Widgets must use these (or the theme),
/// never literal colors or radii.
abstract final class AppColors {
  static const Color primary = Color(0xFF1F5A3D);
  static const Color pitch = Color(0xFF2F7A4A);
  static const Color gold = Color(0xFFC9A43A);
  static const Color blue = Color(0xFF2E5C8A);
  static const Color cream = Color(0xFFF8F0E3);
  static const Color white = Color(0xFFFFFFFF);
  static const Color terracotta = Color(0xFFB5502C);
  static const Color terracottaDark = Color(0xFF9E4424);
  static const Color ink = Color(0xFF2B2A25);
  static const Color inkMuted = Color(0xFF6B655A);
  static const Color border = Color(0xFFE2D3B8);
  static const Color divider = Color(0xFFEADFCB);
  static const Color onPrimaryMuted = Color(0xFFDCE8DE);
  static const Color avatarTint = Color(0xFFE3ECF5);

  /// Cream overlays used on the green Welcome background.
  static final Color onPrimarySurface = cream.withValues(alpha: 0.08);
  static final Color onPrimaryOutline = cream.withValues(alpha: 0.16);
  static final Color onPrimaryControl = cream.withValues(alpha: 0.3);
  static final Color onPrimaryDot = cream.withValues(alpha: 0.35);
}

abstract final class AppRadii {
  static const double card = 16;
  static const double cardLarge = 22;
  static const double button = 14;
  static const double buttonLarge = 16;
  static const double tile = 16;
  static const double chip = 999;
}

abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double screenEdge = 28;

  /// Minimum touch target.
  static const double minTouch = 44;
}
