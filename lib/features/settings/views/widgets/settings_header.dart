import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({
    super.key,
    required this.name,
    this.profileImageBytes,
    this.onImageTap,
    this.onEditTap,
  });

  final String name;
  final Uint8List? profileImageBytes;
  final VoidCallback? onImageTap;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = AppColors.primary;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.surface;
    final cardBorder = isDark ? AppColors.darkBorder : AppColors.border;
    final primaryTextColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: cardBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: primaryColor.withValues(alpha: isDark ? 0.15 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Row(
        children: [
          // =========================================================
          // AVATAR WITH CAMERA ACTION
          // =========================================================
          Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: onImageTap,
                child: Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor,
                      width: 2.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: profileImageBytes != null
                        ? Image.memory(
                            profileImageBytes!,
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            Icons.person_rounded,
                            size: 48,
                            color: primaryColor,
                          ),
                  ),
                ),
              ),

              // Camera Badge
              Positioned(
                right: -2,
                bottom: -2,
                child: GestureDetector(
                  onTap: onImageTap,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: cardBg,
                        width: 2.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: AppColors.textWhite,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // =========================================================
          // CHEF INFO & EDIT
          // =========================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.restaurant_rounded,
                        color: AppColors.primary,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Chef Profile',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                // Name + Edit Button
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.headingSmall.copyWith(
                          color: primaryTextColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    if (onEditTap != null)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onEditTap,
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              Icons.edit_outlined,
                              color: primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 2),

                // Subtitle
                Text(
                  'Tap photo or edit icon to customize',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
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
