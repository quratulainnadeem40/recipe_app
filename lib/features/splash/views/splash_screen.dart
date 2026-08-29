import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/splash/controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ---------------------------------------------------------
    // FULL SCREEN SYSTEM UI
    // ---------------------------------------------------------

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,

        // Image has dark maroon areas.
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.primary,

      // -------------------------------------------------------
      // BODY
      // -------------------------------------------------------
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,

        child: SizedBox(
          width: double.infinity,
          height: double.infinity,

          child: Stack(
            fit: StackFit.expand,

            children: [
              // =================================================
              // SPLASH IMAGE
              // =================================================
              Image.asset(
                'assets/images/splash.jpeg',

                width: double.infinity,
                height: double.infinity,

                fit: BoxFit.cover,

                alignment: Alignment.center,

                filterQuality: FilterQuality.high,
              ),

              // =================================================
              // LOADING
              // =================================================
              Positioned(
                left: 0,
                right: 0,
                bottom: 18,

                child: Center(
                  child: Obx(
                    () => SizedBox(
                      width: 32,
                      height: 32,

                      child: CircularProgressIndicator(
                        value: controller.progress.value,

                        strokeWidth: 2.8,

                        color: AppColors.primary,

                        backgroundColor: Colors.white.withValues(alpha: 0.25),

                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
