import 'package:get/get.dart';
import 'package:recipe_app/features/favorites/controllers/favorites_controller.dart';
import 'package:recipe_app/features/navigation/controllers/navigation_controller.dart';


class   NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FavoritesController>(FavoritesController(), permanent: true);
    Get.lazyPut<NavigationController>(() => NavigationController());
  }
}