import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // =========================================================
  // BRAND COLORS
  // =========================================================

  static const Color primary = Color(0xFF6B2D5C); // Royal Plum
  static const Color orange = Color(0xFFFF8A00);
  static const Color yellow = Color(0xFFFFC107);
  static const Color green = Color(0xFF4CAF50);

  // =========================================================
  // LIGHT THEME
  // =========================================================

  static const Color lightBackground = Color(0xFFFFF6E8);
  static const Color lightSurface = Color(0xFFFFFFFF);

  static const Color lightTextPrimary = Color(0xFF2D1F2A);
  static const Color lightTextSecondary = Color(0xFF757575);

  // =========================================================
  // DARK THEME
  // =========================================================

  static const Color darkBackground = Color(0xFF1E1E1E);
  static const Color darkSurface = Color(0xFF2A2A2A);

  // Light purple for dark backgrounds.
  // This gives much better contrast than primary Royal Plum.
  static const Color darkPrimary = Color(0xFFD9A6CF);

  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFBDBDBD);

  // =========================================================
  // TEXT COLORS
  // =========================================================

  static const Color textPrimary = Color(0xFF2D1F2A);
  static const Color textSecondary = Color(0xFF757575);

  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFBDBDBD);

  // =========================================================
  // COMMON COLORS
  // =========================================================

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // =========================================================
  // STATUS COLORS
  // =========================================================

  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFFFC107);

  // =========================================================
  // OTHER UI COLORS
  // =========================================================

  static const Color divider = Color(0xFFE5DED6);
  static const Color disabled = Color(0xFFBDBDBD);

  // Better divider for dark mode
  static const Color darkDivider = Color(0xFF444444);

  // Better card color for dark mode
  static const Color darkCard = Color(0xFF303030);
}