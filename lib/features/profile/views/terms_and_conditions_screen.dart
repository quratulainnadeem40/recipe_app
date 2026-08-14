import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms & Conditions',
          style: AppTextStyles.headingMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title('Terms & Conditions'),

            _paragraph(
              'Welcome to COOKmate. By using this application, '
              'you agree to these Terms & Conditions. Please read '
              'them carefully before using the application.',
            ),

            _title('Use of the Application'),

            _paragraph(
              'COOKmate provides recipe-related content and features '
              'for personal and informational use. You agree to use '
              'the application responsibly and in accordance with '
              'applicable laws.',
            ),

            _title('User Accounts'),

            _paragraph(
              'You are responsible for maintaining the security of '
              'your account and for the activity performed through '
              'your account. You should provide accurate information '
              'when creating or updating your account.',
            ),

            _title('Recipe Content'),

            _paragraph(
              'Recipe information displayed in COOKmate may come from '
              'third-party or open-source recipe services. COOKmate '
              'does not guarantee that every recipe is accurate, '
              'complete, or suitable for every user.',
            ),

            _title('User Responsibility'),

            _paragraph(
              'Users are responsible for checking recipe ingredients, '
              'preparation instructions, allergies, dietary requirements, '
              'and food-safety considerations before preparing or '
              'consuming any recipe.',
            ),

            _title('Intellectual Property'),

            _paragraph(
              'The COOKmate application, including its original design, '
              'branding, and application code, may be protected by '
              'applicable intellectual-property laws. Third-party '
              'content remains subject to its respective licenses '
              'and ownership rights.',
            ),

            _title('Third-Party Services'),

            _paragraph(
              'COOKmate may use third-party services to provide certain '
              'features, including authentication, storage, and recipe '
              'data. Your use of those services may also be subject to '
              'their respective terms and policies.',
            ),

            _title('Account Termination'),

            _paragraph(
              'You may stop using COOKmate at any time. COOKmate may '
              'restrict or terminate access when necessary to protect '
              'the application, its users, or its services.',
            ),

            _title('Changes to These Terms'),

            _paragraph(
              'These Terms & Conditions may be updated from time to '
              'time. Continued use of COOKmate after changes are '
              'published means that you accept the updated terms.',
            ),

            _title('Contact'),

            _paragraph(
              'If you have questions about these Terms & Conditions, '
              'please contact the COOKmate development team.',
            ),

            const SizedBox(height: 20),

            Text(
              'Last updated: August 2026',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 8,
      ),
      child: Text(
        title,
        style: AppTextStyles.headingSmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _paragraph(String text) {
    return Text(
      text,
      style: AppTextStyles.bodyMedium,
    );
  }
}

