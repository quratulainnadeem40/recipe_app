import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

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
        : AppColors.background;

    final headingColor = isDark
        ? AppColors.textWhite
        : AppColors.primary;

    final bodyColor = isDark
        ? AppColors.textWhite.withOpacity(0.85)
        : AppColors.textPrimary;

    final secondaryColor = isDark
        ? AppColors.textWhite.withOpacity(0.65)
        : AppColors.textSecondary;

    final appBarColor = isDark
        ? AppColors.darkBackground
        : AppColors.background;

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
              ? AppColors.textWhite
              : AppColors.primary,
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
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===================================================
            // TERMS & CONDITIONS
            // ===================================================

            _title(
              context,
              'Terms & Conditions',
            ),

            _paragraph(
              context,
              'Welcome to COOKmate. By using this application, '
              'you agree to these Terms & Conditions. Please read '
              'them carefully before using the application.',
            ),

            // ===================================================
            // USE OF THE APPLICATION
            // ===================================================

            _title(
              context,
              'Use of the Application',
            ),

            _paragraph(
              context,
              'COOKmate provides recipe-related content and features '
              'for personal and informational use. You agree to use '
              'the application responsibly and in accordance with '
              'applicable laws.',
            ),

            // ===================================================
            // USER ACCOUNTS
            // ===================================================

            _title(
              context,
              'User Accounts',
            ),

            _paragraph(
              context,
              'You are responsible for maintaining the security of '
              'your account and for the activity performed through '
              'your account. You should provide accurate information '
              'when creating or updating your account.',
            ),

            // ===================================================
            // RECIPE CONTENT
            // ===================================================

            _title(
              context,
              'Recipe Content',
            ),

            _paragraph(
              context,
              'Recipe information displayed in COOKmate may come from '
              'third-party or open-source recipe services. COOKmate '
              'does not guarantee that every recipe is accurate, '
              'complete, or suitable for every user.',
            ),

            // ===================================================
            // USER RESPONSIBILITY
            // ===================================================

            _title(
              context,
              'User Responsibility',
            ),

            _paragraph(
              context,
              'Users are responsible for checking recipe ingredients, '
              'preparation instructions, allergies, dietary requirements, '
              'and food-safety considerations before preparing or '
              'consuming any recipe.',
            ),

            // ===================================================
            // INTELLECTUAL PROPERTY
            // ===================================================

            _title(
              context,
              'Intellectual Property',
            ),

            _paragraph(
              context,
              'The COOKmate application, including its original design, '
              'branding, and application code, may be protected by '
              'applicable intellectual-property laws. Third-party '
              'content remains subject to its respective licenses '
              'and ownership rights.',
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
              'COOKmate may use third-party services to provide certain '
              'features, including authentication, storage, and recipe '
              'data. Your use of those services may also be subject to '
              'their respective terms and policies.',
            ),

            // ===================================================
            // ACCOUNT TERMINATION
            // ===================================================

            _title(
              context,
              'Account Termination',
            ),

            _paragraph(
              context,
              'You may stop using COOKmate at any time. COOKmate may '
              'restrict or terminate access when necessary to protect '
              'the application, its users, or its services.',
            ),

            // ===================================================
            // CHANGES TO THESE TERMS
            // ===================================================

            _title(
              context,
              'Changes to These Terms',
            ),

            _paragraph(
              context,
              'These Terms & Conditions may be updated from time to '
              'time. Continued use of COOKmate after changes are '
              'published means that you accept the updated terms.',
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
              'If you have questions about these Terms & Conditions, '
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
        ? AppColors.textWhite
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
        ? AppColors.textWhite.withOpacity(0.85)
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