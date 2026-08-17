import 'dart:async';

import 'package:flutter/material.dart';
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

  final RxString selectedCategory = ''.obs;

  // =========================================================
  // COUNTRY RECIPES
  // =========================================================

  final RxList<RecipeModel> countryRecipes =
      <RecipeModel>[].obs;

  final RxBool isCountryLoading = false.obs;

  final RxString countryErrorMessage = ''.obs;

  final RxString selectedCountry = ''.obs;

  // =========================================================
  // SEARCH RESULTS
  // =========================================================

  final RxList<RecipeModel> searchResults =
      <RecipeModel>[].obs;

  final RxBool isSearching = false.obs;

  final RxString searchErrorMessage = ''.obs;

  final RxBool isSearchActive = false.obs;

  // =========================================================
  // LIVE SEARCH SUGGESTIONS
  // =========================================================

  final RxList<RecipeModel> searchSuggestions =
      <RecipeModel>[].obs;

  final RxBool isSuggestionLoading = false.obs;

  final RxBool showSuggestions = false.obs;

  Timer? _searchDebounce;

  // =========================================================
  // SEARCH TEXT CONTROLLER
  // =========================================================

  final TextEditingController searchTextController =
      TextEditingController();

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

      final result =
          await repository.getRecipes();

      recipes.assignAll(result);
    } catch (e) {
      errorMessage.value =
          'Failed to load recipes';

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

      selectedCategory.value = category;

      final result =
          await repository.getRecipesByCategory(
        category,
      );

      if (result.isEmpty) {
        categoryErrorMessage.value =
            'No recipes found for $category';

        return;
      }

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
  // CLEAR CATEGORY
  // =========================================================

  void clearCategoryRecipes() {
    categoryRecipes.clear();

    selectedCategory.value = '';

    categoryErrorMessage.value = '';

    isCategoryLoading.value = false;
  }

  // =========================================================
  // GET RECIPES BY COUNTRY
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
          'Failed to load $country recipes';

      countryRecipes.clear();
    } finally {
      isCountryLoading.value = false;
    }
  }

  // =========================================================
  // CLEAR COUNTRY
  // =========================================================

  void clearCountryRecipes() {
    countryRecipes.clear();

    selectedCountry.value = '';

    countryErrorMessage.value = '';

    isCountryLoading.value = false;
  }

  // =========================================================
  // LIVE SEARCH TEXT CHANGE
  // =========================================================

  void onSearchTextChanged(
    String value,
  ) {
    final query = value.trim();

    // Cancel previous request timer.
    _searchDebounce?.cancel();

    // Empty search.
    if (query.isEmpty) {
      searchSuggestions.clear();

      showSuggestions.value = false;

      isSuggestionLoading.value = false;

      return;
    }

    // Don't call API for a single character.
    if (query.length < 2) {
      searchSuggestions.clear();

      showSuggestions.value = false;

      isSuggestionLoading.value = false;

      return;
    }

    // Show dropdown immediately.
    showSuggestions.value = true;

    isSuggestionLoading.value = true;

    // Wait before calling API.
    _searchDebounce = Timer(
      const Duration(milliseconds: 350),
      () {
        _loadSearchSuggestions(query);
      },
    );
  }

  // =========================================================
  // LOAD LIVE SEARCH SUGGESTIONS
  // =========================================================

  Future<void> _loadSearchSuggestions(
    String query,
  ) async {
    try {
      final result =
          await repository.searchRecipes(query);

      // Only show a small number of suggestions.
      final suggestions =
          result.take(6).toList();

      searchSuggestions.assignAll(
        suggestions,
      );
    } catch (e) {
      searchSuggestions.clear();
    } finally {
      isSuggestionLoading.value = false;
    }
  }

  // =========================================================
  // SELECT SEARCH SUGGESTION
  // =========================================================

  void selectSearchSuggestion(
    RecipeModel recipe,
  ) {
    // Put selected recipe name in search field.
    searchTextController.text =
        recipe.name;

    // Move cursor to end.
    searchTextController.selection =
        TextSelection.fromPosition(
      TextPosition(
        offset:
            searchTextController.text.length,
      ),
    );

    // Hide suggestions.
    showSuggestions.value = false;

    searchSuggestions.clear();
  }

  // =========================================================
  // HIDE SUGGESTIONS
  // =========================================================

  void hideSuggestions() {
    showSuggestions.value = false;
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

    // Hide live suggestions when actual search starts.
    showSuggestions.value = false;

    searchSuggestions.clear();

    try {
      isSearching.value = true;

      isSearchActive.value = true;

      searchErrorMessage.value = '';

      final result =
          await repository.searchRecipes(
        searchQuery,
      );

      searchResults.assignAll(
        result,
      );
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

    searchSuggestions.clear();

    searchErrorMessage.value = '';

    isSearchActive.value = false;

    isSearching.value = false;

    showSuggestions.value = false;

    isSuggestionLoading.value = false;
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void onClose() {
    _searchDebounce?.cancel();

    searchTextController.dispose();

    super.onClose();
  }
}