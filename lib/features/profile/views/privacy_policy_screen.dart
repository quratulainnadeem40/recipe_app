import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
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
            _title('Privacy Policy'),

            _paragraph(
              'Your privacy is important to us. This Privacy Policy '
              'explains how COOKmate handles information when you use '
              'the application.',
            ),

            _title('Information We Collect'),

            _paragraph(
              'COOKmate may collect information such as your name, '
              'email address, account information, and information '
              'you provide while using the application.',
            ),

            _title('How We Use Information'),

            _paragraph(
              'Information may be used to provide and improve the '
              'application, manage your account, provide personalized '
              'features, and maintain application security.',
            ),

            _title('Account Information'),

            _paragraph(
              'Your account information is used to authenticate you '
              'and provide access to features associated with your '
              'COOKmate account.',
            ),

            _title('Data Security'),

            _paragraph(
              'We take reasonable measures to protect information '
              'associated with your account. However, no method of '
              'electronic storage or transmission can be guaranteed '
              'to be completely secure.',
            ),

            _title('Third-Party Services'),

            _paragraph(
              'COOKmate may use third-party services such as Firebase '
              'to provide authentication and application services. '
              'Those services may process information according to '
              'their own privacy policies.',
            ),

            _title('Changes to This Policy'),

            _paragraph(
              'This Privacy Policy may be updated from time to time. '
              'Any changes will be reflected on this page.',
            ),

            _title('Contact'),

            _paragraph(
              'If you have questions about this Privacy Policy, '
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

