import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/core/routes/app_routes.dart';

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

    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.primary;

    final secondaryTextColor = colorScheme.onSurfaceVariant;

   return Container(
  width: double.infinity,
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: primaryColor.withValues(alpha: 0.15),
    ),
  ),
  child: Row(
    children: [
      // PROFILE IMAGE + CAMERA ICON
      Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: onImageTap,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.12),
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

          // CAMERA ICON
          Positioned(
            right: -2,
            bottom: -2,
            child: GestureDetector(
              onTap: onImageTap,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkSurface
                        : AppColors.lightSurface,
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),

      const SizedBox(width: 14),

      // NAME + EMAIL
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NAME + PENCIL
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headingMedium.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.editProfile,
                    );
                  },
                  child: Icon(
                    Icons.edit_outlined,
                    color: primaryColor,
                    size: 23,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // EMAIL
            Text(
              email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);
  }
}