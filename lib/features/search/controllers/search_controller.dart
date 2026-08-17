
import 'dart:async';

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
  // SEARCH RESULTS
  // =========================================================

  final RxList<RecipeModel> searchResults =
      <RecipeModel>[].obs;

  // =========================================================
  // FILTERED RESULTS
  // =========================================================

  final RxList<RecipeModel> filteredResults =
      <RecipeModel>[].obs;

  // =========================================================
  // SEARCH QUERY
  // =========================================================

  final RxString searchQuery = ''.obs;

  // =========================================================
  // SUGGESTIONS
  // =========================================================

  final RxList<RecipeModel> suggestions =
      <RecipeModel>[].obs;

  // =========================================================
  // RECENT SEARCHES
  // =========================================================

  final RxList<RecipeModel> recentSearches =
      <RecipeModel>[].obs;

  // =========================================================
  // FILTERS
  // =========================================================

  final RxnString selectedCategory = RxnString();

  final RxnString selectedArea = RxnString();

  // =========================================================
  // LOADING
  // =========================================================

  final RxBool isLoading = false.obs;

  final RxBool isSuggestionLoading = false.obs;

  // =========================================================
  // ERROR
  // =========================================================

  final RxString errorMessage = ''.obs;

  // =========================================================
  // DEBOUNCE TIMER
  // =========================================================

  Timer? _suggestionTimer;

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
  // AREAS / CUISINES
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
  ];

  // =========================================================
  // TEXT CHANGE
  // =========================================================

  void onSearchTextChanged(String text) {
    final query = text.trim();

    searchQuery.value = query;
    errorMessage.value = '';

    _suggestionTimer?.cancel();

    if (query.isEmpty) {
      suggestions.clear();
      isSuggestionLoading.value = false;
      return;
    }

    // Wait until user stops typing.
    // This prevents an API call for every character.
    _suggestionTimer = Timer(
      const Duration(milliseconds: 350),
      () {
        loadSuggestions(query);
      },
    );
  }

  // =========================================================
  // LOAD SUGGESTIONS
  // =========================================================

  Future<void> loadSuggestions(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      suggestions.clear();
      return;
    }

    try {
      isSuggestionLoading.value = true;

      final result = await repository.searchRecipes(
        trimmedQuery,
      );

      // Do not show stale results for an old query.
      if (searchQuery.value.trim() != trimmedQuery) {
        return;
      }

      suggestions.assignAll(
        result.take(6).toList(),
      );
    } catch (e) {
      suggestions.clear();
    } finally {
      if (searchQuery.value.trim() == trimmedQuery) {
        isSuggestionLoading.value = false;
      }
    }
  }

  // =========================================================
  // SEARCH RECIPES
  // =========================================================

  Future<void> searchRecipes(String query) async {
    final trimmedQuery = query.trim();

    _suggestionTimer?.cancel();

    searchQuery.value = trimmedQuery;
    errorMessage.value = '';

    suggestions.clear();

    if (trimmedQuery.isEmpty) {
      searchResults.clear();
      filteredResults.clear();
      return;
    }

    try {
      isLoading.value = true;

      final result = await repository.searchRecipes(
        trimmedQuery,
      );

      searchResults.assignAll(result);

      _applyFilters();

      _addRecentSearches(result);
    } catch (e) {
      searchResults.clear();
      filteredResults.clear();

      errorMessage.value =
          'Failed to search recipes. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================
  // SELECT SUGGESTION
  //
  // IMPORTANT:
  // Details API requires the recipe ID.
  //
  // RecipeModel.id comes from:
  // idMeal
  //
  // Therefore we pass recipe.id to Recipe Details.
  // =========================================================

  void selectSuggestion(RecipeModel recipe) {
    if (recipe.id.trim().isEmpty) {
      Get.snackbar(
        'Recipe Error',
        'Recipe ID is missing.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    _suggestionTimer?.cancel();

    searchQuery.value = recipe.name;

    suggestions.clear();

    errorMessage.value = '';

    // Keep recipe in search results.
    searchResults.assignAll([recipe]);

    _applyFilters();

    _addRecentSearches([recipe]);

    // =======================================================
    // OPEN RECIPE DETAILS
    // =======================================================

    Get.toNamed(
      AppRoutes.recipeDetails,
      arguments: recipe.id,
    );
  }

  // =========================================================
  // APPLY FILTERS
  // =========================================================

  void _applyFilters() {
    final category =
        selectedCategory.value?.trim().toLowerCase();

    final area =
        selectedArea.value?.trim().toLowerCase();

    final result = searchResults.where(
      (recipe) {
        final recipeCategory =
            recipe.category.trim().toLowerCase();

        final recipeArea =
            recipe.area.trim().toLowerCase();

        final categoryMatches =
            category == null ||
            category.isEmpty ||
            recipeCategory == category;

        final areaMatches =
            area == null ||
            area.isEmpty ||
            recipeArea == area;

        return categoryMatches && areaMatches;
      },
    ).toList();

    filteredResults.assignAll(result);
  }

  // =========================================================
  // CATEGORY FILTER
  // =========================================================

  void setCategory(String? category) {
    selectedCategory.value = category;

    _applyFilters();
  }

  // =========================================================
  // AREA FILTER
  // =========================================================

  void setArea(String? area) {
    selectedArea.value = area;

    _applyFilters();
  }

  // =========================================================
  // CLEAR FILTERS
  // =========================================================

  void clearFilters() {
    selectedCategory.value = null;
    selectedArea.value = null;

    _applyFilters();
  }

  // =========================================================
  // CLEAR SEARCH
  // =========================================================

  void clearSearch() {
    _suggestionTimer?.cancel();

    searchQuery.value = '';

    searchResults.clear();
    filteredResults.clear();
    suggestions.clear();

    errorMessage.value = '';

    selectedCategory.value = null;
    selectedArea.value = null;

    isSuggestionLoading.value = false;
  }

  // =========================================================
  // RECENT SEARCHES
  // =========================================================

  void _addRecentSearches(
    List<RecipeModel> recipes,
  ) {
    for (final recipe in recipes.take(5)) {
      if (recipe.id.trim().isEmpty) {
        continue;
      }

      final exists = recentSearches.any(
        (item) => item.id == recipe.id,
      );

      if (!exists) {
        recentSearches.insert(0, recipe);
      }
    }

    if (recentSearches.length > 10) {
      recentSearches.removeRange(
        10,
        recentSearches.length,
      );
    }
  }

  // =========================================================
  // SELECT RECENT RECIPE
  // =========================================================

  void selectRecipe(RecipeModel recipe) {
    selectSuggestion(recipe);
  }

  // =========================================================
  // REMOVE RECENT SEARCH
  // =========================================================

  void removeRecentSearch(
    RecipeModel recipe,
  ) {
    recentSearches.removeWhere(
      (item) => item.id == recipe.id,
    );
  }

  // =========================================================
  // CLEAR ALL RECENT SEARCHES
  // =========================================================

  void clearRecentSearches() {
    recentSearches.clear();
  }

  // =========================================================
  // ACTIVE FILTER CHECK
  // =========================================================

  bool get hasActiveFilters {
    return selectedCategory.value != null ||
        selectedArea.value != null;
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void onClose() {
    _suggestionTimer?.cancel();
    super.onClose();
  }
}

