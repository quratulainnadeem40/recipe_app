import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/routes/app_routes.dart';
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
                  // 1. APPEARANCE / THEME
                  // ====================================================
                  _sectionHeader(
                    icon: Icons.palette_outlined,
                    title: 'Appearance',
                  ),
                  const SizedBox(height: 10),

                  _buildThemeCard(
                    context,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                    softPrimaryColor: softPrimaryColor,
                  ),

                  const SizedBox(height: 26),

                  // ====================================================
                  // 2. SUPPORT & LEGAL
                  // ====================================================
                  _sectionHeader(
                    icon: Icons.shield_outlined,
                    title: 'About & Policies',
                  ),
                  const SizedBox(height: 10),

                  SettingsOptionTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'Read our privacy policy & data practices',
                    onTap: () => Get.toNamed(AppRoutes.privacyPolicy),
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
                  _sectionHeader(
                    icon: Icons.storage_rounded,
                    title: 'Data & Storage',
                  ),
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

                  const SizedBox(height: 38),

                  // ====================================================
                  // 5. FOOTER BRANDING
                  // ====================================================
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.restaurant_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'COOKmate v1.0.0',
                          style: TextStyle(
                            color: primaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Made with ❤️ for food lovers worldwide',
                          style: TextStyle(
                            color: secondaryText.withValues(alpha: 0.7),
                            fontSize: 12,
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
  // SECTION HEADER WITH ICON
  // ================================================================
  Widget _sectionHeader({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: AppColors.primary,
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
            fontSize: 13.5,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  // ================================================================
  // THEME SWITCH CARD
  // ================================================================
  Widget _buildThemeCard(
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
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: softPrimaryColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              size: 24,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Obx(
                  () => Text(
                    controller.isDarkMode.value
                        ? 'Dark mode is currently active'
                        : 'Light mode is currently active',
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 12,
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
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.restaurant_menu_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        children: const [
          SizedBox(height: 12),
          Text(
            'COOKmate is your modern digital recipe companion, built for seamless culinary exploration with curated cuisines, instant search, and step-by-step cooking inspiration.',
            style: TextStyle(height: 1.4),
          ),
        ],
      ),
    );
  }
}
