import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/theme/app_themes.dart';
import 'package:recipe_app/features/on_boarding/controllers/onboarding_screen1_controller.dart';
import 'package:recipe_app/features/on_boarding/views/onboarding_screen1.dart';
import 'package:recipe_app/features/on_boarding/views/onboarding_screen2.dart';
import 'package:recipe_app/features/splash/controllers/splash_controller.dart';
import 'package:recipe_app/features/splash/views/splash_screen.dart';

void main() {
  runApp(const CookmateApp());
}

class CookmateApp extends StatelessWidget {
  const CookmateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'COOKmate',

      // ==========================================
      // THEME
      // ==========================================
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      // ==========================================
      // INITIAL ROUTE
      // ==========================================
      initialRoute: '/splash',

      // ==========================================
      // ROUTES
      // ==========================================
      getPages: [
        // ------------------------------------------
        // Splash
        // ------------------------------------------
        GetPage(
          name: '/splash',
          page: () => SplashScreen(),
          binding: BindingsBuilder(() {
            Get.lazyPut<SplashController>(() => SplashController());
          }),
        ),

        // ------------------------------------------
        // Onboarding 1
        // ------------------------------------------
        GetPage(
          name: '/onboarding1',
          page: () => const OnboardingScreen1(),
          binding: BindingsBuilder(() {
            Get.lazyPut<OnboardingController>(() => OnboardingController());
          }),
        ),

        // ------------------------------------------
        // Onboarding 2
        // ------------------------------------------
        GetPage(
          name: '/onboarding2',
          page: () => const OnboardingScreen2(),
          binding: BindingsBuilder(() {
            Get.lazyPut<OnboardingController>(() => OnboardingController());
          }),
        ),

        // ------------------------------------------
        // Home
        // ------------------------------------------
      ],
    );
  }
}
