
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/routes/app_routes.dart';
import 'package:recipe_app/features/home/models/recipe_models.dart';
import 'package:recipe_app/features/home/repositories/home_repository.dart';

class SearchController extends GetxController {
  final HomeRepository repository;

  SearchController({
    required this.repository,
  });

  // =========================================================
  // SEARCH TEXT
  // =========================================================

  final TextEditingController searchTextController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // =========================================================
  // RESULTS
  // =========================================================

  final RxList<RecipeModel> searchResults = <RecipeModel>[].obs;
  final RxList<RecipeModel> filteredResults = <RecipeModel>[].obs;

  // =========================================================
  // LIVE SUGGESTIONS
  // =========================================================

  final RxList<RecipeModel> suggestions = <RecipeModel>[].obs;
  final RxBool showSuggestions = false.obs;
  final RxBool isSuggestionLoading = false.obs;

  Timer? _suggestionTimer;

  // =========================================================
  // RECENT SEARCHES
  // =========================================================

  final RxList<RecipeModel> recentSearches = <RecipeModel>[].obs;

  // =========================================================
  // SELECTED FILTERS
  // =========================================================

  final RxnString selectedCategory = RxnString();
  final RxnString selectedArea = RxnString();

  // =========================================================
  // LOADING / ERROR
  // =========================================================

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // =========================================================
  // CATEGORIES
  // =========================================================

  final List<String> categories = [
    'Chicken',
    'Beef',
    'Dessert',
    'Seafood',
    'Vegetarian',
    'Pasta',
    'Breakfast',
    'Side',
  ];

  // =========================================================
  // CUISINES / AREAS
  // =========================================================

  final List<String> areas = [
    'American',
    'British',
    'Canadian',
    'Chinese',
    'Croatian',
    'Dutch',
    'Egyptian',
    'Filipino',
    'French',
    'Greek',
    'Indian',
    'Irish',
    'Italian',
    'Jamaican',
    'Japanese',
    'Kenyan',
    'Malaysian',
    'Mexican',
    'Moroccan',
    'Polish',
    'Portuguese',
    'Russian',
    'Spanish',
    'Thai',
    'Tunisian',
    'Turkish',
    'Ukrainian',
    'Uruguayan',
    'Vietnamese',
    'Pakistani',
  ];

  // =========================================================
  // INITIALIZATION
  // =========================================================

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;

