import 'package:flutter/material.dart';

import 'package:recipe_app/core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;
  final String userName;

  const HomeHeader({
    super.key,
    this.onNotificationTap, required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final notificationBackground = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final notificationBorder = isDark
        ? AppColors.darkBorder
        : AppColors.border;

    return Row(
      children: [
        // ==================================================
        // GREETING
        // ==================================================
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, Chef 👋',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                'What would you like to cook today?',
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // ==================================================
        // NOTIFICATION BUTTON
        // ==================================================
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onNotificationTap,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: notificationBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: notificationBorder,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ),
    
    ),
  ]);
    
  
  }
}