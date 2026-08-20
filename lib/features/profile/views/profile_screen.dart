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
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    // ============================================================
    // THEME COLORS
    // ============================================================

    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.background;

    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final primaryText = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    final secondaryText = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.border;

    // Soft maroon for selected/brand areas
    final softPrimaryColor = isDark
        ? AppColors.primary.withValues(alpha: 0.14)
        : AppColors.primaryLight;

    return Scaffold(
      backgroundColor: backgroundColor,

      // ==========================================================
      // APP BAR
      // ==========================================================

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,

        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,

        iconTheme: IconThemeData(
          color: primaryText,
        ),

        title: Text(
          'My Profile',
          style: AppTextStyles.headingMedium.copyWith(
            color: primaryText,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      // ==========================================================
      // BODY
      // ==========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====================================================
              // PROFILE HEADER
              // ====================================================

              Obx(
                () => ProfileHeader(
                  name:
                      controller.user.value?.name ??
                          'COOKmate User',

                  email:
                      controller.user.value?.email ?? '',

                  profileImageBytes:
                      controller.profileImageBytes.value,

                  onImageTap:
                      controller.pickProfileImage,
                ),
              ),

              const SizedBox(height: 30),

              // ====================================================
              // ACCOUNT
              // ====================================================

              _sectionTitle(
                'Account',
                primaryText,
              ),

              const SizedBox(height: 10),

              _buildProfileOption(
                context,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
                softPrimaryColor: softPrimaryColor,
                icon: Icons.person_outline_rounded,
                title: 'Account Settings',
                subtitle: 'Manage your account information',
                onTap: () {
                  Get.toNamed(
                    AppRoutes.accountSettings,
                  );
                },
              ),

              const SizedBox(height: 22),

              // ====================================================
              // APPEARANCE
              // ====================================================

              _sectionTitle(
                'Appearance',
                primaryText,
              ),

              const SizedBox(height: 10),

              _buildThemeOption(
                context,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
                softPrimaryColor: softPrimaryColor,
              ),

              const SizedBox(height: 22),

              // ====================================================
              // INFORMATION
              // ====================================================

              _sectionTitle(
                'Information',
                primaryText,
              ),

              const SizedBox(height: 10),

              _buildProfileOption(
                context,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
                softPrimaryColor: softPrimaryColor,
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                onTap: () {
                  Get.toNamed(
                    AppRoutes.privacyPolicy,
                  );
                },
              ),

              const SizedBox(height: 8),

              _buildProfileOption(
                context,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
                softPrimaryColor: softPrimaryColor,
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                subtitle: 'Review terms and conditions',
                onTap: () {
                  Get.toNamed(
                    AppRoutes.termsAndConditions,
                  );
                },
              ),

              const SizedBox(height: 8),

              _buildProfileOption(
                context,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
                softPrimaryColor: softPrimaryColor,
                icon: Icons.feedback_outlined,
                title: 'Feedback',
                subtitle: 'Share your thoughts with us',
                onTap: () {
                  Get.toNamed(
                    AppRoutes.feedback,
                  );
                },
              ),

              const SizedBox(height: 22),

              // ====================================================
              // ACCOUNT ACTIONS
              // ====================================================

              _sectionTitle(
                'Account Actions',
                primaryText,
              ),

              const SizedBox(height: 10),

              _buildProfileOption(
                context,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
                softPrimaryColor: softPrimaryColor,
                icon: Icons.delete_outline_rounded,
                title: 'Delete Account',
                subtitle: 'Permanently delete your account',
                iconColor: AppColors.error,
                onTap: controller.deleteAccount,
              ),

              const SizedBox(height: 8),

              _buildProfileOption(
                context,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
                softPrimaryColor: softPrimaryColor,
                icon: Icons.logout_rounded,
                title: 'Logout',
                subtitle: 'Sign out from your account',
                iconColor: AppColors.primary,
                onTap: controller.logout,
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // SECTION TITLE
  // ================================================================

  Widget _sectionTitle(
    String title,
    Color primaryText,
  ) {
    return Text(
      title,
      style: AppTextStyles.labelLarge.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
      ),
    );
  }

  // ================================================================
  // PROFILE OPTION
  // ================================================================

  Widget _buildProfileOption(
    BuildContext context, {
    required Color surfaceColor,
    required Color borderColor,
    required Color primaryText,
    required Color secondaryText,
    required Color softPrimaryColor,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    final finalIconColor =
        iconColor ?? AppColors.primary;

    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(17),

        splashColor:
            AppColors.primary.withValues(alpha: 0.08),

        highlightColor:
            AppColors.primary.withValues(alpha: 0.04),

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),

          decoration: BoxDecoration(
            color: surfaceColor,

            borderRadius:
                BorderRadius.circular(17),

            border: Border.all(
              color: borderColor,
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: Theme.of(context).brightness ==
                          Brightness.dark
                      ? 0.12
                      : 0.04,
                ),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child: Row(
            children: [
              // ==================================================
              // ICON
              // ==================================================

              Container(
                width: 45,
                height: 45,

                decoration: BoxDecoration(
                  color: iconColor == AppColors.error
                      ? AppColors.error.withValues(
                          alpha: 0.10,
                        )
                      : softPrimaryColor,

                  borderRadius:
                      BorderRadius.circular(13),
                ),

                child: Icon(
                  icon,

                  size: 22,

                  color: finalIconColor,
                ),
              ),

              const SizedBox(width: 13),

              // ==================================================
              // TEXT
              // ==================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,

                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,

                      style: TextStyle(
                        color: primaryText,
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,

                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,

                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 11,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // ==================================================
              // ARROW
              // ==================================================

              Icon(
                Icons.arrow_forward_ios_rounded,

                size: 15,

                color: secondaryText.withValues(
                  alpha: 0.55,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // THEME OPTION
  // ================================================================

  Widget _buildThemeOption(
    BuildContext context, {
    required Color surfaceColor,
    required Color borderColor,
    required Color primaryText,
    required Color secondaryText,
    required Color softPrimaryColor,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color: surfaceColor,

        borderRadius:
            BorderRadius.circular(17),

        border: Border.all(
          color: borderColor,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: Theme.of(context).brightness ==
                      Brightness.dark
                  ? 0.12
                  : 0.04,
            ),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          // ======================================================
          // THEME ICON
          // ======================================================

          Container(
            width: 45,
            height: 45,

            decoration: BoxDecoration(
              color: softPrimaryColor,
              borderRadius:
                  BorderRadius.circular(13),
            ),

            child: Icon(
              Theme.of(context).brightness ==
                      Brightness.dark
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,

              size: 22,

              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 13),

          // ======================================================
          // THEME TEXT
          // ======================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  'Dark Mode',

                  style: TextStyle(
                    color: primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Obx(
                  () => Text(
                    controller.isDarkMode.value
                        ? 'Dark appearance enabled'
                        : 'Light appearance enabled',

                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,

                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ======================================================
          // SWITCH
          // ======================================================

          Obx(
            () => Switch(
              value:
                  controller.isDarkMode.value,

              onChanged:
                  controller.toggleTheme,

              activeColor:
                  AppColors.primary,

              activeTrackColor:
                  AppColors.primary.withValues(
                alpha: 0.35,
              ),

              inactiveThumbColor:
                  secondaryText,

              inactiveTrackColor:
                  borderColor,

              trackOutlineColor:
                  WidgetStateProperty.all(
                Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}