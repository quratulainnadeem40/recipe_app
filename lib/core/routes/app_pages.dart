import 'package:get/get.dart';

import 'package:recipe_app/features/auth/bindings/auth_binding.dart';
import 'package:recipe_app/features/auth/views/forgot_password_screen.dart';
import 'package:recipe_app/features/auth/views/login_screen.dart';
import 'package:recipe_app/features/auth/views/signup_screen.dart';

import 'package:recipe_app/features/home/bindings/home_binding.dart';
import 'package:recipe_app/features/home/views/home_screen.dart';

import 'package:recipe_app/features/on_boarding/bindings/onboarding_binding.dart';
import 'package:recipe_app/features/on_boarding/views/onboarding_screen/onboarding_screen_main.dart';

import 'package:recipe_app/features/recipe_details/bindings/recipe_details_binding.dart';
import 'package:recipe_app/features/recipe_details/views/recipe_details_screen.dart';

import 'package:recipe_app/features/splash/bindings/splash_bindings.dart';
import 'package:recipe_app/features/splash/views/splash_screen.dart';

import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    // Splash
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),

    // Onboarding
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    ),

    // Login
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),

    // Signup
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
      binding: AuthBinding(),
    ),

    // Forgot Password
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),

    // Home
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),

    // Recipe Details
    GetPage(
      name: AppRoutes.recipeDetails,
      page: () => const RecipeDetailsScreen(),
      binding: RecipeDetailsBinding(),
    ),
    GetPage(
  name: AppRoutes.home,
  page: () => const HomeScreen(),
  binding: HomeBinding(),
),

GetPage(
  name: AppRoutes.recipeDetails,
  page: () => const RecipeDetailsScreen(),
  binding: RecipeDetailsBinding(),
),
  ];
}