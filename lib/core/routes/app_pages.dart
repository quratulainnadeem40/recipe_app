import 'package:get/get.dart';

import 'package:recipe_app/features/auth/bindings/auth_binding.dart';
import 'package:recipe_app/features/auth/views/forgot_password_screen.dart';
import 'package:recipe_app/features/auth/views/login_screen.dart';
import 'package:recipe_app/features/auth/views/signup_screen.dart';

import 'package:recipe_app/features/navigation/bindings/navigation_binding.dart';
import 'package:recipe_app/features/navigation/views/main_navigation.dart';
import 'package:recipe_app/features/notifications/controllers/notifications_controller.dart';

import 'package:recipe_app/features/on_boarding/bindings/onboarding_binding.dart';
import 'package:recipe_app/features/on_boarding/views/onboarding_screen/onboarding_screen_main.dart';
import 'package:recipe_app/features/profile/bindings/profile_binding.dart';

import 'package:recipe_app/features/recipe_details/bindings/recipe_details_binding.dart';
import 'package:recipe_app/features/recipe_details/views/recipe_details_screen.dart';

import 'package:recipe_app/features/splash/bindings/splash_bindings.dart';
import 'package:recipe_app/features/splash/views/splash_screen.dart';

import 'package:recipe_app/features/profile/bindings/edit_profile_binding.dart';
import 'package:recipe_app/features/profile/views/edit_profile_screen.dart';

import 'package:recipe_app/features/favorites/bindings/favorites_binding.dart';
import 'package:recipe_app/features/favorites/views/favorites_screen.dart';

import 'package:recipe_app/features/search/bindings/search_binding.dart';
import 'package:recipe_app/features/search/views/search_screen.dart';

import 'package:recipe_app/features/profile/views/account_settings_screen.dart';
import 'package:recipe_app/features/profile/views/privacy_policy_screen.dart';

import 'package:recipe_app/features/profile/views/terms_and_conditions_screen.dart';
import 'package:recipe_app/features/profile/views/change_password_screen.dart';

import 'package:recipe_app/features/notifications/views/notifications_screen.dart';
import 'package:recipe_app/features/notifications/bindings/notifications_binding.dart';

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
      page: () => const MainNavigation(),
      binding: NavigationBinding(),
    ),

    // Search
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchScreen(),
      binding: SearchBinding(),
    ),

    // Favorites
    GetPage(
      name: AppRoutes.favorites,
      page: () => const FavoritesScreen(),
      binding: FavoritesBinding(),
    ),

    //edit profile
    GetPage(
      name: '/edit-profile',
      page: () => const EditProfileScreen(),
      binding: EditProfileBinding(),
    ),

    // Change Password
GetPage(
  name: AppRoutes.changePassword,
  page: () => const ChangePasswordScreen(),
  binding: ProfileBinding(),
),

    // Account Settings
    GetPage(
      name: AppRoutes.accountSettings,
      page: () => const AccountSettingsScreen(),
    ),

    // Notifications
GetPage(
  name: AppRoutes.notifications,
  page: () => const NotificationsScreen(),
  binding: BindingsBuilder(() {
    Get.lazyPut<NotificationController>(
      () => NotificationController(),
    );
  }),
),

    // Privacy Policy
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
    ),

    // Terms & Conditions
    GetPage(
      name: AppRoutes.termsAndConditions,
      page: () => const TermsAndConditionsScreen(),
    ),
    // Recipe Details
    GetPage(
      name: AppRoutes.recipeDetails,
      page: () => const RecipeDetailsScreen(),
      binding: RecipeDetailsBinding(),
    ),

    //     GetPage(
    //   name: AppRoutes.home,
    //   page: () => const HomeScreen(),
    //   binding: HomeBinding(),
    // ),
  ];
}
