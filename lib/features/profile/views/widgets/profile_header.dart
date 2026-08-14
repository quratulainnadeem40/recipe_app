import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    this.name = 'COOKmate User',
    this.email = 'user@example.com',
    this.profileImageBytes,
    this.onImageTap,
  });

  final String name;
  final String email;
  final Uint8List? profileImageBytes;
  final VoidCallback? onImageTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isDark = theme.brightness == Brightness.dark;

    final primaryColor =
        isDark ? AppColors.darkPrimary : AppColors.primary;

    final secondaryTextColor =
        colorScheme.onSurfaceVariant;

    return Column(
      children: [
        // =====================================================
        // PROFILE IMAGE
        // =====================================================

        GestureDetector(
          onTap: onImageTap,
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: primaryColor.withValues(
                alpha: 0.12,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: profileImageBytes != null
                  ? Image.memory(
                      profileImageBytes!,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.person_rounded,
                      size: 52,
                      color: primaryColor,
                    ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // =====================================================
        // CHANGE PHOTO
        // =====================================================

        TextButton.icon(
          onPressed: onImageTap,
          icon: Icon(
            Icons.camera_alt_outlined,
            size: 18,
            color: primaryColor,
          ),
          label: Text(
            'Change Photo',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 4),

        // =====================================================
        // NAME
        // =====================================================

        Text(
          name,
          style: AppTextStyles.headingMedium.copyWith(
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 4),

        // =====================================================
        // EMAIL
        // =====================================================

        Text(
          email,
          style: AppTextStyles.bodyMedium.copyWith(
            color: secondaryTextColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}