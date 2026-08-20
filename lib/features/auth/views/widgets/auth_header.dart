import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AuthHeader extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    // =========================================================
    // THEME COLORS
    // =========================================================

    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final iconColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textWhite;

    final iconBackground = isDark
        ? AppColors.primaryDark
        : AppColors.primary;

    // =========================================================
    // HEADER
    // =========================================================

    return Column(
      children: [
        // =====================================================
        // ICON
        // =====================================================

        if (icon != null) ...[
          const SizedBox(height: 20),

          Container(
            width: 76,
            height: 76,
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(24),

              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.30)
                      : AppColors.shadow,
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: Icon(
              icon,
              color: iconColor,
              size: 40,
            ),
          ),

          const SizedBox(height: 25),
        ],

        // =====================================================
        // TITLE
        // =====================================================

        Text(
          title,
          textAlign: TextAlign.center,

          style: AppTextStyles.headingLarge.copyWith(
            color: textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 8),

        // =====================================================
        // SUBTITLE
        // =====================================================

        Text(
          subtitle,
          textAlign: TextAlign.center,

          style: AppTextStyles.bodyMedium.copyWith(
            color: textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}