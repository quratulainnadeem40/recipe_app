import 'package:flutter/material.dart';
import 'package:recipe_app/core/theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String actionTitle;
  final VoidCallback? onActionTap;
  final bool showAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionTitle = 'See all',
    this.onActionTap,
    this.showAction = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Section Title
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.2,
          ),
        ),

        // Action Button ("See all" / "Clear all")
        if (showAction)
          GestureDetector(
            onTap: onActionTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
              child: Text(
                actionTitle,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: actionTitle.toLowerCase().contains('clear')
                      ? AppColors.textSecondary
                      : AppColors.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}