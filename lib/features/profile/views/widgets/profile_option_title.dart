import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ProfileOptionTile extends StatelessWidget {
  const ProfileOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isDark = theme.brightness == Brightness.dark;

    // Theme-aware primary color
    final primaryColor = isDark
        ? AppColors.darkPrimary
        : AppColors.primary;

    // Use custom color for special actions
    final effectiveIconColor = iconColor ?? primaryColor;

    return ListTile(
      onTap: onTap,

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
          color: effectiveIconColor.withValues(
            alpha: isDark ? 0.16 : 0.10,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: effectiveIconColor,
          size: 22,
        ),
      ),

      // =====================================================
      // TITLE
      // =====================================================
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),

      // =====================================================
      // ARROW
      // =====================================================
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: primaryColor,
      ),
    );
  }
}