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

  final TextEditingController searchTextController =
      TextEditingController();

  final RxString searchQuery = ''.obs;

  // =========================================================
  // RESULTS
  // =========================================================

  final RxList<RecipeModel> searchResults =
      <RecipeModel>[].obs;

  final RxList<RecipeModel> filteredResults =
      <RecipeModel>[].obs;

  // =========================================================
  // LIVE SUGGESTIONS
  // =========================================================

  final RxList<RecipeModel> suggestions =
      <RecipeModel>[].obs;

  final RxBool showSuggestions = false.obs;

  final RxBool isSuggestionLoading = false.obs;

  Timer? _suggestionTimer;

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

  // =========================================================
  // ERROR
  // =========================================================

  final RxString errorMessage = ''.obs;

  // =========================================================
  // REQUEST ID
  // Prevents old API response from replacing new result
  // =========================================================

  int _searchRequestId = 0;

  int _suggestionRequestId = 0;

  // =========================================================
  // CATEGORIES
  // =========================================================

  final List<String> categories = const [
    'Beef',
    'Breakfast',
    'Chicken',
    'Dessert',
    'Goat',
    'Lamb',
    'Miscellaneous',
    'Pasta',
    'Pork',
    'Seafood',
    'Side',
    'Starter',
    'Vegan',
    'Vegetarian',
  ];

  // =========================================================
  // COUNTRIES / AREAS
  // =========================================================

  final List<String> areas = const [
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
  // INITIALIZATION
  // =========================================================

  @override
  void onInit() {
    super.onInit();

    _handleArguments();
  }

  // =========================================================
  // HANDLE ROUTE ARGUMENTS
  // =========================================================

  void _handleArguments() {
    final arguments = Get.arguments;

    // ---------------------------------------------------------
    // STRING ARGUMENT
    // Example:
    // Get.toNamed(AppRoutes.search, arguments: 'Indian');
    // ---------------------------------------------------------

    if (arguments is String &&
        arguments.trim().isNotEmpty) {
      final value = arguments.trim();

      selectedArea.value = value;

      loadCountryRecipes(value);

      return;
    }

    // ---------------------------------------------------------
    // MAP ARGUMENTS
    // ---------------------------------------------------------

    if (arguments is! Map) {
      return;
    }

    final type =
        arguments['type']?.toString().trim() ?? '';

    final category =
        arguments['category']?.toString().trim() ?? '';

    final area =
        arguments['area']?.toString().trim() ?? '';

    final query =
        arguments['query']?.toString().trim() ?? '';

    // ---------------------------------------------------------
    // ALL COUNTRIES
    // ---------------------------------------------------------

    if (type == 'allCountries') {
      clearResultsOnly();
      return;
    }

    // ---------------------------------------------------------
    // ALL CATEGORIES
    // ---------------------------------------------------------

    if (type == 'allCategories') {
      clearResultsOnly();
      return;
    }

    // ---------------------------------------------------------
    // COUNTRY
    // ---------------------------------------------------------

    if (type == 'country' && area.isNotEmpty) {
      selectedArea.value = area;

      loadCountryRecipes(area);

      return;
    }

    // ---------------------------------------------------------
    // CATEGORY
    // ---------------------------------------------------------

    if (type == 'category' &&
        category.isNotEmpty) {
      selectedCategory.value = category;

      loadCategoryRecipes(category);

      return;
    }

    // ---------------------------------------------------------
    // QUERY
    // ---------------------------------------------------------

    if (type == 'query' &&
        query.isNotEmpty) {
      searchTextController.text = query;

      searchQuery.value = query;

      searchRecipes(query);

      return;
    }

    // ---------------------------------------------------------
    // FALLBACK CATEGORY
    // ---------------------------------------------------------

    if (category.isNotEmpty) {
      selectedCategory.value = category;

      loadCategoryRecipes(category);

      return;
    }

    // ---------------------------------------------------------
    // FALLBACK AREA
    // ---------------------------------------------------------

    if (area.isNotEmpty) {
      selectedArea.value = area;

      loadCountryRecipes(area);

      return;
    }

    // ---------------------------------------------------------
    // FALLBACK QUERY
    // ---------------------------------------------------------

    if (query.isNotEmpty) {
      searchTextController.text = query;

      searchQuery.value = query;

      searchRecipes(query);
    }
  }

  // =========================================================
  // SEARCH TEXT CHANGED
  // =========================================================

  void onSearchTextChanged(String value) {
    final query = value.trim();

    searchQuery.value = query;

    _suggestionTimer?.cancel();

    // Empty search
    if (query.isEmpty) {
      suggestions.clear();

      showSuggestions.value = false;

      isSuggestionLoading.value = false;

      return;
    }

    // Don't search for only one character
    if (query.length < 2) {
      suggestions.clear();

      showSuggestions.value = false;

      isSuggestionLoading.value = false;

      return;
    }

    showSuggestions.value = true;

    isSuggestionLoading.value = true;

    final requestId = ++_suggestionRequestId;

    _suggestionTimer = Timer(
      const Duration(milliseconds: 350),
      () {
        loadSuggestions(
          query,
          requestId,
        );
      },
    );
  }

  // =========================================================
  // LOAD SUGGESTIONS
  // =========================================================

  Future<void> loadSuggestions(
    String query,
    int requestId,
  ) async {
    final cleanQuery = query.trim();

    if (cleanQuery.isEmpty) {
      return;
    }

    try {
      final result =
          await repository.searchRecipes(
        cleanQuery,
      );

      // Ignore old API response
      if (requestId != _suggestionRequestId) {
        return;
      }

      if (searchQuery.value.trim() !=
          cleanQuery) {
        return;
      }

      final limited =
          result.take(5).toList();

      suggestions.assignAll(limited);

      showSuggestions.value =
          suggestions.isNotEmpty;
    } catch (_) {
      if (requestId !=
          _suggestionRequestId) {
        return;
      }

      suggestions.clear();

      showSuggestions.value = false;
    } finally {
      if (requestId ==
          _suggestionRequestId) {
        isSuggestionLoading.value = false;
      }
    }
  }

  // =========================================================
  // SELECT SUGGESTION
  // =========================================================

  void selectSuggestion(
    RecipeModel recipe,
  ) {
    _suggestionTimer?.cancel();

    searchTextController.text =
        recipe.name;

    searchTextController.selection =
        TextSelection.fromPosition(
      TextPosition(
        offset:
            searchTextController.text.length,
      ),
    );

    searchQuery.value =
        recipe.name;

    suggestions.clear();

    showSuggestions.value = false;

    isSuggestionLoading.value = false;

    _addRecentSearch(recipe);

    _openRecipe(recipe);
  }

  // =========================================================
  // SEARCH RECIPES
  // =========================================================

  Future<void> searchRecipes(
    String value,
  ) async {
    final query = value.trim();

    _suggestionTimer?.cancel();

    suggestions.clear();

    showSuggestions.value = false;

    isSuggestionLoading.value = false;

    searchQuery.value = query;

    errorMessage.value = '';

    // Empty query
    if (query.isEmpty) {
      searchResults.clear();

      filteredResults.clear();

      return;
    }

    final requestId =
        ++_searchRequestId;

    try {
      isLoading.value = true;

      final result =
          await repository.searchRecipes(
        query,
      );

      // Ignore old response
      if (requestId !=
          _searchRequestId) {
        return;
      }

      searchResults.assignAll(result);

      // Search result should show directly
      filteredResults.assignAll(result);

      // Save only a few recent results
      _addRecentSearches(result);

      if (result.isEmpty) {
        errorMessage.value =
            'No recipes found for "$query".';
      }
    } catch (_) {
      if (requestId !=
          _searchRequestId) {
        return;
      }

      searchResults.clear();

      filteredResults.clear();

      errorMessage.value =
          'Failed to search recipes. Please try again.';
    } finally {
      if (requestId ==
          _searchRequestId) {
        isLoading.value = false;
      }
    }
  }

  // =========================================================
  // LOAD COUNTRY RECIPES
  // =========================================================

  Future<void> loadCountryRecipes(
    String country,
  ) async {
    final cleanCountry =
        country.trim();

    if (cleanCountry.isEmpty) {
      return;
    }

    final requestId =
        ++_searchRequestId;

    try {
      isLoading.value = true;

      errorMessage.value = '';

      selectedArea.value =
          cleanCountry;

      final result =
          await repository.getRecipesByCountry(
        cleanCountry,
      );

      if (requestId !=
          _searchRequestId) {
        return;
      }

      searchResults.assignAll(result);

      filteredResults.assignAll(result);

      if (result.isEmpty) {
        errorMessage.value =
            'No recipes found for $cleanCountry.';
      }
    } catch (_) {
      if (requestId !=
          _searchRequestId) {
        return;
      }

      searchResults.clear();

      filteredResults.clear();

      errorMessage.value =
          'Failed to load $cleanCountry recipes.';
    } finally {
      if (requestId ==
          _searchRequestId) {
        isLoading.value = false;
      }
    }
  }

  // =========================================================
  // LOAD CATEGORY RECIPES
  // =========================================================

  Future<void> loadCategoryRecipes(
    String category,
  ) async {
    final cleanCategory =
        category.trim();

    if (cleanCategory.isEmpty) {
      return;
    }

    final requestId =
        ++_searchRequestId;

    try {
      isLoading.value = true;

      errorMessage.value = '';

      selectedCategory.value =
          cleanCategory;

      final result =
          await repository.getRecipesByCategory(
        cleanCategory,
      );

      if (requestId !=
          _searchRequestId) {
        return;
      }

      searchResults.assignAll(result);

      filteredResults.assignAll(result);

      if (result.isEmpty) {
        errorMessage.value =
            'No recipes found for $cleanCategory.';
      }
    } catch (_) {
      if (requestId !=
          _searchRequestId) {
        return;
      }

      searchResults.clear();

      filteredResults.clear();

      errorMessage.value =
          'Failed to load $cleanCategory recipes.';
    } finally {
      if (requestId ==
          _searchRequestId) {
        isLoading.value = false;
      }
    }
  }

  // =========================================================
  // SET AREA
  // =========================================================

  Future<void> setArea(
    String? area,
  ) async {
    final value =
        area?.trim() ?? '';

    if (value.isEmpty) {
      selectedArea.value = null;

      _applyFilters();

      return;
    }

    selectedArea.value = value;

    await loadCountryRecipes(value);
  }

  // =========================================================
  // SET CATEGORY
  // =========================================================

  Future<void> setCategory(
    String? category,
  ) async {
    final value =
        category?.trim() ?? '';

    if (value.isEmpty) {
      selectedCategory.value = null;

      _applyFilters();

      return;
    }

    selectedCategory.value =
        value;

    await loadCategoryRecipes(value);
  }

  // =========================================================
  // APPLY FILTERS
  // =========================================================

  void _applyFilters() {
    final category =
        selectedCategory.value
            ?.trim()
            .toLowerCase();

    final area =
        selectedArea.value
            ?.trim()
            .toLowerCase();

    final result =
        searchResults.where(
      (recipe) {
        final recipeCategory =
            recipe.category
                .trim()
                .toLowerCase();

        final recipeArea =
            recipe.area
                .trim()
                .toLowerCase();

        final categoryMatches =
            category == null ||
                category.isEmpty ||
                recipeCategory ==
                    category;

        final areaMatches =
            area == null ||
                area.isEmpty ||
                recipeArea == area;

        return categoryMatches &&
            areaMatches;
      },
    ).toList();

    filteredResults
        .assignAll(result);
  }

  // =========================================================
  // CLEAR AREA
  // =========================================================

  void clearArea() {
    selectedArea.value = null;

    if (selectedCategory.value !=
        null) {
      loadCategoryRecipes(
        selectedCategory.value!,
      );
      return;
    }

    _applyFilters();
  }

  // =========================================================
  // CLEAR CATEGORY
  // =========================================================

  void clearCategory() {
    selectedCategory.value = null;

    if (selectedArea.value !=
        null) {
      loadCountryRecipes(
        selectedArea.value!,
      );
      return;
    }

    _applyFilters();
  }

  // =========================================================
  // CLEAR SEARCH
  // =========================================================

  void clearSearch() {
    _suggestionTimer?.cancel();

    ++_suggestionRequestId;

    ++_searchRequestId;

    searchTextController.clear();

    searchQuery.value = '';

    suggestions.clear();

    showSuggestions.value = false;

    isSuggestionLoading.value = false;

    errorMessage.value = '';

    // If country is selected,
    // show country recipes again.
    if (selectedArea.value != null &&
        selectedArea.value!
            .trim()
            .isNotEmpty) {
      loadCountryRecipes(
        selectedArea.value!,
      );
      return;
    }

    // If category is selected,
    // show category recipes again.
    if (selectedCategory.value !=
            null &&
        selectedCategory.value!
            .trim()
            .isNotEmpty) {
      loadCategoryRecipes(
        selectedCategory.value!,
      );
      return;
    }

    searchResults.clear();

    filteredResults.clear();
  }

  // =========================================================
  // CLEAR RESULTS ONLY
  // =========================================================

  void clearResultsOnly() {
    searchResults.clear();

    filteredResults.clear();

    suggestions.clear();

    showSuggestions.value = false;

    errorMessage.value = '';
  }

  // =========================================================
  // RETRY
  // =========================================================

  Future<void> retry() async {
    if (selectedArea.value !=
            null &&
        selectedArea.value!
            .trim()
            .isNotEmpty) {
      await loadCountryRecipes(
        selectedArea.value!,
      );

      return;
    }

    if (selectedCategory.value !=
            null &&
        selectedCategory.value!
            .trim()
            .isNotEmpty) {
      await loadCategoryRecipes(
        selectedCategory.value!,
      );

      return;
    }

    if (searchQuery.value
        .trim()
        .isNotEmpty) {
      await searchRecipes(
        searchQuery.value,
      );

      return;
    }
  }

  // =========================================================
  // RECENT SEARCH
  // =========================================================

  void _addRecentSearch(
    RecipeModel recipe,
  ) {
    if (recipe.id.trim().isEmpty) {
      return;
    }

    recentSearches.removeWhere(
      (item) =>
          item.id == recipe.id,
    );

    recentSearches.insert(
      0,
      recipe,
    );

    if (recentSearches.length > 10) {
      recentSearches.removeRange(
        10,
        recentSearches.length,
      );
    }
  }

  // =========================================================
  // ADD RECENT SEARCHES
  // =========================================================

  void _addRecentSearches(
    List<RecipeModel> recipes,
  ) {
    for (final recipe
        in recipes.take(5)) {
      _addRecentSearch(recipe);
    }
  }

  // =========================================================
  // SELECT RECIPE
  // =========================================================

  void selectRecipe(
    RecipeModel recipe,
  ) {
    _addRecentSearch(recipe);

    _openRecipe(recipe);
  }

  // =========================================================
  // OPEN RECIPE DETAILS
  // =========================================================

  void _openRecipe(
    RecipeModel recipe,
  ) {
    if (recipe.id.trim().isEmpty) {
      return;
    }

    Get.toNamed(
      AppRoutes.recipeDetails,
      arguments: {
        'recipeId': recipe.id,
      },
    );
  }

  // =========================================================
  // REMOVE RECENT SEARCH
  // =========================================================

  void removeRecentSearch(
    RecipeModel recipe,
  ) {
    recentSearches.removeWhere(
      (item) =>
          item.id == recipe.id,
    );
  }

  // =========================================================
  // CLEAR RECENT SEARCHES
  // =========================================================

  void clearRecentSearches() {
    recentSearches.clear();
  }

  // =========================================================
  // ACTIVE FILTERS
  // =========================================================

  bool get hasActiveFilters {
    return selectedCategory.value !=
            null ||
        selectedArea.value != null;
  }

  // =========================================================
  // RESULT LIST
  // =========================================================

  List<RecipeModel> get displayedResults {
    return filteredResults;
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