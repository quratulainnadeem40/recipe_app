import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
        : AppColors.lightBackground;

    final headingColor = isDark
        ? Colors.white
        : AppColors.primary;

    final bodyColor = isDark
        ? Colors.white.withOpacity(0.85)
        : Colors.black87;

    final secondaryColor = isDark
        ? Colors.white.withOpacity(0.65)
        : AppColors.textSecondary;

    final appBarColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;

    // =========================================================
    // SCREEN
    // =========================================================

    return Scaffold(
      backgroundColor: backgroundColor,

      // =======================================================
      // APP BAR
      // =======================================================

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: appBarColor,

        iconTheme: IconThemeData(
          color: isDark
              ? Colors.white
              : AppColors.primary,
        ),

        title: Text(
          'Privacy Policy',
          style: AppTextStyles.headingMedium.copyWith(
            color: headingColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // =======================================================
      // BODY
      // =======================================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ===================================================
            // PRIVACY POLICY
            // ===================================================

            _title(
              context,
              'Privacy Policy',
            ),

            _paragraph(
              context,
              'Your privacy is important to us. This Privacy Policy '
              'explains how COOKmate handles information when you use '
              'the application.',
            ),

            // ===================================================
            // INFORMATION WE COLLECT
            // ===================================================

            _title(
              context,
              'Information We Collect',
            ),

            _paragraph(
              context,
              'COOKmate may collect information such as your name, '
              'email address, account information, and information '
              'you provide while using the application.',
            ),

            // ===================================================
            // HOW WE USE INFORMATION
            // ===================================================

            _title(
              context,
              'How We Use Information',
            ),

            _paragraph(
              context,
              'Information may be used to provide and improve the '
              'application, manage your account, provide personalized '
              'features, and maintain application security.',
            ),

            // ===================================================
            // ACCOUNT INFORMATION
            // ===================================================

            _title(
              context,
              'Account Information',
            ),

            _paragraph(
              context,
              'Your account information is used to authenticate you '
              'and provide access to features associated with your '
              'COOKmate account.',
            ),

            // ===================================================
            // DATA SECURITY
            // ===================================================

            _title(
              context,
              'Data Security',
            ),

            _paragraph(
              context,
              'We take reasonable measures to protect information '
              'associated with your account. However, no method of '
              'electronic storage or transmission can be guaranteed '
              'to be completely secure.',
            ),

            // ===================================================
            // THIRD-PARTY SERVICES
            // ===================================================

            _title(
              context,
              'Third-Party Services',
            ),

            _paragraph(
              context,
              'COOKmate may use third-party services such as Firebase '
              'to provide authentication and application services. '
              'Those services may process information according to '
              'their own privacy policies.',
            ),

            // ===================================================
            // CHANGES TO THIS POLICY
            // ===================================================

            _title(
              context,
              'Changes to This Policy',
            ),

            _paragraph(
              context,
              'This Privacy Policy may be updated from time to time. '
              'Any changes will be reflected on this page.',
            ),

            // ===================================================
            // CONTACT
            // ===================================================

            _title(
              context,
              'Contact',
            ),

            _paragraph(
              context,
              'If you have questions about this Privacy Policy, '
              'please contact the COOKmate development team.',
            ),

            const SizedBox(height: 20),

            // ===================================================
            // LAST UPDATED
            // ===================================================

            Text(
              'Last updated: August 2026',

              style: AppTextStyles.bodySmall.copyWith(
                color: secondaryColor,
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // SECTION TITLE
  // =============================================================

  Widget _title(
    BuildContext context,
    String title,
  ) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final headingColor = isDark
        ? Colors.white
        : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 8,
      ),

      child: Text(
        title,

        style: AppTextStyles.headingSmall.copyWith(
          color: headingColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // =============================================================
  // PARAGRAPH
  // =============================================================

  Widget _paragraph(
    BuildContext context,
    String text,
  ) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final bodyColor = isDark
        ? Colors.white.withOpacity(0.85)
        : Colors.black87;

    return Text(
      text,

      style: AppTextStyles.bodyMedium.copyWith(
        color: bodyColor,
        height: 1.6,
      ),
    );
  }
}