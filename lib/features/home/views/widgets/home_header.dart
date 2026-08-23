import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/home/controllers/home_controller.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;

  const HomeHeader({
    super.key,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final notificationBackground = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final notificationBorder = isDark
        ? AppColors.darkBorder
        : AppColors.border;

    return Container(
      width: double.infinity,
      height: 240,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // =====================================================
          // HEADER IMAGE
          // =====================================================

          Positioned.fill(
            child: Image.asset(
              'assets/images/home_header.png',
              fit: BoxFit.cover,
            ),
          ),

          // =====================================================
          // GREETING
          // =====================================================

          Positioned(
            left: 24,
            top: 35,
            child: Obx(() {
              final displayName =
                  homeController.userName.value.trim().isEmpty
                      ? 'Chef'
                      : homeController.userName.value.trim();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $displayName!',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'What would you like\nto cook today?',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ],
              );
            }),
          ),

          // =====================================================
          // NOTIFICATION BUTTON
          // =====================================================

          Positioned(
            top: 14,
            right: 14,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onNotificationTap,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: notificationBackground.withOpacity(0.92),
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
          ),
        ],
      ),
    );

  }
}