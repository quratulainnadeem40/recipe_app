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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // =========================================================
    // DYNAMIC THEME COLORS
    // =========================================================

    final backgroundColor = theme.scaffoldBackgroundColor;

    final surfaceColor = theme.cardColor;

    final primaryTextColor = theme.colorScheme.onSurface;

    final secondaryTextColor =
        isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    final borderColor =
        isDark ? Colors.white.withOpacity(0.10) : AppColors.border;

    final iconBackgroundColor =
        isDark ? const Color(0xFF2A2A2A) : AppColors.darkBackground;

    final popupColor = surfaceColor;

    final shadowColor = isDark
        ? Colors.black.withOpacity(0.35)
        : AppColors.shadow;

    return Scaffold(
      backgroundColor: backgroundColor,

      // ==================================================
      // APP BAR
      // ==================================================

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        iconTheme: IconThemeData(
          color: primaryTextColor,
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
              icon: Icon(
                Icons.more_vert,
                color: primaryTextColor,
              ),

              color: popupColor,

              surfaceTintColor: Colors.transparent,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: borderColor,
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
                return [
                  PopupMenuItem<String>(
                    value: 'read',
                    child: Text(
                      'Mark all as read',
                      style: TextStyle(
                        color: primaryTextColor,
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
          return _buildEmptyState(
            context: context,
            backgroundColor: backgroundColor,
            primaryTextColor: primaryTextColor,
            secondaryTextColor: secondaryTextColor,
            iconBackgroundColor: iconBackgroundColor,
            shadowColor: shadowColor,
          );
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
              context: context,
              notification: notification,
              surfaceColor: surfaceColor,
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
              borderColor: borderColor,
              iconBackgroundColor: iconBackgroundColor,
              shadowColor: shadowColor,
            );
          },
        );
      }),
    );
  }

  // ==================================================
  // EMPTY STATE
  // ==================================================

  Widget _buildEmptyState({
    required BuildContext context,
    required Color backgroundColor,
    required Color primaryTextColor,
    required Color secondaryTextColor,
    required Color iconBackgroundColor,
    required Color shadowColor,
  }) {
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
                color: iconBackgroundColor,
                shape: BoxShape.circle,

                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 14,
                    offset: const Offset(
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
                color: primaryTextColor,
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
                color: secondaryTextColor,
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

  Widget _buildNotificationItem({
    required BuildContext context,
    required dynamic notification,
    required Color surfaceColor,
    required Color primaryTextColor,
    required Color secondaryTextColor,
    required Color borderColor,
    required Color iconBackgroundColor,
    required Color shadowColor,
  }) {
    final bool isRead = notification.isRead;

    return Card(
      color: surfaceColor,

      elevation: isRead ? 1 : 3,

      shadowColor: shadowColor,

      margin: EdgeInsets.zero,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),

        side: BorderSide(
          color: isRead
              ? borderColor
              : (Theme.of(context).brightness == Brightness.dark
                  ? AppColors.primary.withOpacity(0.35)
                  : AppColors.primaryLight),
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
            color: iconBackgroundColor,
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
            color: primaryTextColor,

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
              color: secondaryTextColor,
              height: 1.4,
            ),
          ),
        ),

        // ==================================================
        // READ / UNREAD
        // ==================================================

        trailing: isRead
            ? Icon(
                Icons.done_rounded,
                size: 18,
                color: isRead
                    ? AppColors.success
                    : secondaryTextColor,
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
    final theme = Theme.of(context);
    final isDark =
        theme.brightness == Brightness.dark;

    final dialogBackground =
        theme.dialogBackgroundColor;

    final primaryTextColor =
        theme.colorScheme.onSurface;

    final secondaryTextColor =
        isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    Get.dialog(
      AlertDialog(
        backgroundColor: dialogBackground,

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
            color: primaryTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),

        // ==================================================
        // CONTENT
        // ==================================================

        content: Text(
          'All notifications will be removed.',

          style: AppTextStyles.bodyMedium.copyWith(
            color: secondaryTextColor,
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
                color: secondaryTextColor,
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