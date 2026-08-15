import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/core/routes/app_routes.dart';
import 'package:recipe_app/features/profile/views/widgets/profile_option_title.dart';
import 'package:recipe_app/features/profile/views/widgets/theme_switch_title.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/profile_controller.dart';
import 'widgets/profile_header.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'My Profile',
          style: AppTextStyles.headingMedium.copyWith(color: AppColors.primary),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // ==========================================
              // PROFILE HEADER
              // ==========================================
              Obx(
                () => ProfileHeader(
                  name: controller.user.value?.name ?? 'COOKmate User',
                  email: controller.user.value?.email ?? '',
                ),
              ),

              const SizedBox(height: 32),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.toNamed('/edit-profile');
                  },
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Edit Profile'),
                ),
              ),

              const SizedBox(height: 20),

              // ==========================================
              // ACCOUNT SECTION
              // ==========================================
              _sectionTitle('Account'),

              const SizedBox(height: 8),

              ProfileOptionTile(
                icon: Icons.person_outline_rounded,
                title: 'Account Settings',
                onTap: () {
                  Get.toNamed(AppRoutes.accountSettings);
                },
              ),

              const SizedBox(height: 4),

              // ==========================================
              // APPEARANCE SECTION
              // ==========================================
              _sectionTitle('Appearance'),

              const SizedBox(height: 8),

              Obx(
                () => ThemeSwitchTile(
                  value: controller.isDarkMode.value,
                  onChanged: controller.toggleTheme,
                ),
              ),

              const SizedBox(height: 4),

              // ==========================================
              // INFORMATION SECTION
              // ==========================================
              _sectionTitle('Information'),

              const SizedBox(height: 8),

              ProfileOptionTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {
                  Get.toNamed(AppRoutes.privacyPolicy);
                },
              ),

              const SizedBox(height: 4),

              ProfileOptionTile(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                onTap: () {
                  Get.toNamed(AppRoutes.termsAndConditions);
                },
              ),

              const SizedBox(height: 4),

              // ==========================================
              // DANGER ZONE
              // ==========================================
              _sectionTitle('Account Actions'),

              const SizedBox(height: 8),

              ProfileOptionTile(
                icon: Icons.delete_outline_rounded,
                title: 'Delete Account',
                iconColor: Colors.red,
                onTap: controller.deleteAccount,
              ),

              const SizedBox(height: 4),

              ProfileOptionTile(
                icon: Icons.logout_rounded,
                title: 'Logout',
                iconColor: AppColors.orange,
                onTap: controller.logout,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: AppTextStyles.labelLarge.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
