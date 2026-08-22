import 'package:get/get.dart';

import 'package:recipe_app/core/services/api_service.dart';
import 'package:recipe_app/features/recipe_details/repositories/recipe_detail_repository.dart';
import '../controllers/recipe_details_controller.dart';

class RecipeBinding extends Bindings {
  @override
  void dependencies() {
    // =========================================================
    // API SERVICE
    // =========================================================

    Get.lazyPut<ApiService>(
      () => ApiService(),
      fenix: true,
    );

    // =========================================================
    // RECIPE REPOSITORY
    // Used by RecipeController
    // =========================================================

    Get.lazyPut<RecipeRepository>(
      () => RecipeRepository(
        apiService: Get.find<ApiService>(),
      ),
      fenix: true,
    );

    // =========================================================
    // RECIPE CONTROLLER
    // =========================================================

    Get.lazyPut<RecipeController>(
      () => RecipeController(
        repository: Get.find<RecipeRepository>(),
      ),
      fenix: true,
    );
  }
}