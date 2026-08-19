import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/profile_controller.dart';

class AccountSettingsScreen extends GetView<ProfileController> {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // =========================================================
    // THEME
    // =========================================================

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // =========================================================
    // COLORS
    // =========================================================

    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.background;

    final primaryColor = AppColors.primary;

    final titleColor = isDark
        ? AppColors.textWhite
        : AppColors.textPrimary;

    final subtitleColor = isDark
        ? AppColors.textWhite.withOpacity(0.70)
        : AppColors.textSecondary;

    final iconColor = AppColors.primary;

    return Scaffold(
      backgroundColor: backgroundColor,

      // =======================================================
      // APP BAR
      // =======================================================

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,

        iconTheme: IconThemeData(
          color: AppColors.primary,
        ),

        title: Text(
          'Account Settings',
          style: AppTextStyles.headingMedium.copyWith(
            color: primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // =======================================================
      // BODY
      // =======================================================

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          // =====================================================
          // ACCOUNT INFORMATION
          // =====================================================

          _sectionTitle(
            context,
            'Account Information',
          ),

          const SizedBox(height: 8),

          _settingsTile(
            context: context,
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: controller.user.value?.email ?? '',
          ),

          const SizedBox(height: 24),

          // =====================================================
          // SECURITY
          // =====================================================

          _sectionTitle(
            context,
            'Security',
          ),

          const SizedBox(height: 8),

          _settingsTile(
            context: context,
            icon: Icons.lock_outline_rounded,
            title: 'Change Password',
            subtitle: 'Update your account password',
            onTap: () {
              Get.toNamed('/change-password');
            },
          ),

          const SizedBox(height: 24),

          // =====================================================
          // NOTIFICATIONS
          // =====================================================

          _sectionTitle(
            context,
            'Notifications',
          ),

          const SizedBox(height: 8),

          Obx(
            () => SwitchListTile(
              contentPadding: EdgeInsets.zero,

              secondary: Icon(
                Icons.notifications_none_rounded,
                color: iconColor,
              ),

              title: Text(
                'Notifications',
                style: TextStyle(
                  color: titleColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              subtitle: Text(
                'Receive notifications about your account',
                style: TextStyle(
                  color: subtitleColor,
                  fontSize: 14,
                ),
              ),

              value:
                  controller.isNotificationsEnabled.value,

              onChanged:
                  controller.toggleNotifications,

              activeColor: primaryColor,
            ),
          ),

          const SizedBox(height: 24),

          // =====================================================
          // ACCOUNT ACTIONS
          // =====================================================

          _sectionTitle(
            context,
            'Account Actions',
          ),

          const SizedBox(height: 8),

          _settingsTile(
            context: context,
            icon: Icons.delete_outline_rounded,
            title: 'Delete Account',
            subtitle: 'Permanently delete your account',
            iconColor: AppColors.error,
            onTap: controller.deleteAccount,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // =============================================================
  // SECTION TITLE
  // =============================================================

  Widget _sectionTitle(
    BuildContext context,
    String title,
  ) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final color = AppColors.primary;

    return Text(
      title,
      style: AppTextStyles.labelLarge.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // =============================================================
  // SETTINGS TILE
  // =============================================================

  Widget _settingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final titleColor = isDark
        ? AppColors.textWhite
        : AppColors.textPrimary;

    final subtitleColor = isDark
        ? AppColors.textWhite.withOpacity(0.70)
        : AppColors.textSecondary;

    final defaultIconColor = AppColors.primary;

    return ListTile(
      contentPadding: EdgeInsets.zero,

      leading: Icon(
        icon,
        color: iconColor ?? defaultIconColor,
      ),

      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),

      subtitle: subtitle == null
          ? null
          : Text(
              subtitle,
              style: TextStyle(
                color: subtitleColor,
                fontSize: 14,
              ),
            ),

      trailing: onTap == null
          ? null
          : Icon(
              Icons.chevron_right_rounded,
              color: isDark
                  ? AppColors.textWhite
                  : AppColors.textSecondary,
            ),

      onTap: onTap,
    );
  }
}