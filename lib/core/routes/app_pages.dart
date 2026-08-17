
import 'package:get/get.dart';

import 'package:recipe_app/features/auth/bindings/auth_binding.dart';
import 'package:recipe_app/features/auth/views/forgot_password_screen.dart';
import 'package:recipe_app/features/auth/views/login_screen.dart';
import 'package:recipe_app/features/auth/views/signup_screen.dart';

import 'package:recipe_app/features/feedback/binding/feedback_binding.dart';
import 'package:recipe_app/features/feedback/feedback_screen.dart';

import 'package:recipe_app/features/navigation/bindings/navigation_binding.dart';
import 'package:recipe_app/features/navigation/views/main_navigation.dart';

import 'package:recipe_app/features/on_boarding/bindings/onboarding_binding.dart';
import 'package:recipe_app/features/on_boarding/views/onboarding_screen/onboarding_screen_main.dart';

import 'package:recipe_app/features/profile/bindings/profile_binding.dart';
import 'package:recipe_app/features/profile/bindings/edit_profile_binding.dart';
import 'package:recipe_app/features/profile/views/edit_profile_screen.dart';
import 'package:recipe_app/features/profile/views/account_settings_screen.dart';
import 'package:recipe_app/features/profile/views/privacy_policy_screen.dart';
import 'package:recipe_app/features/profile/views/terms_and_conditions_screen.dart';
import 'package:recipe_app/features/profile/views/change_password_screen.dart';

import 'package:recipe_app/features/recipe_details/bindings/recipe_details_binding.dart';
import 'package:recipe_app/features/recipe_details/views/recipe_details_screen.dart';
import 'package:recipe_app/features/search/controllers/search_controller.dart';

import 'package:recipe_app/features/splash/bindings/splash_bindings.dart';
import 'package:recipe_app/features/splash/views/splash_screen.dart';

import 'package:recipe_app/features/favorites/bindings/favorites_binding.dart' hide RecipeDetailsBinding;
import 'package:recipe_app/features/favorites/views/favorites_screen.dart';

import 'package:recipe_app/features/search/bindings/search_binding.dart';
import 'package:recipe_app/features/search/views/search_screen.dart' hide SearchController;

import 'package:recipe_app/features/notifications/bindings/notifications_binding.dart';
import 'package:recipe_app/features/notifications/views/notifications_screen.dart';

import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),

    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    ),

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

    GetPage(
      name: AppRoutes.favorites,
      page: () => const FavoritesScreen(),
      binding: FavoritesBinding(),
    ),

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
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
      binding: NotificationBinding(),
    ),

    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
    ),

    GetPage(
      name: AppRoutes.termsAndConditions,
      page: () => const TermsAndConditionsScreen(),
    ),

    GetPage(
      name: AppRoutes.recipeDetails,
      page: () => const RecipeDetailsScreen(),
      binding: RecipeDetailsBinding(),
    ),

    GetPage(
      name: AppRoutes.feedback,
      page: () => const FeedbackScreen(),
      binding: FeedbackBinding(),
    ),
  ];
}

