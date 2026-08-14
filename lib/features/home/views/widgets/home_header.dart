import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/core/routes/app_routes.dart';
import 'package:recipe_app/features/notifications/controllers/notifications_controller.dart';


class HomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback? onNotificationTap;

  const HomeHeader({
    super.key,
    this.userName = 'User',
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final notificationController =
        Get.find<NotificationController>();

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $userName 👋',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'What would you like to cook today?',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 4),

        // =====================================================
        // NOTIFICATION ICON + UNREAD BADGE
        // =====================================================

        Obx(() {
          final unreadCount =
              notificationController.unreadCount;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: onNotificationTap ??
                    () {
                      Get.toNamed(
                        AppRoutes.notifications,
                      );
                    },
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor:
                      Theme.of(context).colorScheme.primary,
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                  ),
                ),
              ),

              // =================================================
              // UNREAD COUNT
              // =================================================

              if (unreadCount > 0)
                Positioned(
                  right: -2,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unreadCount > 9
                          ? '9+'
                          : unreadCount.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}