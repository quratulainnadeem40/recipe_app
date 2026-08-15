import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/profile_controller.dart';

class AccountSettingsScreen extends GetView<ProfileController> {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account Settings',
          style: AppTextStyles.headingMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // =====================================================
          // ACCOUNT INFORMATION
          // =====================================================
          _sectionTitle('Account Information'),

          const SizedBox(height: 8),

          _settingsTile(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: controller.user.value?.email ?? '',
          ),

          const SizedBox(height: 24),

          // =====================================================
          // SECURITY
          // =====================================================
          _sectionTitle('Security'),

          const SizedBox(height: 8),

          _settingsTile(
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
          _sectionTitle('Notifications'),

          const SizedBox(height: 8),

          Obx(
            () => SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.notifications_none_rounded),
              title: const Text('Notifications'),
              subtitle: const Text('Receive notifications about your account'),
              value: controller.isNotificationsEnabled.value,
             onChanged: controller.toggleNotifications,
            ),
          ),

          const SizedBox(height: 24),

          // =====================================================
          // ACCOUNT ACTIONS
          // =====================================================
          _sectionTitle('Account Actions'),

          const SizedBox(height: 8),

          _settingsTile(
            icon: Icons.delete_outline_rounded,
            title: 'Delete Account',
            subtitle: 'Permanently delete your account',
            iconColor: Colors.red,
            onTap: controller.deleteAccount,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.labelLarge.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: iconColor ?? AppColors.primary),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
      trailing: onTap == null ? null : const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
