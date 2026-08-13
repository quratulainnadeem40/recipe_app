import 'package:get/get.dart';

import 'package:recipe_app/features/home/controllers/home_controller.dart';
import 'package:recipe_app/features/home/repositories/home_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepository>(
      () => HomeRepository(),
    );

    Get.lazyPut<HomeController>(
      () => HomeController(
        repository: Get.find<HomeRepository>(),
      ),
    );
  }
}