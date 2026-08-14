
import 'package:get/get.dart';

import '../controllers/navigation_controller.dart';

import '../../home/bindings/home_binding.dart';
import '../../profile/bindings/profile_binding.dart';
import '../../favorites/controllers/favorites_controller.dart';
import '../../search/bindings/search_binding.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    // =========================================================
    // NAVIGATION CONTROLLER
    // =========================================================

    Get.lazyPut<NavigationController>(
      () => NavigationController(),
    );

    // =========================================================
    // HOME CONTROLLER + REPOSITORY
    // =========================================================

    HomeBinding().dependencies();

    // =========================================================
    // PROFILE CONTROLLER
    // =========================================================

    ProfileBinding().dependencies();

    // =========================================================
    // FAVORITES CONTROLLER
    // =========================================================

    Get.lazyPut<FavoritesController>(
      () => FavoritesController(),
    );

    // =========================================================
    // SEARCH CONTROLLER + REPOSITORY
    // =========================================================

    SearchBinding().dependencies();
  }
}

