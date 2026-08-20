import 'package:flutter/material.dart';
import 'package:recipe_app/core/theme/app_colors.dart';
<<<<<<< HEAD
import 'package:recipe_app/core/theme/app_text_styles.dart';
import 'package:recipe_app/features/notifications/controllers/notifications_controller.dart';
=======
>>>>>>> cf67ec1 (Update profile UI and theme colors)

class HomeHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;

  const HomeHeader({super.key, this.onNotificationTap});

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

    final notificationBorder = isDark ? AppColors.darkBorder : AppColors.border;

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

<<<<<<< HEAD
            // COOKmate Branding Logo
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'COOK',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const TextSpan(
                    text: 'mate',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            // Notification Button
            Obx(() {
              final int unreadCount = notificationController.unreadCount;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications_none_rounded,
                      color: theme.colorScheme.onSurface,
                      size: 26,
                    ),
                    onPressed:
                        onNotificationTap ??
                        () {
                          Get.toNamed(AppRoutes.notifications);
                        },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),

                  if (unreadCount > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          unreadCount > 9 ? '9+' : unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }),
          ],
=======
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
>>>>>>> cf67ec1 (Update profile UI and theme colors)
        ),

        const SizedBox(width: 12),

        // ==================================================
        // NOTIFICATION BUTTON
        // ==================================================
        Material(
          color: Colors.transparent,

<<<<<<< HEAD
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back, $name!',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
=======
          child: InkWell(
            onTap: onNotificationTap,

            borderRadius: BorderRadius.circular(14),

            child: Container(
              width: 46,
              height: 46,

              decoration: BoxDecoration(
                color: notificationBackground,

                borderRadius: BorderRadius.circular(14),

                border: Border.all(color: notificationBorder, width: 1),

                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
>>>>>>> cf67ec1 (Update profile UI and theme colors)
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
      ],
    );
  }
}
