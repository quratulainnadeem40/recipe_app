import 'package:get/get.dart';
import 'package:recipe_app/features/home/repositories/home_repository.dart'; // [1]
import 'package:recipe_app/features/search/controllers/search_controller.dart'; // [1]

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    // RecipeSearchController ko register kar rahe hain aur generic type specify kar rahe hain
    Get.lazyPut<RecipeSearchController>(
      () => RecipeSearchController(
        repository: Get.find<HomeRepository>(),
      ),
      fenix: true,
    );
  }
}
