import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // =========================================================
  // PRIMARY & ACCENT COLORS
  // =========================================================

  static const Color primary = Color(0xFF8A1538);
  static const Color primaryLight = Color(0xFFFAF0F2);
  static const Color primaryDark = Color(0xFF5C0B24);

  // =========================================================
  // CATEGORY & CARD COLORS
  // =========================================================

  static const Color categoryCard = Color(0xFF4A2C1D);
  static const Color categoryCardSecondary = Color(0xFF331C11);

  // =========================================================
  // LIGHT THEME
  // =========================================================

  static const Color background = Color(0xFFF9F8F8);
  static const Color surface = Color(0xFFFFFFFF);

  // =========================================================
  // DARK THEME
  // =========================================================
  //
  // Deep neutral/plum colors.
  // Background and surface are intentionally different.
  // =========================================================

  static const Color darkBackground = Color(0xFF171114);

  static const Color darkSurface = Color(0xFF24191E);

  // Slightly lighter surface for nested cards / containers.
  static const Color darkSurfaceElevated = Color(0xFF2D2026);

  // =========================================================
  // DARK TEXT
  // =========================================================

  // Main text - very clear
  static const Color darkTextPrimary = Color(0xFFFFF7F9);

  // Secondary text - readable but softer
  static const Color darkTextSecondary = Color(0xFFD8C9CE);

  // Hint / disabled text
  static const Color darkTextHint = Color(0xFFA9989F);

  // =========================================================
  // DARK BORDERS / DIVIDERS
  // =========================================================

  static const Color darkBorder = Color(0xFF49353D);

  static const Color darkDivider = Color(0xFF3A2930);

  // =========================================================
  // DARK INPUT
  // =========================================================

  static const Color darkInputBackground = Color(0xFF2A1E24);

  // =========================================================
  // DARK CHIP
  // =========================================================

  static const Color darkChipBackground = Color(0xFF302229);

  // =========================================================
  // STATUS & TAG COLORS
  // =========================================================

  static const Color tagGreen = Color(0xFF2E7D32);

  static const Color tagGreenBg = Color(0xFFE8F5E9);

  static const Color ratingStar = Color(0xFFFFB800);

  // =========================================================
  // TEXT COLORS - LIGHT
  // =========================================================

  static const Color textPrimary = Color(0xFF1E1E1E);

  static const Color textSecondary = Color(0xFF666666);

  static const Color textHint = Color(0xFF9E9E9E);

  static const Color textWhite = Color(0xFFFFFFFF);

  // =========================================================
  // UI ELEMENTS & BORDERS - LIGHT
  // =========================================================

  static const Color inputBackground = Color(0xFFF4F4F4);

  static const Color border = Color(0xFFE0E0E0);

  static const Color divider = Color(0xFFE0E0E0);

  static const Color chipBackground = Color(0xFFF0F0F0);

  // =========================================================
  // SHADOW
  // =========================================================

  static const Color shadow = Color(0x0F000000);

  // =========================================================
  // STATUS
  // =========================================================

  static const Color error = Color(0xFFD32F2F);

  static const Color success = tagGreen;

  static const Color warning = Color(0xFFF9A825);

  // =========================================================
  // COMMON
  // =========================================================

  static const Color white = Colors.white;

  static const Color black = Colors.black;
}