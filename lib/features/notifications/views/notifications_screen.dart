import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/notifications_controller.dart';

class NotificationsScreen extends GetView<NotificationController> {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: AppTextStyles.headingMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  size: 80,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 20),
                Text(
                  'No notifications yet',
                  style: AppTextStyles.headingSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You will see your notifications here.',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.notifications.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final notification =
                controller.notifications[index];

            return ListTile(
              onTap: () {
                controller.markAsRead(notification.id);
              },
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                ),
              ),
              title: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: notification.isRead
                      ? FontWeight.normal
                      : FontWeight.bold,
                ),
              ),
              subtitle: Text(notification.message),
              trailing: notification.isRead
                  ? null
                  : Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
            );
          },
        );
      }),
    );
  }
}