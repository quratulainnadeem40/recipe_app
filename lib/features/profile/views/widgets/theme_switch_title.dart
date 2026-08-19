import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ThemeSwitchTile extends StatelessWidget {
  const ThemeSwitchTile({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isDark = theme.brightness == Brightness.dark;

    // Theme-aware primary color
    final primaryColor = AppColors.primary;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 2,
      ),

      // =====================================================
      // ICON
      // =====================================================
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: primaryColor.withValues(
            alpha: isDark ? 0.16 : 0.10,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.dark_mode_outlined,
          color: primaryColor,
          size: 22,
        ),
      ),

      // =====================================================
      // TITLE
      // =====================================================
      title: Text(
        'Dark Mode',
        style: AppTextStyles.bodyLarge.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),

      // =====================================================
      // SWITCH
      // =====================================================
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,

        activeThumbColor: AppColors.primary,

        activeTrackColor: isDark
            ? AppColors.primary.withValues(alpha: 0.35)
            : AppColors.primary.withValues(alpha: 0.25),

        inactiveThumbColor: isDark
            ? AppColors.textWhite
            : AppColors.textSecondary,

        inactiveTrackColor: isDark
            ? AppColors.categoryCardSecondary
            : AppColors.border,
      ),
    );
  }
}