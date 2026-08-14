import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/splash/controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primary,

      body: SizedBox.expand(
        child: Stack(
          children: [
            // ==============================
            // BACKGROUND IMAGE
            // ==============================

            Positioned(
              top: 0,
              bottom: 0,
              left: 0, // Side distance
              right: 0, // Side distance
              child: Image.asset(
                'assets/imagefolder/image.png',
                fit: BoxFit.contain,
              ),
            ),

            // ==============================
            // LOADING
            // ==============================

            Positioned(
              bottom: screenHeight * 0.075,
              left: 0,
              right: 0,
              child: Center(
                child: Obx(
                  () {
                    return SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        value: controller.progress.value,
                        strokeWidth: 2,
                        color: AppColors.orange,
                        backgroundColor:
                            AppColors.white.withOpacity(0.25),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}