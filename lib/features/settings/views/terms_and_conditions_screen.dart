import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

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
          'Terms & Conditions',
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
              _title(context, '1. Acceptance of Terms'),
              _paragraph(
                context,
                'By downloading, accessing, or using COOKmate, you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use the application.',
              ),
              _title(context, '2. Use of the App'),
              _paragraph(
                context,
                'COOKmate is provided for your personal and non-commercial culinary exploration. You agree to use the application in compliance with all applicable laws and regulations.',
              ),
              _title(context, '3. Recipe Content & Intellectual Property'),
              _paragraph(
                context,
                'All recipe content, images, trademarks, and user interfaces are the intellectual property of their respective owners. Content is provided for educational and personal cooking inspiration.',
              ),
              _title(context, '4. Disclaimer of Warranties'),
              _paragraph(
                context,
                'The recipes, cooking instructions, and nutritional information are provided on an "as-is" and "as-available" basis. Always take standard safety and dietary precautions when preparing food.',
              ),
              _title(context, '5. Changes to Terms'),
              _paragraph(
                context,
                'We reserve the right to modify these Terms and Conditions at any time. Continued use of the app constitutes acceptance of any updated terms.',
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
