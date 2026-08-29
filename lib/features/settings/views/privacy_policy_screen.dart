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

    final appBarColor =
        isDark ? AppColors.darkBackground : AppColors.background;

    final headingColor =
        isDark ? AppColors.darkTextPrimary : AppColors.primary;

    final secondaryColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: appBarColor,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.darkTextPrimary : AppColors.primary,
        ),
        title: Text(
          'Privacy Policy',
          style: AppTextStyles.headingMedium.copyWith(
            color: headingColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title(context, 'Privacy Policy'),
              _paragraph(
                context,
                'Your privacy is important to us. This Privacy Policy explains how COOKmate handles information when you use the application.',
              ),
              _title(context, 'Information We Collect'),
              _paragraph(
                context,
                'COOKmate operates locally and prioritizes user privacy. Saved favorite recipes, preferred theme settings, and customized chef names are stored locally on your device.',
              ),
              _title(context, 'How We Use Information'),
              _paragraph(
                context,
                'We use locally stored preferences solely to provide and improve your experience, such as saving your bookmarked recipes and remembering your preferred appearance mode.',
              ),
              _title(context, 'Data Security'),
              _paragraph(
                context,
                'We implement appropriate security measures to safeguard your local preferences and data stored on your device.',
              ),
              _title(context, 'Contact Us'),
              _paragraph(
                context,
                'If you have any questions or feedback regarding this Privacy Policy, please reach out via the Feedback section in the app.',
              ),
              const SizedBox(height: 20),
              Text(
                'Last Updated: August 2026',
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Text(
        text,
        style: AppTextStyles.headingSmall.copyWith(
          color: isDark ? AppColors.darkTextPrimary : AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _paragraph(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          height: 1.5,
        ),
      ),
    );
  }
}
