import 'package:get/get.dart';
import 'package:recipe_app/core/services/api_service.dart';
import '../controllers/recipe_details_controller.dart';
import '../repositories/recipe_detail_repository.dart';

class RecipeDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // =========================================================
    // API SERVICE
    // =========================================================

    Get.lazyPut<ApiService>(
      () => ApiService(),
    );

    // =========================================================
    // REPOSITORY
    // =========================================================

    Get.lazyPut<RecipeDetailsRepository>(
      () => RecipeDetailsRepository(
        apiService: Get.find<ApiService>(),
      ),
    );

    // =========================================================
    // CONTROLLER
    // =========================================================

    Get.lazyPut<RecipeDetailsController>(
      () => RecipeDetailsController(
        repository: Get.find<RecipeDetailsRepository>(),
      ),
    );
  }
}