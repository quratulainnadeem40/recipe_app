import 'package:get/get.dart';

import 'package:recipe_app/features/home/models/recipe_models.dart';
import 'package:recipe_app/features/home/repositories/home_repository.dart';

class HomeController extends GetxController {
  final HomeRepository repository;

  HomeController({
    required this.repository,
  });

  // All recipes
  final RxList<RecipeModel> recipes = <RecipeModel>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Error message
  final RxString errorMessage = ''.obs;

  // Category recipes
  final RxList<RecipeModel> categoryRecipes =
      <RecipeModel>[].obs;

  // Category loading
  final RxBool isCategoryLoading = false.obs;

  // Category error
  final RxString categoryErrorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getRecipes();
  }

  // Get all recipes
  Future<void> getRecipes() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await repository.getRecipes();

      recipes.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
      recipes.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Get recipes by category
  Future<void> getRecipesByCategory(
    String category,
  ) async {
    try {
      isCategoryLoading.value = true;
      categoryErrorMessage.value = '';

      categoryRecipes.clear();

      final result =
          await repository.getRecipesByCategory(category);

      categoryRecipes.assignAll(result);
    } catch (e) {
      categoryErrorMessage.value =
          'Failed to load $category recipes';

      categoryRecipes.clear();
    } finally {
      isCategoryLoading.value = false;
    }
  }
}