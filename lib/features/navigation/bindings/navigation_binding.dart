import 'package:get/get.dart';

import 'package:recipe_app/core/services/api_service.dart';
import 'package:recipe_app/features/favorites/controllers/favorites_controller.dart';
import 'package:recipe_app/features/home/controllers/home_controller.dart';
import 'package:recipe_app/features/home/repositories/home_repository.dart';
import 'package:recipe_app/features/navigation/controllers/navigation_controller.dart';
import 'package:recipe_app/features/profile/controllers/profile_controller.dart';
import 'package:recipe_app/features/search/controllers/search_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    // ============================================================
    // API SERVICE
    // ============================================================

    Get.lazyPut<ApiService>(
      () => ApiService(),
      fenix: true,
    );

    // ============================================================
    // NAVIGATION CONTROLLER
    // ============================================================

    Get.lazyPut<NavigationController>(
      () => NavigationController(),
      fenix: true,
    );

    // ============================================================
    // HOME REPOSITORY
    // ============================================================

    Get.lazyPut<HomeRepository>(
      () => HomeRepository(
        apiService: Get.find<ApiService>(),
      ),
      fenix: true,
    );

    // ============================================================
    // HOME CONTROLLER
    // ============================================================

    Get.lazyPut<HomeController>(
      () => HomeController(
        repository: Get.find<HomeRepository>(),
      ),
      fenix: true,
    );

    // ============================================================
    // SEARCH CONTROLLER
    // ============================================================

    Get.lazyPut<SearchController>(
      () => SearchController(
        repository: Get.find<HomeRepository>(),
      ),
      fenix: true,
    );

    // ============================================================
    // FAVORITES
    // ============================================================

    Get.lazyPut<FavoritesController>(
      () => FavoritesController(),
      fenix: true,
    );

    // ============================================================
    // PROFILE
    // ============================================================

    Get.lazyPut<ProfileController>(
      () => ProfileController(),
      fenix: true,
    );
  }
}