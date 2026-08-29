import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: primaryText),
        title: Text(
          'Privacy Policy',
          style: AppTextStyles.headingMedium.copyWith(
            color: primaryText,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ====================================================
                  // HEADER BRANDING & TRUST CARD
                  // ====================================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // App Logo with Shadow
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.25),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/images/recipe_logo.jpeg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: AppColors.primary,
                                child: const Icon(
                                  Icons.restaurant_menu_rounded,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'COOKmate Recipe App',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: primaryText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Official Privacy Policy & Data Transparency',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildBadge(
                              icon: Icons.verified_user_rounded,
                              label: '100% Privacy Friendly',
                              isDark: isDark,
                            ),
                            _buildBadge(
                              icon: Icons.phone_android_rounded,
                              label: 'On-Device Storage',
                              isDark: isDark,
                            ),
                            _buildBadge(
                              icon: Icons.no_accounts_rounded,
                              label: 'No Login Required',
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ====================================================
                  // KEY PRIVACY HIGHLIGHTS
                  // ====================================================
                  Text(
                    'Key Privacy Highlights',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: _buildHighlightCard(
                          icon: Icons.lock_outline_rounded,
                          title: 'No Data Sold',
                          subtitle: 'We never sell or monetize your personal information.',
                          surfaceColor: surfaceColor,
                          borderColor: borderColor,
                          primaryText: primaryText,
                          secondaryText: secondaryText,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildHighlightCard(
                          icon: Icons.cloud_off_rounded,
                          title: 'Local Storage',
                          subtitle: 'Favorites and theme preferences stay on your device.',
                          surfaceColor: surfaceColor,
                          borderColor: borderColor,
                          primaryText: primaryText,
                          secondaryText: secondaryText,
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ====================================================
                  // DETAILED SECTIONS
                  // ====================================================
                  _buildPolicySection(
                    icon: Icons.info_outline_rounded,
                    title: '1. Overview & Commitment',
                    content:
                        'COOKmate ("we", "our", or "the app") is committed to protecting your privacy. This policy outlines how information is collected, used, and safeguarded when you explore, search, and bookmark recipes using the COOKmate application.',
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                    isDark: isDark,
                  ),

                  _buildPolicySection(
                    icon: Icons.storage_rounded,
                    title: '2. Information We Store Locally',
                    content:
                        'COOKmate does NOT require you to create an account or provide personal identifiers (such as your name, email, or phone number).\n\n'
                        'The following preferences are saved strictly on your local device storage (via GetStorage):\n'
                        '• Bookmarked & Favorite Recipes\n'
                        '• Dark / Light Appearance Mode preference\n'
                        '• Custom Chef Name / Nickname\n'
                        '• Recent recipe searches for quick access',
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                    isDark: isDark,
                  ),

                  _buildPolicySection(
                    icon: Icons.wifi_rounded,
                    title: '3. Network & Internet Permissions',
                    content:
                        'The app requests the standard `android.permission.INTERNET` and `ACCESS_NETWORK_STATE` permissions solely for:\n'
                        '• Fetching recipe details, categories, and country cuisines from TheMealDB public REST API\n'
                        '• Loading recipe photos and food thumbnails\n\n'
                        'No background telemetry, silent device fingerprinting, or location tracking is performed.',
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                    isDark: isDark,
                  ),

                  _buildPolicySection(
                    icon: Icons.record_voice_over_rounded,
                    title: '4. Voice & Audio Guidance (TTS)',
                    content:
                        'COOKmate features an interactive Text-to-Speech (TTS) engine that reads cooking instructions step-by-step. The speech synthesis runs locally on your device using the native operating system speech engine. No microphone or audio recording is conducted.',
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                    isDark: isDark,
                  ),

                  _buildPolicySection(
                    icon: Icons.link_rounded,
                    title: '5. Third-Party Content & Links',
                    content:
                        'Recipes and videos may contain links to third-party services such as YouTube (for cooking tutorials) or TheMealDB API. We do not control and are not responsible for the privacy practices of external websites. We encourage you to review their respective privacy policies when visiting third-party links.',
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                    isDark: isDark,
                  ),

                  _buildPolicySection(
                    icon: Icons.child_care_rounded,
                    title: '6. Children’s Privacy',
                    content:
                        'COOKmate is family-friendly and suitable for users of all ages. We do not knowingly collect any personally identifiable information from children under 13 years of age, in full compliance with the Children’s Online Privacy Protection Act (COPPA) and Google Play Families Policy.',
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                    isDark: isDark,
                  ),

                  _buildPolicySection(
                    icon: Icons.delete_outline_rounded,
                    title: '7. Data Control & Deletion',
                    content:
                        'You have complete control over your data at all times. You can delete all your saved favorite recipes or completely reset local application settings at any time directly through Settings > Data & Storage > "Reset All App Data". Uninstalling the app also automatically removes all locally stored preferences.',
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                    isDark: isDark,
                  ),

                  _buildPolicySection(
                    icon: Icons.mail_outline_rounded,
                    title: '8. Contact & Policy Updates',
                    content:
                        'We may update this Privacy Policy from time to time to reflect improvements in our app features or regulatory changes. Any updates will be posted directly within the application.\n\n'
                        'If you have any questions, feedback, or inquiries regarding this Privacy Policy, please reach out to our team at:\n\n'
                        '📧 Official Support Email:\ninnovexa.technologies01@gmail.com',
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 6),

                  // Contact Support Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primary.withValues(alpha: 0.12)
                          : AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.headset_mic_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Need Help or Have Questions?',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: primaryText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const SelectableText(
                                'innovexa.technologies01@gmail.com',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ====================================================
                  // FOOTER METADATA
                  // ====================================================
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Last Updated & Effective Date: August 2026',
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: isDark ? 0.18 : 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color surfaceColor,
    required Color borderColor,
    required Color primaryText,
    required Color secondaryText,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              height: 1.35,
              color: secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicySection({
    required IconData icon,
    required String title,
    required String content,
    required Color surfaceColor,
    required Color borderColor,
    required Color primaryText,
    required Color secondaryText,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: primaryText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              height: 1.55,
              color: secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
