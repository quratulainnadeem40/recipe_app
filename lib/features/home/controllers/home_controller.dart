import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recipe_app/features/home/models/recipe_models.dart';
import 'package:recipe_app/features/home/repositories/home_repository.dart';

class HomeController extends GetxController {
  final HomeRepository repository;
  final GetStorage _storage = GetStorage();

  HomeController({
    required this.repository,
  });

  final RxString userName = ''.obs;

  // ============================================================
  // HOME RECIPES
  // ============================================================

  final RxList<RecipeModel> recipes =
      <RecipeModel>[].obs;

  final RxBool isLoading =
      false.obs;

  final RxString errorMessage =
      ''.obs;

  // ============================================================
  // TRENDING
  // ============================================================

  final RxList<RecipeModel> trendingRecipes =
      <RecipeModel>[].obs;

  final RxBool isTrendingLoading =
      false.obs;

  // ============================================================
  // SELECTED COUNTRY
  // ============================================================

  final RxString selectedCountry =
      ''.obs;

  final RxList<RecipeModel> countryRecipes =
      <RecipeModel>[].obs;

  final RxBool isCountryLoading =
      false.obs;

  // ============================================================
  // SELECTED CATEGORY
  // ============================================================

  final RxString selectedCategory =
      ''.obs;

  final RxList<RecipeModel> categoryRecipes =
      <RecipeModel>[].obs;

  final RxBool isCategoryLoading =
      false.obs;

  // ============================================================
  // HOME SEARCH FIELD
  // ============================================================

  final TextEditingController
      searchTextController =
      TextEditingController();

  // ============================================================
  // SEARCH TEXT
  // ============================================================

  void onSearchTextChanged(
    String value,
  ) {
    // Home search only acts as a shortcut.
    // Actual live suggestions are handled
    // on SearchScreen.
  }

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    loadUserName();
    getRecipes();
  }

  void loadUserName() {
    final String savedName = _storage.read<String>('userName') ?? 'Chef';
    userName.value = savedName;
  }
  // ============================================================
  // LOAD HOME
  // ============================================================

  Future<void> getRecipes() async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result =
          await repository.getTrendingRecipes();

      recipes.assignAll(result);

      trendingRecipes.assignAll(result);
    } catch (e) {
      debugPrint(
        'HOME ERROR: $e',
      );

      errorMessage.value =
          'Unable to load recipes. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // LOAD COUNTRY
  // ============================================================

  Future<void> loadCountryRecipes(
    String country,
  ) async {
    final clean =
        country.trim();

    if (clean.isEmpty) {
      return;
    }

    selectedCountry.value =
        clean;

    try {
      isCountryLoading.value = true;

      final result =
          await repository
              .getRecipesByCountry(
        clean,
      );

      countryRecipes.assignAll(
        result,
      );
    } catch (e) {
      debugPrint(
        'COUNTRY ERROR: $e',
      );

      countryRecipes.clear();
    } finally {
      isCountryLoading.value =
          false;
    }
  }

  // ============================================================
  // LOAD CATEGORY
  // ============================================================

  Future<void> loadCategoryRecipes(
    String category,
  ) async {
    final clean =
        category.trim();

    if (clean.isEmpty) {
      return;
    }

    selectedCategory.value =
        clean;

    try {
      isCategoryLoading.value =
          true;

      final result =
          await repository
              .getRecipesByCategory(
        clean,
      );

      categoryRecipes.assignAll(
        result,
      );
    } catch (e) {
      debugPrint(
        'CATEGORY ERROR: $e',
      );

      categoryRecipes.clear();
    } finally {
      isCategoryLoading.value =
          false;
    }
  }

  // ============================================================
  // CLEAR SELECTION
  // ============================================================

  void clearSelections() {
    selectedCountry.value = '';
    selectedCategory.value = '';

    countryRecipes.clear();
    categoryRecipes.clear();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    searchTextController.dispose();

    super.onClose();
  }
}