import 'package:get/get.dart';

import 'package:recipe_app/core/services/api_service.dart';

import 'package:recipe_app/features/favorites/controllers/favorites_controller.dart';

import 'package:recipe_app/features/recipe_details/controllers/recipe_details_controller.dart';
import 'package:recipe_app/features/recipe_details/repositories/recipe_detail_repository.dart';

class RecipeDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // =========================================================
    // API SERVICE
    // =========================================================

    if (!Get.isRegistered<ApiService>()) {
      Get.lazyPut<ApiService>(
        () => ApiService(),
        fenix: true,
      );
    }

    // =========================================================
    // RECIPE DETAILS REPOSITORY
    // =========================================================

    if (!Get.isRegistered<RecipeDetailsRepository>()) {
      Get.lazyPut<RecipeDetailsRepository>(
        () => RecipeDetailsRepository(
          apiService: Get.find<ApiService>(),
        ),
        fenix: true,
      );
    }

    // =========================================================
    // RECIPE DETAILS CONTROLLER
    // =========================================================

    if (!Get.isRegistered<RecipeDetailsController>()) {
      Get.lazyPut<RecipeDetailsController>(
        () => RecipeDetailsController(
          repository: Get.find<RecipeDetailsRepository>(),
        ),
        fenix: true,
      );
    }

    // =========================================================
    // FAVORITES CONTROLLER
    // =========================================================

    if (!Get.isRegistered<FavoritesController>()) {
      Get.lazyPut<FavoritesController>(
        () => FavoritesController(),
        fenix: true,
      );
    }
  }
}