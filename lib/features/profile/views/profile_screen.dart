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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor =
        isDark ? AppColors.darkPrimary : AppColors.primary;

    final backgroundColor =
        theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,

      // =====================================================
      // APP BAR
      // =====================================================

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text(
          'My Profile',
          style: AppTextStyles.headingMedium.copyWith(
            color: primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // =====================================================
      // BODY
      // =====================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Column(
            children: [
              // =====================================================
              // PROFILE HEADER
              // =====================================================

              Obx(
                () => ProfileHeader(
                  name: controller.user.value?.name ??
                      'COOKmate User',
                  email: controller.user.value?.email ??
                      '',
                  profileImageBytes:
                      controller.profileImageBytes.value,
                  onImageTap:
                      controller.pickProfileImage,
                ),
              ),

              const SizedBox(height: 28),

              // =====================================================
              // EDIT PROFILE
              // =====================================================

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.toNamed(
                      AppRoutes.editProfile,
                    );
                  },
                  icon: Icon(
                    Icons.edit_outlined,
                    color: primaryColor,
                  ),
                  label: Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    side: BorderSide(
                      color: primaryColor,
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    backgroundColor: isDark
                        ? AppColors.darkSurface
                        : AppColors.lightSurface,
                    elevation: 0,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // =====================================================
              // ACCOUNT
              // =====================================================

              _sectionTitle(
                context,
                'Account',
              ),

              const SizedBox(height: 8),

              ProfileOptionTile(
                icon: Icons.person_outline_rounded,
                title: 'Account Settings',
                onTap: () {
                  Get.toNamed(
                    AppRoutes.accountSettings,
                  );
                },
              ),

              const SizedBox(height: 8),

              // =====================================================
              // APPEARANCE
              // =====================================================

              _sectionTitle(
                context,
                'Appearance',
              ),

              const SizedBox(height: 8),

              Obx(
                () => ThemeSwitchTile(
                  value:
                      controller.isDarkMode.value,
                  onChanged:
                      controller.toggleTheme,
                ),
              ),

              const SizedBox(height: 8),

              // =====================================================
              // INFORMATION
              // =====================================================

              _sectionTitle(
                context,
                'Information',
              ),

              const SizedBox(height: 8),

              // -----------------------------------------------------
              // PRIVACY POLICY
              // -----------------------------------------------------

              ProfileOptionTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {
                  Get.toNamed(
                    AppRoutes.privacyPolicy,
                  );
                },
              ),

              const SizedBox(height: 8),

              // -----------------------------------------------------
              // TERMS & CONDITIONS
              // -----------------------------------------------------

              ProfileOptionTile(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                onTap: () {
                  Get.toNamed(
                    AppRoutes.termsAndConditions,
                  );
                },
              ),

              const SizedBox(height: 8),

              // -----------------------------------------------------
              // FEEDBACK
              // -----------------------------------------------------

              ProfileOptionTile(
                icon: Icons.feedback_outlined,
                title: 'Feedback',
                onTap: () {
                  Get.toNamed(
                    AppRoutes.feedback,
                  );
                },
              ),

              const SizedBox(height: 8),

              // =====================================================
              // ACCOUNT ACTIONS
              // =====================================================

              _sectionTitle(
                context,
                'Account Actions',
              ),

              const SizedBox(height: 8),

              // -----------------------------------------------------
              // DELETE ACCOUNT
              // -----------------------------------------------------

              ProfileOptionTile(
                icon: Icons.delete_outline_rounded,
                title: 'Delete Account',
                iconColor: Colors.red,
                onTap:
                    controller.deleteAccount,
              ),

              const SizedBox(height: 8),

              // -----------------------------------------------------
              // LOGOUT
              // -----------------------------------------------------

              ProfileOptionTile(
                icon: Icons.logout_rounded,
                title: 'Logout',
                iconColor: AppColors.orange,
                onTap:
                    controller.logout,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // SECTION TITLE
  // ===============================================================

  Widget _sectionTitle(
    BuildContext context,
    String title,
  ) {
    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final primaryColor = isDark
        ? AppColors.darkPrimary
        : AppColors.primary;

    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: AppTextStyles.labelLarge.copyWith(
          color: primaryColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}