import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // =========================================================
    // THEME COLORS
    // =========================================================

    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.background;

    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.border;

    final headingColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.primary;

    return Scaffold(
      backgroundColor: backgroundColor,

      // =======================================================
      // APP BAR
      // =======================================================

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,

        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,

        iconTheme: IconThemeData(
          color: primaryTextColor,
        ),

        title: Text(
          'Terms & Conditions',
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
        padding: const EdgeInsets.fromLTRB(
          20,
          8,
          20,
          30,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===================================================
            // TERMS & CONDITIONS
            // ===================================================

            _title(
              'Terms & Conditions',
              headingColor,
            ),

            _paragraph(
              'Welcome to COOKmate. By using this application, '
              'you agree to these Terms & Conditions. Please read '
              'them carefully before using the application.',
              primaryTextColor,
            ),

            // ===================================================
            // USE OF THE APPLICATION
            // ===================================================

            _title(
              'Use of the Application',
              headingColor,
            ),

            _paragraph(
              'COOKmate provides recipe-related content and features '
              'for personal and informational use. You agree to use '
              'the application responsibly and in accordance with '
              'applicable laws.',
              primaryTextColor,
            ),

            // ===================================================
            // USER ACCOUNTS
            // ===================================================

            _title(
              'User Accounts',
              headingColor,
            ),

            _paragraph(
              'You are responsible for maintaining the security of '
              'your account and for the activity performed through '
              'your account. You should provide accurate information '
              'when creating or updating your account.',
              primaryTextColor,
            ),

            // ===================================================
            // RECIPE CONTENT
            // ===================================================

            _title(
              'Recipe Content',
              headingColor,
            ),

            _paragraph(
              'Recipe information displayed in COOKmate may come from '
              'third-party or open-source recipe services. COOKmate '
              'does not guarantee that every recipe is accurate, '
              'complete, or suitable for every user.',
              primaryTextColor,
            ),

            // ===================================================
            // USER RESPONSIBILITY
            // ===================================================

            _title(
              'User Responsibility',
              headingColor,
            ),

            _paragraph(
              'Users are responsible for checking recipe ingredients, '
              'preparation instructions, allergies, dietary requirements, '
              'and food-safety considerations before preparing or '
              'consuming any recipe.',
              primaryTextColor,
            ),

            // ===================================================
            // INTELLECTUAL PROPERTY
            // ===================================================

            _title(
              'Intellectual Property',
              headingColor,
            ),

            _paragraph(
              'The COOKmate application, including its original design, '
              'branding, and application code, may be protected by '
              'applicable intellectual-property laws. Third-party '
              'content remains subject to its respective licenses '
              'and ownership rights.',
              primaryTextColor,
            ),

            // ===================================================
            // THIRD-PARTY SERVICES
            // ===================================================

            _title(
              'Third-Party Services',
              headingColor,
            ),

            _paragraph(
              'COOKmate may use third-party API services to provide recipe '
              'and culinary data. Your use of those services may also be subject to '
              'their respective terms and policies.',
              primaryTextColor,
            ),

            // ===================================================
            // ACCOUNT TERMINATION
            // ===================================================

            _title(
              'Account Termination',
              headingColor,
            ),

            _paragraph(
              'You may stop using COOKmate at any time. COOKmate may '
              'restrict or terminate access when necessary to protect '
              'the application, its users, or its services.',
              primaryTextColor,
            ),

            // ===================================================
            // CHANGES TO THESE TERMS
            // ===================================================

            _title(
              'Changes to These Terms',
              headingColor,
            ),

            _paragraph(
              'These Terms & Conditions may be updated from time to '
              'time. Continued use of COOKmate after changes are '
              'published means that you accept the updated terms.',
              primaryTextColor,
            ),

            // ===================================================
            // CONTACT
            // ===================================================

            _title(
              'Contact',
              headingColor,
            ),

            _paragraph(
              'If you have questions about these Terms & Conditions, '
              'please contact the COOKmate development team.',
              primaryTextColor,
            ),

            const SizedBox(height: 20),

            // ===================================================
            // LAST UPDATED
            // ===================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurface
                    : AppColors.surface,

                borderRadius: BorderRadius.circular(12),

                border: Border.all(
                  color: borderColor,
                ),
              ),

              child: Text(
                'Last updated: August 2026',
                style: AppTextStyles.bodySmall.copyWith(
                  color: secondaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // SECTION TITLE
  // =============================================================

  Widget _title(
    String title,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 22,
        bottom: 8,
      ),

      child: Text(
        title,

        style: AppTextStyles.headingSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // =============================================================
  // PARAGRAPH
  // =============================================================

  Widget _paragraph(
    String text,
    Color color,
  ) {
    return Text(
      text,

      style: AppTextStyles.bodyMedium.copyWith(
        color: color,
        height: 1.6,
      ),
    );
  }
}