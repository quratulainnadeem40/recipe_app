import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/settings_controller.dart';

class AccountSettingsScreen extends GetView<SettingsController> {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.background;

    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.border;

    final primaryColor = AppColors.primary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: primaryTextColor,
        ),
        title: Text(
          'Personalization Settings',
          style: AppTextStyles.headingMedium.copyWith(
            color: primaryTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        children: [
          _sectionTitle('Chef Profile', primaryColor),
          const SizedBox(height: 10),
          Obx(
            () => _settingsTile(
              context: context,
              surfaceColor: surfaceColor,
              borderColor: borderColor,
              titleColor: primaryTextColor,
              subtitleColor: secondaryTextColor,
              icon: Icons.person_outline_rounded,
              title: 'Chef Name',
              subtitle: controller.chefName.value,
              onTap: () => Get.toNamed(AppRoutes.editProfile),
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle('Notifications', primaryColor),
          const SizedBox(height: 10),
          _notificationTile(
            context: context,
            surfaceColor: surfaceColor,
            borderColor: borderColor,
            titleColor: primaryTextColor,
            subtitleColor: secondaryTextColor,
            primaryColor: primaryColor,
          ),
          const SizedBox(height: 24),
          _sectionTitle('Data Management', primaryColor),
          const SizedBox(height: 10),
          _settingsTile(
            context: context,
            surfaceColor: surfaceColor,
            borderColor: borderColor,
            titleColor: primaryTextColor,
            subtitleColor: secondaryTextColor,
            icon: Icons.refresh_rounded,
            title: 'Reset App Data',
            subtitle: 'Clear favorites and local preferences',
            iconColor: AppColors.error,
            onTap: controller.resetLocalData,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Text(
      title,
      style: AppTextStyles.labelLarge.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _settingsTile({
    required BuildContext context,
    required Color surfaceColor,
    required Color borderColor,
    required Color titleColor,
    required Color subtitleColor,
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppColors.primary,
                  size: 21,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle != null && subtitle.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: 12.5,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  color: subtitleColor,
                  size: 23,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _notificationTile({
    required BuildContext context,
    required Color surfaceColor,
    required Color borderColor,
    required Color titleColor,
    required Color subtitleColor,
    required Color primaryColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Obx(
        () => Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: primaryColor,
                size: 21,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notifications',
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Receive notifications about your recipes and tips',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 12.5,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Switch(
              value: controller.isNotificationsEnabled.value,
              onChanged: controller.toggleNotifications,
              activeThumbColor: Colors.white,
              activeTrackColor: primaryColor,
              inactiveThumbColor: isDarkMode(context)
                  ? AppColors.darkTextSecondary
                  : AppColors.surface,
              inactiveTrackColor: isDarkMode(context)
                  ? AppColors.darkBorder
                  : AppColors.border,
            ),
          ],
        ),
      ),
    );
  }

  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
