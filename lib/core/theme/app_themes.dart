import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  // =========================================================
  // LIGHT THEME
  // =========================================================

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: AppColors.background,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.tagGreen,
      surface: AppColors.surface,
      error: Colors.redAccent,
      onPrimary: AppColors.textWhite,
      onSecondary: AppColors.textWhite,
      onSurface: AppColors.textPrimary,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: false,
    ),

    cardTheme: const CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),

    textTheme: const TextTheme(
      headlineLarge: AppTextStyles.headingLarge,
      headlineMedium: AppTextStyles.headingMedium,
      headlineSmall: AppTextStyles.headingSmall,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
    ),

    // =======================================================
    // LIGHT INPUT FIELDS
    // =======================================================

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackground,
      hintStyle: const TextStyle(
        color: AppColors.textHint,
        fontSize: 14,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    ),

    // =======================================================
    // LIGHT BUTTON
    // =======================================================

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: AppTextStyles.button,
      ),
    ),

    // =======================================================
    // LIGHT DIVIDER
    // =======================================================

    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
    ),
  );

  // =========================================================
  // DARK THEME
  // =========================================================

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColors.darkBackground,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryLight,
      secondary: AppColors.tagGreen,
      surface: AppColors.categoryCardSecondary,
      error: Colors.redAccent,

      onPrimary: AppColors.darkBackground,
      onSecondary: AppColors.textWhite,
      onSurface: AppColors.textWhite,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.textWhite,
      elevation: 0,
      centerTitle: false,
    ),

    cardTheme: const CardThemeData(
      color: AppColors.categoryCardSecondary,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),

    // =======================================================
    // DARK TEXT THEME
    // =======================================================

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textWhite,
      ),

      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textWhite,
      ),

      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textWhite,
      ),

      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.textWhite,
      ),

      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.textWhite,
      ),

      bodySmall: TextStyle(
        fontSize: 12,
        color: AppColors.textSecondary,
      ),

      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textWhite,
      ),

      labelMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textWhite,
      ),

      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
    ),

    // =======================================================
    // DARK INPUT FIELDS
    // =======================================================

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.categoryCardSecondary,
      hintStyle: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.primaryLight,
          width: 1.5,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    ),

    // =======================================================
    // DARK BUTTON
    // =======================================================

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: AppTextStyles.button,
      ),
    ),

    // =======================================================
    // DARK DIVIDER
    // =======================================================

    dividerTheme: const DividerThemeData(
      color: AppColors.categoryCardSecondary,
      thickness: 1,
    ),
  );
}