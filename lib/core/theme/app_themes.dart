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

    // =======================================================
    // COLOR SCHEME
    // =======================================================

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.textWhite,

      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.primaryDark,

      secondary: AppColors.primaryDark,
      onSecondary: AppColors.textWhite,

      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,

      surfaceContainerHighest: AppColors.inputBackground,
      onSurfaceVariant: AppColors.textSecondary,

      outline: AppColors.border,
      outlineVariant: AppColors.divider,

      error: AppColors.error,
      onError: AppColors.textWhite,
    ),

    // =======================================================
    // BASE
    // =======================================================

    scaffoldBackgroundColor: AppColors.background,

    // =======================================================
    // APP BAR
    // =======================================================

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
    ),

    // =======================================================
    // CARD
    // =======================================================

    cardTheme: const CardThemeData(
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),

    // =======================================================
    // TEXT
    // =======================================================

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
    ).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),

    // =======================================================
    // INPUT
    // =======================================================

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackground,

      labelStyle: const TextStyle(
        color: AppColors.textSecondary,
      ),

      floatingLabelStyle: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
      ),

      hintStyle: const TextStyle(
        color: AppColors.textHint,
        fontSize: 14,
      ),

      prefixIconColor: AppColors.textSecondary,
      suffixIconColor: AppColors.textSecondary,

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
          color: AppColors.error,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1.5,
        ),
      ),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    ),

    // =======================================================
    // ELEVATED BUTTON
    // =======================================================

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,

        disabledBackgroundColor: AppColors.primaryLight,
        disabledForegroundColor: AppColors.textSecondary,

        elevation: 0,

        minimumSize: const Size(
          double.infinity,
          52,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),

        textStyle: AppTextStyles.button,
      ),
    ),

    // =======================================================
    // OUTLINED BUTTON
    // =======================================================

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,

        minimumSize: const Size(
          double.infinity,
          52,
        ),

        side: const BorderSide(
          color: AppColors.primary,
          width: 1.2,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    // =======================================================
    // TEXT BUTTON
    // =======================================================

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // =======================================================
    // DIVIDER
    // =======================================================

    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),

    // =======================================================
    // ICON
    // =======================================================

    iconTheme: const IconThemeData(
      color: AppColors.textPrimary,
      size: 24,
    ),

    // =======================================================
    // FAB
    // =======================================================

    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textWhite,
      elevation: 2,
      shape: CircleBorder(),
    ),

    // =======================================================
    // NAVIGATION BAR
    // =======================================================

    navigationBarTheme:
        const NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,

      indicatorColor: AppColors.primaryLight,

      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),

      iconTheme: WidgetStatePropertyAll(
        IconThemeData(
          color: AppColors.textSecondary,
          size: 24,
        ),
      ),
    ),

    // =======================================================
    // CHIP
    // =======================================================

    chipTheme: const ChipThemeData(
      backgroundColor: AppColors.chipBackground,
      selectedColor: AppColors.primaryLight,
      disabledColor: AppColors.inputBackground,

      labelStyle: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),

      secondaryLabelStyle: TextStyle(
        color: AppColors.textSecondary,
      ),

      side: BorderSide.none,
      elevation: 0,
    ),

    // =======================================================
    // CHECKBOX
    // =======================================================

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }

          return AppColors.surface;
        },
      ),

      checkColor: const WidgetStatePropertyAll(
        AppColors.textWhite,
      ),

      side: const BorderSide(
        color: AppColors.border,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),

    // =======================================================
    // SWITCH
    // =======================================================

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.textWhite;
          }

          return AppColors.textSecondary;
        },
      ),

      trackColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }

          return AppColors.inputBackground;
        },
      ),
    ),

    // =======================================================
    // PROGRESS
    // =======================================================

    progressIndicatorTheme:
        const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.primaryLight,
    ),

    // =======================================================
    // DIALOG
    // =======================================================

    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    ),

    // =======================================================
    // BOTTOM SHEET
    // =======================================================

    bottomSheetTheme:
        const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
    ),

    // =======================================================
    // TOOLTIP
    // =======================================================

    tooltipTheme: const TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      textStyle: TextStyle(
        color: AppColors.textWhite,
        fontSize: 12,
      ),
    ),
  );

  // =========================================================
  // DARK THEME
  // =========================================================

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // =======================================================
    // COLOR SCHEME
    // =======================================================

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.textWhite,

      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: AppColors.darkTextPrimary,

      secondary: AppColors.primary,
      onSecondary: AppColors.textWhite,

      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,

      surfaceContainerHighest:
          AppColors.darkSurfaceElevated,

      onSurfaceVariant:
          AppColors.darkTextSecondary,

      outline: AppColors.darkBorder,
      outlineVariant: AppColors.darkDivider,

      error: AppColors.error,
      onError: AppColors.textWhite,
    ),

    // =======================================================
    // BASE
    // =======================================================

    scaffoldBackgroundColor:
        AppColors.darkBackground,

    // =======================================================
    // APP BAR
    // =======================================================

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,

      iconTheme: IconThemeData(
        color: AppColors.darkTextPrimary,
        size: 24,
      ),

      actionsIconTheme: IconThemeData(
        color: AppColors.darkTextPrimary,
        size: 24,
      ),
    ),

    // =======================================================
    // CARD
    // =======================================================

    cardTheme: const CardThemeData(
      color: AppColors.darkSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),

    // =======================================================
    // TEXT THEME
    // =======================================================

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
    ).apply(
      bodyColor: AppColors.darkTextPrimary,
      displayColor: AppColors.darkTextPrimary,
    ),

    // =======================================================
    // INPUT FIELDS
    // =======================================================

    inputDecorationTheme: InputDecorationTheme(
      filled: true,

      fillColor:
          AppColors.darkInputBackground,

      labelStyle: const TextStyle(
        color: AppColors.darkTextSecondary,
      ),

      floatingLabelStyle: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
      ),

      hintStyle: const TextStyle(
        color: AppColors.darkTextHint,
        fontSize: 14,
      ),

      prefixIconColor:
          AppColors.darkTextSecondary,

      suffixIconColor:
          AppColors.darkTextSecondary,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.darkBorder,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.darkBorder,
        ),
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
          color: AppColors.error,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1.5,
        ),
      ),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    ),

    // =======================================================
    // ELEVATED BUTTON
    // =======================================================

    elevatedButtonTheme:
        ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,

        disabledBackgroundColor:
            AppColors.primaryDark,

        disabledForegroundColor:
            AppColors.darkTextSecondary,

        elevation: 0,

        minimumSize: const Size(
          double.infinity,
          52,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),

        textStyle: AppTextStyles.button,
      ),
    ),

    // =======================================================
    // OUTLINED BUTTON
    // =======================================================

    outlinedButtonTheme:
        OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor:
            AppColors.darkTextPrimary,

        minimumSize: const Size(
          double.infinity,
          52,
        ),

        side: const BorderSide(
          color: AppColors.primary,
          width: 1.2,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    // =======================================================
    // TEXT BUTTON
    // =======================================================

    textButtonTheme:
        TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,

        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // =======================================================
    // DIVIDER
    // =======================================================

    dividerTheme:
        const DividerThemeData(
      color: AppColors.darkDivider,
      thickness: 1,
      space: 1,
    ),

    // =======================================================
    // ICON
    // =======================================================

    iconTheme: const IconThemeData(
      color: AppColors.darkTextPrimary,
      size: 24,
    ),

    // =======================================================
    // FAB
    // =======================================================

    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textWhite,
      elevation: 2,
      shape: CircleBorder(),
    ),

    // =======================================================
    // NAVIGATION BAR
    // =======================================================

    navigationBarTheme:
        const NavigationBarThemeData(
      backgroundColor:
          AppColors.darkSurface,

      surfaceTintColor:
          Colors.transparent,

      elevation: 0,

      indicatorColor:
          AppColors.categoryCard,

      labelTextStyle:
          WidgetStatePropertyAll(
        TextStyle(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),

      iconTheme:
          WidgetStatePropertyAll(
        IconThemeData(
          color:
              AppColors.darkTextSecondary,
          size: 24,
        ),
      ),
    ),

    // =======================================================
    // CHIP
    // =======================================================

    chipTheme:
        const ChipThemeData(
      backgroundColor:
          AppColors.darkChipBackground,

      selectedColor:
          AppColors.categoryCard,

      disabledColor:
          AppColors.darkBackground,

      labelStyle: TextStyle(
        color:
            AppColors.darkTextPrimary,
        fontWeight: FontWeight.w500,
      ),

      secondaryLabelStyle:
          TextStyle(
        color:
            AppColors.darkTextSecondary,
      ),

      side: BorderSide(
        color:
            AppColors.darkBorder,
      ),

      elevation: 0,
    ),

    // =======================================================
    // CHECKBOX
    // =======================================================

    checkboxTheme:
        CheckboxThemeData(
      fillColor:
          WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(
            WidgetState.selected,
          )) {
            return AppColors.primary;
          }

          return AppColors.darkSurface;
        },
      ),

      checkColor:
          const WidgetStatePropertyAll(
        AppColors.textWhite,
      ),

      side: const BorderSide(
        color: AppColors.darkBorder,
      ),

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(5),
      ),
    ),

    // =======================================================
    // SWITCH
    // =======================================================

    switchTheme:
        SwitchThemeData(
      thumbColor:
          WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(
            WidgetState.selected,
          )) {
            return AppColors.textWhite;
          }

          return AppColors.darkTextSecondary;
        },
      ),

      trackColor:
          WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(
            WidgetState.selected,
          )) {
            return AppColors.primary;
          }

          return AppColors.darkBorder;
        },
      ),

      trackOutlineColor:
          WidgetStateProperty.all(
        Colors.transparent,
      ),
    ),

    // =======================================================
    // PROGRESS INDICATOR
    // =======================================================

    progressIndicatorTheme:
        const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor:
          AppColors.darkBorder,
    ),

    // =======================================================
    // DIALOG
    // =======================================================

    dialogTheme:
        const DialogThemeData(
      backgroundColor:
          AppColors.darkSurface,

      surfaceTintColor:
          Colors.transparent,

      elevation: 0,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    ),

    // =======================================================
    // BOTTOM SHEET
    // =======================================================

    bottomSheetTheme:
        const BottomSheetThemeData(
      backgroundColor:
          AppColors.darkSurface,

      surfaceTintColor:
          Colors.transparent,

      elevation: 0,

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
    ),

    // =======================================================
    // TOOLTIP
    // =======================================================

    tooltipTheme:
        const TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.darkTextPrimary,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),

      textStyle: TextStyle(
        color: AppColors.darkBackground,
        fontSize: 12,
      ),
    ),
  );
}