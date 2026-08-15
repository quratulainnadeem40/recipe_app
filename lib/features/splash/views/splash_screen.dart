import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:recipe_app/features/splash/controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ==========================================
    // FULL SCREEN SYSTEM UI
    // ==========================================
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,

      body: SizedBox.expand(
        child: Stack(
          children: [
            // ==========================================
            // FULL SCREEN SPLASH IMAGE
            // ==========================================
            Positioned.fill(
              child: Image.asset(
                'assets/imagefolder/image.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),

            // ==========================================
            // LOADING INDICATOR
            // ==========================================
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Center(
                child: Obx(
                  () {
                    return SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        value: controller.progress.value,
                        strokeWidth: 2.5,
                        color: const Color(0xFFFF8A00),
                        backgroundColor:
                            Colors.white.withOpacity(0.25),
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