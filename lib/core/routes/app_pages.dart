import 'package:get/get.dart';



// ============================================================
// FAVORITES
// ============================================================

import 'package:recipe_app/features/favorites/bindings/favorites_binding.dart';
import 'package:recipe_app/features/favorites/views/favorites_screen.dart';

// ============================================================
// FEEDBACK
// ============================================================

import 'package:recipe_app/features/feedback/binding/feedback_binding.dart';
import 'package:recipe_app/features/feedback/feedback_screen.dart';

// ============================================================
// HOME
// ============================================================

import 'package:recipe_app/features/home/bindings/home_binding.dart';
import 'package:recipe_app/features/home/views/home_screen.dart';

// ============================================================
// NAVIGATION
// ============================================================

import 'package:recipe_app/features/navigation/bindings/navigation_binding.dart'
    hide NavigationBinding;
import 'package:recipe_app/features/navigation/views/main_navigation.dart';

// ============================================================
// NOTIFICATIONS
// ============================================================

import 'package:recipe_app/features/notifications/bindings/notifications_binding.dart';
import 'package:recipe_app/features/notifications/views/notifications_screen.dart';



// ============================================================
// SETTINGS
// ============================================================

import 'package:recipe_app/features/settings/bindings/edit_profile_binding.dart';
import 'package:recipe_app/features/settings/bindings/settings_binding.dart';
import 'package:recipe_app/features/settings/views/account_settings_screen.dart';
import 'package:recipe_app/features/settings/views/edit_profile_screen.dart';
import 'package:recipe_app/features/settings/views/privacy_policy_screen.dart';
import 'package:recipe_app/features/settings/views/settings_screen.dart';
import 'package:recipe_app/features/settings/views/terms_and_conditions_screen.dart';

// ============================================================
// RECIPE DETAILS
// ============================================================

import 'package:recipe_app/features/recipe_details/bindings/recipe_details_binding.dart';
import 'package:recipe_app/features/recipe_details/views/recipe_details_screen.dart';

// ============================================================
// SEARCH
// ============================================================

import 'package:recipe_app/features/search/bindings/search_binding.dart';
import 'package:recipe_app/features/search/views/search_screen.dart';

// ============================================================
// SPLASH
// ============================================================

import 'package:recipe_app/features/splash/bindings/splash_bindings.dart';
import 'package:recipe_app/features/splash/views/splash_screen.dart';

// ============================================================
// ROUTES
// ============================================================

import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    // ==========================================================
    // SPLASH
    // ==========================================================

    GetPage(
      name: '/',
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),

    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),


    // ==========================================================
    // MAIN HOME / NAVIGATION
    // ==========================================================

    GetPage(
      name: AppRoutes.home,
      page: () => const MainNavigation(),
      binding: NavigationsBinding(),
    ),

    // ==========================================================
    // DIRECT HOME SCREEN
    // ==========================================================
    //
    // Use this only when you specifically want HomeScreen
    // without MainNavigation.
    //

    GetPage(
      name: '/home-details',
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),

    // ==========================================================
    // SEARCH
    // ==========================================================

    GetPage(
      name: AppRoutes.search,
      page: () => const SearchScreen(),
      binding: SearchBinding(),
    ),

    // ==========================================================
    // FAVORITES
    // ==========================================================

    GetPage(
      name: AppRoutes.favorites,
      page: () => const FavoritesScreen(),
      binding: FavoritesBinding(),
    ),

    // ==========================================================
    // RECIPE DETAILS
    // ==========================================================

    GetPage(
      name: AppRoutes.recipeDetails,
      page: () => const RecipeDetailScreen(),
      binding: RecipeBinding(),
    ),

    // ==========================================================
    // NOTIFICATIONS
    // ==========================================================

    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
      binding: NotificationBinding(),
    ),

    // ==========================================================
    // FEEDBACK
    // ==========================================================

    GetPage(
      name: AppRoutes.feedback,
      page: () => const FeedbackScreen(),
      binding: FeedbackBinding(),
    ),

    // ==========================================================
    // SETTINGS / PROFILE
    // ==========================================================

    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
    ),

    GetPage(
      name: AppRoutes.profile,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
    ),

    // ==========================================================
    // EDIT PROFILE
    // ==========================================================

    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
      binding: EditProfileBinding(),
    ),


    // ==========================================================
    // ACCOUNT SETTINGS
    // ==========================================================

    GetPage(
      name: AppRoutes.accountSettings,
      page: () => const AccountSettingsScreen(),
    ),

    // ==========================================================
    // PRIVACY POLICY
    // ==========================================================

    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
    ),

    // ==========================================================
    // TERMS & CONDITIONS
    // ==========================================================

    GetPage(
      name: AppRoutes.termsAndConditions,
      page: () => const TermsAndConditionsScreen(),
    ),
  ];
}