import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    this.name = 'COOKmate User',
    this.email = 'user@example.com',
  });

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.person_rounded,
            size: 52,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 14),

        Text(
          name,
          style: AppTextStyles.headingMedium,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 4),

        Text(
          email,
          style: AppTextStyles.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}