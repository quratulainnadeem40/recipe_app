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
    return Column(
      children: [
        if (icon != null) ...[
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              icon,
              color: AppColors.white,
              size: 40,
            ),
          ),

          const SizedBox(height: 25),
        ],

        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.headingLarge.copyWith(
            color: AppColors.primary,
            fontSize: 28,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}