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

    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    // =========================================================
    // COLORS
    // =========================================================

    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.background;

    final appBarColor = isDark
        ? AppColors.darkBackground
        : AppColors.background;

    final headingColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.primary;

    final bodyColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    final secondaryColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

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
        surfaceTintColor: Colors.transparent,

        iconTheme: IconThemeData(
          color: isDark
              ? AppColors.darkTextPrimary
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

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            30,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              // =================================================
              // INTRODUCTION
              // =================================================

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

              // =================================================
              // INFORMATION WE COLLECT
              // =================================================

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

              // =================================================
              // HOW WE USE INFORMATION
              // =================================================

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

              // =================================================
              // ACCOUNT INFORMATION
              // =================================================

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

              // =================================================
              // DATA SECURITY
              // =================================================

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

              // =================================================
              // THIRD-PARTY SERVICES
              // =================================================

              _title(
                context,
                'Third-Party Services',
              ),

              _paragraph(
                context,
                'COOKmate stores your preferences and bookmarks locally on '
                'your device to deliver a fast and private recipe experience.',
              ),

              // =================================================
              // CHANGES
              // =================================================

              _title(
                context,
                'Changes to This Policy',
              ),

              _paragraph(
                context,
                'This Privacy Policy may be updated from time to time. '
                'Any changes will be reflected on this page.',
              ),

              // =================================================
              // CONTACT
              // =================================================

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

              // =================================================
              // LAST UPDATED
              // =================================================

              Text(
                'Last updated: August 2026',
                style: AppTextStyles.bodySmall.copyWith(
                  color: secondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
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
        Theme.of(context).brightness ==
            Brightness.dark;

    final headingColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(
        top: 22,
        bottom: 9,
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
        Theme.of(context).brightness ==
            Brightness.dark;

    final bodyColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textPrimary;

    return Text(
      text,

      style: AppTextStyles.bodyMedium.copyWith(
        color: bodyColor,
        height: 1.6,
      ),
    );
  }
}