    // Handle country String passed from HomeScreen navigation
    if (arguments is String && arguments.trim().isNotEmpty) {
      final country = arguments.trim();
      selectedArea.value = country;
      loadCountryRecipes(country);
    }
    // Handle Map arguments ({'category': '...'}, {'area': '...'}, or {'query': '...'})
    else if (arguments is Map) {
      final category = arguments['category']?.toString().trim();
      final area = arguments['area']?.toString().trim();
      final query = arguments['query']?.toString().trim();

      if (category != null && category.isNotEmpty) {
        selectedCategory.value = category;
        loadCategoryRecipes(category);
      } else if (area != null && area.isNotEmpty) {
        selectedArea.value = area;
        loadCountryRecipes(area);
      } else if (query != null && query.isNotEmpty) {
        searchTextController.text = query;
        searchRecipes(query);
      }
    }
  }

  // =========================================================
  // SEARCH TEXT CHANGE
  // =========================================================

  void onSearchTextChanged(String value) {
    final query = value.trim();

    searchQuery.value = query;
    _suggestionTimer?.cancel();

    if (query.isEmpty || query.length < 2) {
      suggestions.clear();
      showSuggestions.value = false;
      isSuggestionLoading.value = false;
      return;
    }

    showSuggestions.value = true;
    isSuggestionLoading.value = true;

    _suggestionTimer = Timer(
      const Duration(milliseconds: 350),
      () => loadSuggestions(query),
    );
  }

  // =========================================================
  // LOAD LIVE SUGGESTIONS
  // =========================================================

  Future<void> loadSuggestions(String query) async {
    final cleanQuery = query.trim();

    if (cleanQuery.isEmpty) {
      suggestions.clear();
      showSuggestions.value = false;
      isSuggestionLoading.value = false;
      return;
    }

    try {
      final result = await repository.searchRecipes(cleanQuery);

      if (searchQuery.value.trim() != cleanQuery) return;

      suggestions.assignAll(result.take(5).toList());
      showSuggestions.value = suggestions.isNotEmpty;
    } catch (_) {
      suggestions.clear();
      showSuggestions.value = false;
    } finally {
      if (searchQuery.value.trim() == cleanQuery) {
        isSuggestionLoading.value = false;
      }
    }
  }

  // =========================================================
  // SELECT LIVE SUGGESTION
  // =========================================================

  void selectSuggestion(RecipeModel recipe) {
    _suggestionTimer?.cancel();

    searchTextController.text = recipe.name;
    searchTextController.selection = TextSelection.fromPosition(
      TextPosition(offset: searchTextController.text.length),
    );

    searchQuery.value = recipe.name;
    suggestions.clear();
    showSuggestions.value = false;
    isSuggestionLoading.value = false;

    _addRecentSearch(recipe);

    Get.toNamed(
      AppRoutes.recipeDetails,
      arguments: recipe.id,
    );
  }

  // =========================================================
  // SEARCH RECIPES
  // =========================================================

  Future<void> searchRecipes(String value) async {
    final query = value.trim();

    _suggestionTimer?.cancel();
    showSuggestions.value = false;
    suggestions.clear();
    searchQuery.value = query;
    errorMessage.value = '';

    if (query.isEmpty) {
      searchResults.clear();
      filteredResults.clear();
      return;
    }

    try {
      isLoading.value = true;

      final result = await repository.searchRecipes(query);
      searchResults.assignAll(result);

      _applyFilters();
      _addRecentSearches(result);
    } catch (_) {
      searchResults.clear();
      filteredResults.clear();
      errorMessage.value = 'Failed to search recipes. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================
  // LOAD COUNTRY RECIPES
  // =========================================================

  Future<void> loadCountryRecipes(String country) async {
    final cleanCountry = country.trim();
    if (cleanCountry.isEmpty) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';
      selectedArea.value = cleanCountry;

      final result = await repository.getRecipesByCountry(cleanCountry);
      searchResults.assignAll(result);

      _applyFilters();

      if (result.isEmpty) {
        errorMessage.value = 'No recipes found for $cleanCountry.';
      }
    } catch (_) {
      searchResults.clear();
      filteredResults.clear();
      errorMessage.value = 'Failed to load $cleanCountry recipes.';
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================
  // LOAD CATEGORY RECIPES
  // =========================================================

  Future<void> loadCategoryRecipes(String category) async {
    final cleanCategory = category.trim();
    if (cleanCategory.isEmpty) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';
      selectedCategory.value = cleanCategory;

      final result = await repository.getRecipesByCategory(cleanCategory);
      searchResults.assignAll(result);

      _applyFilters();

      if (result.isEmpty) {
        errorMessage.value = 'No recipes found for $cleanCategory.';
      }
    } catch (_) {
      searchResults.clear();
      filteredResults.clear();
      errorMessage.value = 'Failed to load $cleanCategory recipes.';
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================
  // CHANGE COUNTRY / CUISINE
  // =========================================================

  Future<void> setArea(String? area) async {
    if (area == null || area.trim().isEmpty) {
      selectedArea.value = null;
      _applyFilters();
      return;
    }

    await loadCountryRecipes(area.trim());
  }

  // =========================================================
  // CHANGE CATEGORY
  // =========================================================

  Future<void> setCategory(String? category) async {
    if (category == null || category.trim().isEmpty) {
      selectedCategory.value = null;
      _applyFilters();
      return;
    }

    await loadCategoryRecipes(category.trim());
  }

  // =========================================================
  // APPLY FILTERS
  // =========================================================

  void _applyFilters() {
    final category = selectedCategory.value?.trim().toLowerCase();
    final area = selectedArea.value?.trim().toLowerCase();

    final result = searchResults.where((recipe) {
      final recipeCategory = recipe.category.trim().toLowerCase();
      final recipeArea = recipe.area.trim().toLowerCase();

      final categoryMatches =
          category == null || category.isEmpty || recipeCategory == category;

      final areaMatches =
          area == null || area.isEmpty || recipeArea == area;

      return categoryMatches && areaMatches;
    }).toList();

    filteredResults.assignAll(result);
  }

  // =========================================================
  // CLEAR FILTERS
  // =========================================================

  void clearArea() {
    selectedArea.value = null;
    _reloadWithoutArea();
  }

  void clearCategory() {
    selectedCategory.value = null;
    _reloadWithoutCategory();
  }

  void _reloadWithoutArea() {
    if (selectedCategory.value != null &&
        selectedCategory.value!.trim().isNotEmpty) {
      loadCategoryRecipes(selectedCategory.value!);
      return;
    }

    searchResults.clear();
    filteredResults.clear();
  }

  void _reloadWithoutCategory() {
    if (selectedArea.value != null &&
        selectedArea.value!.trim().isNotEmpty) {
      loadCountryRecipes(selectedArea.value!);
      return;
    }

    searchResults.clear();
    filteredResults.clear();
  }

  void clearSearch() {
    _suggestionTimer?.cancel();
    searchTextController.clear();
    searchQuery.value = '';
    suggestions.clear();
    showSuggestions.value = false;
    isSuggestionLoading.value = false;
    searchResults.clear();
    filteredResults.clear();
    errorMessage.value = '';
  }

  // =========================================================
  // RECENT SEARCHES
  // =========================================================

  void _addRecentSearch(RecipeModel recipe) {
    if (recipe.id.trim().isEmpty) return;

    recentSearches.removeWhere((item) => item.id == recipe.id);
    recentSearches.insert(0, recipe);

    if (recentSearches.length > 10) {
      recentSearches.removeRange(10, recentSearches.length);
    }
  }

  void _addRecentSearches(List<RecipeModel> recipes) {
    for (final recipe in recipes.take(5)) {
      _addRecentSearch(recipe);
    }
  }

  void selectRecipe(RecipeModel recipe) {
    Get.toNamed(
      AppRoutes.recipeDetails,
      arguments: recipe.id,
    );
  }

  void removeRecentSearch(RecipeModel recipe) {
    recentSearches.removeWhere((item) => item.id == recipe.id);
  }

  void clearRecentSearches() {
    recentSearches.clear();
  }

  // =========================================================
  // ACTIVE FILTER GETTER
  // =========================================================

  bool get hasActiveFilters {
    return selectedCategory.value != null || selectedArea.value != null;
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void onClose() {
    _suggestionTimer?.cancel();
    searchTextController.dispose();
    super.onClose();
  }
}