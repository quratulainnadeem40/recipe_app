import 'package:get/get.dart';

import 'package:recipe_app/features/home/models/recipe_models.dart';
import 'package:recipe_app/features/home/repositories/home_repository.dart';

class HomeController extends GetxController {
  final HomeRepository repository;

  HomeController({
    required this.repository,
  });

  // =========================================================
  // ALL RECIPES
  // =========================================================

  final RxList<RecipeModel> recipes =
      <RecipeModel>[].obs;

  final RxBool isLoading = false.obs;

  final RxString errorMessage = ''.obs;

  // =========================================================
  // CATEGORY RECIPES
  // =========================================================

  final RxList<RecipeModel> categoryRecipes =
      <RecipeModel>[].obs;

  final RxBool isCategoryLoading = false.obs;

  final RxString categoryErrorMessage = ''.obs;

  // =========================================================
  // SEARCH
  // =========================================================

  final RxList<RecipeModel> searchResults =
      <RecipeModel>[].obs;

  final RxBool isSearching = false.obs;

  final RxString searchErrorMessage = ''.obs;

  final RxBool isSearchActive = false.obs;

  // =========================================================
  // INITIALIZATION
  // =========================================================

  @override
  void onInit() {
    super.onInit();

    getRecipes();
  }

  // =========================================================
  // GET ALL RECIPES
  // =========================================================

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

  // =========================================================
  // GET RECIPES BY CATEGORY
  // =========================================================

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

  // =========================================================
  // SEARCH RECIPES
  // =========================================================

  Future<void> searchRecipes(String query) async {
    final searchQuery = query.trim();

    // Empty search
    if (searchQuery.isEmpty) {
      clearSearch();
      return;
    }

    try {
      isSearching.value = true;
      isSearchActive.value = true;
      searchErrorMessage.value = '';

      final result =
          await repository.searchRecipes(searchQuery);

      searchResults.assignAll(result);
    } catch (e) {
      searchErrorMessage.value =
          'Failed to search recipes';

      searchResults.clear();
    } finally {
      isSearching.value = false;
    }
  }

  // =========================================================
  // CLEAR SEARCH
  // =========================================================

  void clearSearch() {
    searchResults.clear();
    searchErrorMessage.value = '';
    isSearchActive.value = false;
    isSearching.value = false;
  }
}