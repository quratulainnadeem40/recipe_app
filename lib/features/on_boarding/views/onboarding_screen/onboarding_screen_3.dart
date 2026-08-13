import 'package:flutter/material.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/core/theme/app_text_styles.dart';
import 'package:recipe_app/features/on_boarding/models/onboarding_model.dart';

class Onboarding3 extends StatelessWidget {
  final OnboardingModel model;

  const Onboarding3({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Column(
        children: [
          // ==============================
          // IMAGE
          // ==============================

           Expanded(
            flex: 6,
            child: Center(
              child: Image.asset(
                model.image,
                fit: BoxFit.contain,
              ),
            ),
          ),
      

          // ==============================
          // TITLE
          // ==============================

          Text(
            model.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.headingLarge.copyWith(
              color: AppColors.primary,
              fontSize: 26,
            ),
          ),

          const SizedBox(height: 14),

          // ==============================
          // DESCRIPTION
          // ==============================

          Text(
            model.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}