import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/core/theme/app_text_styles.dart';
import 'package:recipe_app/features/on_boarding/controllers/onboarding_screen1_controller.dart';

class OnboardingScreen1 extends GetView<OnboardingController> {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.darkBackground,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Column(
              children: [
                // ==========================================
                // TOP BAR
                // ==========================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.white,
                      ),
                    ),

                    TextButton(
                      onPressed: controller.skipOnboarding,
                      child: Text(
                        'Skip',
                        style:
                            AppTextStyles.labelMedium.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                // ==========================================
                // IMAGE
                // ==========================================

                Expanded(
                  flex: 6,
                  child: Image.asset(
                    'assets/onboradindimage.jpeg',
                    fit: BoxFit.contain,
                  ),
                ),

                // ==========================================
                // HEADING
                // ==========================================

                Text(
                  'Explore Thousands\nof Recipes',
                  textAlign: TextAlign.center,
                  style:
                      AppTextStyles.headingLarge.copyWith(
                    color: AppColors.white,
                    fontSize: 30,
                    height: 1.15,
                  ),
                ),

                const SizedBox(height: 14),

                // ==========================================
                // DESCRIPTION
                // ==========================================

                Text(
                  'Find easy and delicious recipes\n'
                  'for every mood and occasion.',
                  textAlign: TextAlign.center,
                  style:
                      AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondaryDark,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 22),

                // ==========================================
                // PAGE INDICATOR
                // ==========================================

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _dot(true),
                    _dot(false),
                    _dot(false),
                  ],
                ),

                const SizedBox(height: 24),

                // ==========================================
                // NEXT BUTTON
                // ==========================================

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: controller.nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: AppTextStyles.button,
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _dot(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: active ? 30 : 9,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: active
            ? AppColors.orange
            : AppColors.white.withValues(alpha: 0.30),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}