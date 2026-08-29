import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/routes/app_routes.dart';
import 'package:recipe_app/features/navigation/controllers/navigation_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/settings_controller.dart';
import 'widgets/settings_option_tile.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor =
        isDark ? AppColors.darkBackground : AppColors.background;

    final surfaceColor =
        isDark ? AppColors.darkSurface : AppColors.surface;

    final primaryText =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    final secondaryText =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final borderColor =
        isDark ? AppColors.darkBorder : AppColors.border;

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
        iconTheme: IconThemeData(color: primaryText),
        title: Text(
          'Settings',
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
            vertical: 14,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 780),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ====================================================
                  // 1. PREFERENCES (APPEARANCE & NOTIFICATIONS)
                  // ====================================================

              _sectionTitle('Preferences'),
              const SizedBox(height: 10),

              _buildThemeOption(
                context,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
                softPrimaryColor: softPrimaryColor,
              ),

              const SizedBox(height: 10),

              _buildNotificationOption(
                context,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
                softPrimaryColor: softPrimaryColor,
              ),

              const SizedBox(height: 26),

              // ====================================================
              // 2. RECIPES & SHORTCUTS
              // ====================================================
              _sectionTitle('My Collection'),
              const SizedBox(height: 10),

              SettingsOptionTile(
                icon: Icons.favorite_rounded,
                title: 'Saved Favorites',
                subtitle: 'Quickly access your bookmarked recipes',
                onTap: () {
                  if (Get.isRegistered<NavigationController>()) {
                    Get.find<NavigationController>().changePage(2);
                  } else {
                    Get.toNamed(AppRoutes.favorites);
                  }
                },
              ),

              const SizedBox(height: 26),

              // ====================================================
              // 3. HELP & SUPPORT
              // ====================================================
              _sectionTitle('Support & Legal'),
              const SizedBox(height: 10),

              SettingsOptionTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy & data practices',
                onTap: () => Get.toNamed(AppRoutes.privacyPolicy),
              ),

              const SizedBox(height: 10),

              SettingsOptionTile(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                subtitle: 'Review terms and service agreement',
                onTap: () => Get.toNamed(AppRoutes.termsAndConditions),
              ),

              const SizedBox(height: 10),

              SettingsOptionTile(
                icon: Icons.info_outline_rounded,
                title: 'About COOKmate',
                subtitle: 'Version 1.0.0 • Recipe Explorer App',
                onTap: () => _showAboutDialog(context),
              ),

              const SizedBox(height: 26),

              // ====================================================
              // 4. DATA & STORAGE MANAGEMENT
              // ====================================================
              _sectionTitle('Data & Storage'),
              const SizedBox(height: 10),

              SettingsOptionTile(
                icon: Icons.delete_sweep_outlined,
                title: 'Clear Saved Favorites',
                subtitle: 'Remove all recipes saved in favorites',
                iconColor: AppColors.error,
                onTap: controller.clearFavorites,
              ),

              const SizedBox(height: 10),

              SettingsOptionTile(
                icon: Icons.restart_alt_rounded,
                title: 'Reset All App Data',
                subtitle: 'Restore settings and clear cached data',
                iconColor: AppColors.error,
                onTap: controller.resetLocalData,
              ),

              const SizedBox(height: 36),

              // ====================================================
              // 5. FOOTER BRANDING
              // ====================================================
              Center(
                child: Column(
                  children: [
                    Text(
                      'COOKmate v1.0.0',
                      style: TextStyle(
                        color: secondaryText.withValues(alpha: 0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Made with ❤️ for food lovers',
                      style: TextStyle(
                        color: secondaryText.withValues(alpha: 0.6),
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    ),
  ),
);

  }

  // ================================================================
  // SECTION TITLE
  // ================================================================
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.labelLarge.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w800,
        fontSize: 13.5,
        letterSpacing: 0.3,
      ),
    );
  }

  // ================================================================
  // THEME SWITCH OPTION
  // ================================================================
  Widget _buildThemeOption(
    BuildContext context, {
    required Color surfaceColor,
    required Color borderColor,
    required Color primaryText,
    required Color secondaryText,
    required Color softPrimaryColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: softPrimaryColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              size: 22,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dark Appearance',
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Obx(
                  () => Text(
                    controller.isDarkMode.value
                        ? 'Dark theme is currently active'
                        : 'Light theme is currently active',
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => Switch(
              value: controller.isDarkMode.value,
              onChanged: controller.toggleTheme,
              activeThumbColor: AppColors.primary,
              activeTrackColor: AppColors.primary.withValues(alpha: 0.35),
              inactiveThumbColor: secondaryText,
              inactiveTrackColor: borderColor,
              trackOutlineColor:
                  WidgetStateProperty.all(Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // NOTIFICATIONS SWITCH OPTION
  // ================================================================
  Widget _buildNotificationOption(
    BuildContext context, {
    required Color surfaceColor,
    required Color borderColor,
    required Color primaryText,
    required Color secondaryText,
    required Color softPrimaryColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: softPrimaryColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.notifications_active_outlined,
              size: 22,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Push Notifications',
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Obx(
                  () => Text(
                    controller.isNotificationsEnabled.value
                        ? 'Recipe alerts & tips enabled'
                        : 'Notifications are silenced',
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => Switch(
              value: controller.isNotificationsEnabled.value,
              onChanged: controller.toggleNotifications,
              activeThumbColor: AppColors.primary,
              activeTrackColor: AppColors.primary.withValues(alpha: 0.35),
              inactiveThumbColor: secondaryText,
              inactiveTrackColor: borderColor,
              trackOutlineColor:
                  WidgetStateProperty.all(Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // ABOUT COOKMATE DIALOG
  // ================================================================
  void _showAboutDialog(BuildContext context) {
    Get.dialog(
      AboutDialog(
        applicationName: 'COOKmate',
        applicationVersion: '1.0.0',
        applicationIcon: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.restaurant_menu_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        children: const [
          SizedBox(height: 10),
          Text(
            'COOKmate is your modern digital recipe companion, built for seamless culinary exploration with curated cuisines, instant search, and step-by-step cooking inspiration.',
          ),
        ],
      ),
    );
  }
}

