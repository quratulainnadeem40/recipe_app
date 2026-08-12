import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/core/theme/app_text_styles.dart';
import 'package:recipe_app/features/splash/controllers/splash_controller.dart';


class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primary,

      body: Stack(
        fit: StackFit.expand,
        children: [

          // =====================================================
          // BACKGROUND IMAGE
          // =====================================================

          Image.asset(
           "assets/image.png",
            fit: BoxFit.cover,
          ),

          // =====================================================
          // COOKMATE TEXT
          // =====================================================

          Positioned(
            top: screenHeight * 0.505,
            left: 0,
            right: 0,

            child: Center(
              child: RichText(
                textAlign: TextAlign.center,

                text: TextSpan(
                  children: [

                    // COOK
                    TextSpan(
                      text: 'Cook',
                      style: AppTextStyles.headingLarge.copyWith(
                        fontSize: 58,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: AppColors.white,
                        shadows: const [
                          Shadow(
                            color: AppColors.black,
                            blurRadius: 4,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                    ),

                    // MATE
                    TextSpan(
                      text: 'mate',
                      style: AppTextStyles.headingLarge.copyWith(
                        fontSize: 58,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: AppColors.orange,
                        shadows: const [
                          Shadow(
                            color: AppColors.black,
                            blurRadius: 4,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // =====================================================
          // TAGLINE
          // =====================================================

          Positioned(
            top: screenHeight * 0.705,
            left: 0,
            right: 0,

            child: Center(
              child: Text(
                'COOK  •  SHARE  •  INSPIRE',

                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 3.0,
                ),
              ),
            ),
          ),

          // =====================================================
          // LOADING INDICATOR
          // =====================================================

          Positioned(
            bottom: screenHeight * 0.075,
            left: 0,
            right: 0,

            child: const Center(
              child: SizedBox(
                width: 25,
                height: 25,

                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.orange,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}