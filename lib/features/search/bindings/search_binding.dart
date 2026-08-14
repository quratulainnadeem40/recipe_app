import 'package:get/get.dart';

import '../controllers/search_controller.dart';
import '../../home/repositories/home_repository.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepository>(
      () => HomeRepository(),
    );

    Get.lazyPut<SearchController>(
      () => SearchController(
        repository: Get.find<HomeRepository>(),
      ),
    );
  }
}