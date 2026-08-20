import 'package:get/get.dart';

import 'package:recipe_app/core/services/api_service.dart';
import 'package:recipe_app/features/home/controllers/home_controller.dart';
import 'package:recipe_app/features/home/repositories/home_repository.dart';

class HomeBinding extends Bindings {
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
  }
}