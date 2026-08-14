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
  // COUNTRY RECIPES
  // =========================================================

  final RxList<RecipeModel> countryRecipes =
      <RecipeModel>[].obs;

  final RxBool isCountryLoading = false.obs;

  final RxString countryErrorMessage = ''.obs;

  final RxString selectedCountry = ''.obs;

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
          await repository.getRecipesByCategory(
        category,
      );

      categoryRecipes.assignAll(result);
    } catch (e) {
      categoryErrorMessage.value =
          'Failed to load $category recipes: $e';

      categoryRecipes.clear();
    } finally {
      isCategoryLoading.value = false;
    }
  }

  // =========================================================
  // GET RECIPES BY COUNTRY / AREA
  // =========================================================

  Future<void> getRecipesByCountry(
    String country,
  ) async {
    try {
      isCountryLoading.value = true;
      countryErrorMessage.value = '';

      countryRecipes.clear();

      selectedCountry.value = country;

      final result =
          await repository.getRecipesByCountry(
        country,
      );

      if (result.isEmpty) {
        countryErrorMessage.value =
            'No recipes found for $country';
        return;
      }

      countryRecipes.assignAll(result);
    } catch (e) {
      countryErrorMessage.value =
          'Failed to load $country recipes: $e';

      countryRecipes.clear();
    } finally {
      isCountryLoading.value = false;
    }
  }

  // =========================================================
  // CLEAR COUNTRY RECIPES
  // =========================================================

  void clearCountryRecipes() {
    countryRecipes.clear();
    selectedCountry.value = '';
    countryErrorMessage.value = '';
    isCountryLoading.value = false;
  }

  // =========================================================
  // SEARCH RECIPES
  // =========================================================

  Future<void> searchRecipes(
    String query,
  ) async {
    final searchQuery = query.trim();

    if (searchQuery.isEmpty) {
      clearSearch();
      return;
    }

    try {
      isSearching.value = true;
      isSearchActive.value = true;
      searchErrorMessage.value = '';

      final result =
          await repository.searchRecipes(
        searchQuery,
      );

      searchResults.assignAll(result);
    } catch (e) {
      searchErrorMessage.value =
          'Failed to search recipes: $e';

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