import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/notifications_controller.dart';

class NotificationsScreen extends GetView<NotificationController> {
  const NotificationsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // ==================================================
      // APP BAR
      // ==================================================

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
        ),

        title: Text(
          'Notifications',
          style: AppTextStyles.headingMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),

        centerTitle: true,

        // ==================================================
        // MENU
        // ==================================================

        actions: [
          Obx(() {
            if (controller.notifications.isEmpty) {
              return const SizedBox.shrink();
            }

            return PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                color: AppColors.textPrimary,
              ),

              color: AppColors.surface,

              surfaceTintColor: Colors.transparent,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(
                  color: AppColors.border,
                  width: 1,
                ),
              ),

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
                  PopupMenuItem<String>(
                    value: 'read',
                    child: Text(
                      'Mark all as read',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  PopupMenuItem<String>(
                    value: 'clear',
                    child: Text(
                      'Clear all',
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ];
              },
            );
          }),
        ],
      ),

      // ==================================================
      // BODY
      // ==================================================

      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            24,
          ),

          itemCount: controller.notifications.length,

          separatorBuilder: (_, __) {
            return const SizedBox(
              height: 10,
            );
          },

          itemBuilder: (context, index) {
            final notification =
                controller.notifications[index];

            return _buildNotificationItem(
              notification,
            );
          },
        );
      }),
    );
  }

  // ==================================================
  // EMPTY STATE
  // ==================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            // ==================================================
            // ICON BACKGROUND
            // ==================================================

            Container(
              width: 110,
              height: 110,

              decoration: BoxDecoration(
                color: AppColors.darkBackground,
                shape: BoxShape.circle,

                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 14,
                    offset: Offset(
                      0,
                      5,
                    ),
                  ),
                ],
              ),

              child: const Icon(
                Icons.notifications_none_rounded,
                size: 58,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 22),

            // ==================================================
            // TITLE
            // ==================================================

            Text(
              'No notifications yet',

              style: AppTextStyles.headingSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),

              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // ==================================================
            // DESCRIPTION
            // ==================================================

            Text(
              'You will see your notifications here.',

              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),

              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // NOTIFICATION ITEM
  // ==================================================

  Widget _buildNotificationItem(
    dynamic notification,
  ) {
    final bool isRead = notification.isRead;

    return Card(
      color: AppColors.surface,

      elevation: isRead ? 1 : 3,

      shadowColor: AppColors.shadow,

      margin: EdgeInsets.zero,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),

        side: BorderSide(
          color: isRead
              ? AppColors.border
              : AppColors.primaryLight,

          width: 1,
        ),
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),

        // ==================================================
        // TAP
        // ==================================================

        onTap: () {
          if (!isRead) {
            controller.markAsRead(
              notification.id,
            );
          }
        },

        // ==================================================
        // NOTIFICATION ICON
        // ==================================================

        leading: Container(
          width: 46,
          height: 46,

          decoration: BoxDecoration(
            color: AppColors.darkBackground,
            shape: BoxShape.circle,
          ),

          child: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.primary,
            size: 24,
          ),
        ),

        // ==================================================
        // TITLE
        // ==================================================

        title: Text(
          notification.title,

          maxLines: 2,
          overflow: TextOverflow.ellipsis,

          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textPrimary,

            fontWeight: isRead
                ? FontWeight.w500
                : FontWeight.w700,
          ),
        ),

        // ==================================================
        // MESSAGE
        // ==================================================

        subtitle: Padding(
          padding: const EdgeInsets.only(
            top: 5,
          ),

          child: Text(
            notification.message,

            maxLines: 3,
            overflow: TextOverflow.ellipsis,

            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),

        // ==================================================
        // READ / UNREAD
        // ==================================================

        trailing: isRead
            ? const Icon(
                Icons.done_rounded,
                size: 18,
                color: AppColors.success,
              )
            : Container(
                width: 10,
                height: 10,

                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
      ),
    );
  }

  // ==================================================
  // CLEAR DIALOG
  // ==================================================

  void _showClearDialog(
    BuildContext context,
  ) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,

        surfaceTintColor: Colors.transparent,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        // ==================================================
        // TITLE
        // ==================================================

        title: Text(
          'Clear notifications?',

          style: AppTextStyles.headingSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),

        // ==================================================
        // CONTENT
        // ==================================================

        content: Text(
          'All notifications will be removed.',

          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),

        // ==================================================
        // ACTIONS
        // ==================================================

        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },

            child: Text(
              'Cancel',

              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),

          TextButton(
            onPressed: () {
              controller.clearNotifications();
              Get.back();
            },

            child: Text(
              'Clear',

              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}