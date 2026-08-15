import 'package:get/get.dart';
import 'package:recipe_app/features/recipe_details/model/recipe_detail_model.dart';


import 'package:recipe_app/features/recipe_details/repositories/recipe_detail_repository.dart';

class RecipeDetailsController extends GetxController {
  final RecipeDetailsRepository repository;

  RecipeDetailsController({
    required this.repository,
  });

  final Rxn<RecipeDetailsModel> recipe =
      Rxn<RecipeDetailsModel>();

  final RxBool isLoading = false.obs;

  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    final String recipeId = Get.arguments as String;

    getRecipeDetails(recipeId);
  }

  Future<void> getRecipeDetails(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result =
          await repository.getRecipeDetails(id);

      recipe.value = result;
    } catch (e) {
      errorMessage.value =
          'Failed to load recipe details';
    } finally {
      isLoading.value = false;
    }
  }
}