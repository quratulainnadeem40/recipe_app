import 'package:flutter/material.dart';
import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/core/theme/app_text_styles.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Center(
              child: Image.asset(
               "assets/image1.png" ,
                width: size.width * 0.88,
                height: size.height * 0.48,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Text(
            'Discover Delicious Recipes',
            textAlign: TextAlign.center,
            style: AppTextStyles.headingLarge.copyWith(
              color: AppColors.primary,
              fontSize: 26,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            'Explore delicious recipes and discover new meals to make every day.',
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