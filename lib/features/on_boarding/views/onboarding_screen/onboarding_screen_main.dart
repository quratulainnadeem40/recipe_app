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
      body: Stack(
        children: [
          // ==============================
          // ONBOARDING PAGES
          // ==============================

          PageView(
            controller: controller.pageController,
            physics: const NeverScrollableScrollPhysics(),
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

          // ==============================
          // SKIP BUTTON
          // ==============================

          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 30,
            child: TextButton(
              onPressed: controller.skip,
              child: Text(
                'Skip',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primaryDark,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: MediaQuery.of(context).padding.bottom + 30,
            child: Obx(
              () => GestureDetector(
                onTap: controller.nextPage,
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    controller.currentPage.value == 2
                        ? Icons.check
                        : Icons.arrow_forward,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
      
        ],
      ),
    );
  }
}