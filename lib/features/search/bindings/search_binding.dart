import 'package:get/get.dart';

import 'package:recipe_app/features/home/repositories/home_repository.dart';
import 'package:recipe_app/features/search/controllers/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchController>(
      () => SearchController(
        repository: Get.find<HomeRepository>(),
      ),
      fenix: true,
    );
  }
}