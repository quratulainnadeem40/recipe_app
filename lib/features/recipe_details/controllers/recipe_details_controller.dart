import 'package:get/get.dart';

import 'package:recipe_app/features/recipe_details/model/recipe_detail_model.dart';
import 'package:recipe_app/features/recipe_details/repositories/recipe_detail_repository.dart';

class RecipeDetailsController extends GetxController {
  final RecipeDetailsRepository repository;

  RecipeDetailsController({
    required this.repository,
  });

  // =========================================================
  // RECIPE
  // =========================================================

  final Rxn<RecipeDetailsModel> recipe =
      Rxn<RecipeDetailsModel>();

  // =========================================================
  // LOADING
  // =========================================================

  final RxBool isLoading = false.obs;

  // =========================================================
  // ERROR
  // =========================================================

  final RxString errorMessage = ''.obs;

  // =========================================================
  // IMAGE PAGE
  // =========================================================

  final RxInt currentImageIndex = 0.obs;

  // =========================================================
  // INIT
  // =========================================================

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;

    if (arguments is String && arguments.isNotEmpty) {
      getRecipeDetails(arguments);
    } else {
      errorMessage.value = 'Recipe ID not found.';
    }
  }

  // =========================================================
  // GET RECIPE DETAILS
  // =========================================================

  Future<void> getRecipeDetails(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      currentImageIndex.value = 0;

      final RecipeDetailsModel result =
          await repository.getRecipeDetails(id);

      recipe.value = result;
    } catch (e) {
      recipe.value = null;

      errorMessage.value =
          'Failed to load recipe details.';
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================
  // CHANGE IMAGE
  // =========================================================

  void changeImage(int index) {
    currentImageIndex.value = index;
  }

  // =========================================================
  // RETRY
  // =========================================================

  Future<void> retry() async {
    final arguments = Get.arguments;

    if (arguments is String && arguments.isNotEmpty) {
      await getRecipeDetails(arguments);
    } else {
      errorMessage.value = 'Recipe ID not found.';
    }
  }
}