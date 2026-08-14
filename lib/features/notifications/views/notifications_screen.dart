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

        actions: [
          Obx(() {
            if (controller.notifications.isEmpty) {
              return const SizedBox.shrink();
            }

            return PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'read') {
                  controller.markAllAsRead();
                }

                if (value == 'clear') {
                  _showClearDialog(context);
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                    value: 'read',
                    child: Text('Mark all as read'),
                  ),
                  PopupMenuItem(
                    value: 'clear',
                    child: Text('Clear all'),
                  ),
                ];
              },
            );
          }),
        ],
      ),

      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.notifications.length,
          separatorBuilder: (_, __) {
            return const SizedBox(height: 8);
          },
          itemBuilder: (context, index) {
            final notification =
                controller.notifications[index];

            return _buildNotificationItem(notification);
          },
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
      ),
    );
  }

  Widget _buildNotificationItem(
    dynamic notification,
  ) {
    return Card(
      elevation: notification.isRead ? 1 : 3,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),

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

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            notification.message,
          ),
        ),

        trailing: notification.isRead
            ? const Icon(
                Icons.done,
                size: 18,
                color: Colors.grey,
              )
            : Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Clear notifications?',
        ),

        content: const Text(
          'All notifications will be removed.',
        ),

        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),

          TextButton(
            onPressed: () {
              controller.clearNotifications();
              Get.back();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}