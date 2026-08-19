import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/core/theme/app_text_styles.dart';

import 'package:recipe_app/features/on_boarding/controllers/onboarding_controller.dart';

import 'onboarding_screen_1.dart';
import 'onboarding_screen_2.dart';
import 'onboarding_screen_3.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [

            // ==============================
            // SKIP
            // ==============================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),

              child: Align(
                alignment: Alignment.centerRight,

                child: Obx(
                  () {
                    if (controller.currentPage.value == 2) {
                      return const SizedBox(
                        height: 48,
                      );
                    }

                    return TextButton(
                      onPressed: controller.skip,

                      child: Text(
                        'Skip',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ==============================
            // PAGE VIEW
            // ==============================

            Expanded(
              child: PageView(
                controller: controller.pageController,

                onPageChanged: controller.changePage,

                children: [
  Onboarding1(
    model: controller.onboardingPages[0],
  ),

  Onboarding2(
    model: controller.onboardingPages[1],
  ),

  Onboarding3(
    model: controller.onboardingPages[2],
  ),
],
              ),
            ),

            // ==============================
            // DOTS
            // ==============================

            Obx(
              () {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: List.generate(
                    3,
                    (index) {
                      final selected =
                          controller.currentPage.value == index;

                      return AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 250,
                        ),

                        margin: const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),

                        height: 8,

                        width: selected ? 24 : 8,

                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary
                              : AppColors.surface,

                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // ==============================
            // NEXT / GET STARTED
            // ==============================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),

              child: SizedBox(
                width: double.infinity,
                height: 54,

                child: Obx(
                  () {
                    final isLastPage =
                        controller.currentPage.value == 2;

                    return ElevatedButton(
                      onPressed: controller.nextPage,

                      child: Text(
                        isLastPage
                            ? 'Get Started'
                            : 'Next',
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}