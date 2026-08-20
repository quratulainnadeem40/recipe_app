import 'package:get/get.dart';

// Auth Imports
import 'package:recipe_app/features/auth/bindings/auth_binding.dart';
import 'package:recipe_app/features/auth/views/forgot_password_screen.dart';
import 'package:recipe_app/features/auth/views/login_screen.dart';
import 'package:recipe_app/features/auth/views/signup_screen.dart';

// Favorites Imports
import 'package:recipe_app/features/favorites/bindings/favorites_binding.dart';
import 'package:recipe_app/features/favorites/views/favorites_screen.dart';

// Feedback Imports
import 'package:recipe_app/features/feedback/binding/feedback_binding.dart';
import 'package:recipe_app/features/feedback/feedback_screen.dart';// Fixed: removed 'hide NavigationBinding'
import 'package:recipe_app/features/navigation/views/main_navigation.dart';

// Notifications Imports
import 'package:recipe_app/features/notifications/bindings/notifications_binding.dart';
import 'package:recipe_app/features/notifications/views/notifications_screen.dart';

// Onboarding Imports
import 'package:recipe_app/features/on_boarding/bindings/onboarding_binding.dart';
import 'package:recipe_app/features/on_boarding/views/onboarding_screen/onboarding_screen_main.dart';

// Profile Imports
import 'package:recipe_app/features/profile/bindings/edit_profile_binding.dart';
import 'package:recipe_app/features/profile/bindings/profile_binding.dart';
import 'package:recipe_app/features/profile/views/account_settings_screen.dart';
import 'package:recipe_app/features/profile/views/change_password_screen.dart';
import 'package:recipe_app/features/profile/views/edit_profile_screen.dart'; // Fixed: package0 -> package
import 'package:recipe_app/features/profile/views/privacy_policy_screen.dart';
import 'package:recipe_app/features/profile/views/terms_and_conditions_screen.dart';

// Recipe Details Imports
import 'package:recipe_app/features/recipe_details/bindings/recipe_details_binding.dart';
import 'package:recipe_app/features/recipe_details/views/recipe_details_screen.dart';

// Search Imports
import 'package:recipe_app/features/search/bindings/search_binding.dart'; // Fixed: package0 -> package
import 'package:recipe_app/features/search/views/search_screen.dart';

// Splash Imports
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

    // Authentication
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),

    // Main Navigation (Home Dashboard including Bottom NavBar)
    GetPage(
      name: AppRoutes.home,
      page: () => const MainNavigation(),
      binding: NavigationBinding(),
    ),
GetPage(
  name: AppRoutes.search,
  page: () => const SearchScreen(),
  binding: SearchBinding(),
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
      binding: NavigationBinding(),
    ),

    // Profile & Settings
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.accountSettings,
      page: () => const AccountSettingsScreen(),
    ),
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
    ),
    GetPage(
      name: AppRoutes.termsAndConditions,
      page: () => const TermsAndConditionsScreen(),
    ),

    // Notifications
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
      binding: NotificationBinding(),
    ),

    // Recipe Details
    GetPage(
      name: AppRoutes.recipeDetails,
      page: () => const RecipeDetailScreen(),
      binding: RecipeDetailsBinding(),
    ),

    // Feedback
    GetPage(
      name: AppRoutes.feedback,
      page: () => const FeedbackScreen(),
      binding: FeedbackBinding(),
    ),
  ];
}