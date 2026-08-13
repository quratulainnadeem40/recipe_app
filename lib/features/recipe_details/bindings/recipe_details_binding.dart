import 'package:get/get.dart';

import 'package:recipe_app/core/services/api_service.dart';
import 'package:recipe_app/features/recipe_details/controllers/recipe_details_controller.dart';
import 'package:recipe_app/features/recipe_details/repositories/recipe_detail_repository.dart';

class RecipeDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(
      () => ApiService(),
    );

    Get.lazyPut<RecipeDetailsRepository>(
      () => RecipeDetailsRepository(
        apiService: Get.find<ApiService>(),
      ),
    );

    Get.lazyPut<RecipeDetailsController>(
      () => RecipeDetailsController(
        repository: Get.find<RecipeDetailsRepository>(),
      ),
    );
  }
}