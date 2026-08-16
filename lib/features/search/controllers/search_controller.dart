
import 'package:get/get.dart';

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
  // SEARCH TEXT
  // =========================================================

  final RxString searchQuery = ''.obs;

  // =========================================================
  // SELECTED CATEGORY
  // =========================================================

  final RxnString selectedCategory =
      RxnString();

  // =========================================================
  // SELECTED AREA / COUNTRY
  // =========================================================

  final RxnString selectedArea =
      RxnString();

  // =========================================================
  // LOADING
  // =========================================================

  final RxBool isLoading = false.obs;

  // =========================================================
  // ERROR
  // =========================================================

  final RxString errorMessage = ''.obs;

  // =========================================================
  // AVAILABLE CATEGORIES
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
  // AVAILABLE AREAS / COUNTRIES
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
  // SEARCH
  // =========================================================

  Future<void> searchRecipes(String query) async {
    final trimmedQuery = query.trim();

    searchQuery.value = trimmedQuery;
    errorMessage.value = '';

    if (trimmedQuery.isEmpty) {
      searchResults.clear();
      filteredResults.clear();
      return;
    }

    try {
      isLoading.value = true;

      final result =
          await repository.searchRecipes(trimmedQuery);

      searchResults.assignAll(result);

      _applyFilters();
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
  // APPLY CATEGORY + AREA FILTERS
  // =========================================================

  void _applyFilters() {
    final category =
        selectedCategory.value?.trim().toLowerCase();

    final area =
        selectedArea.value?.trim().toLowerCase();

    final result = searchResults.where(
      (recipe) {
        final categoryMatches =
            category == null ||
            category.isEmpty ||
            recipe.category.trim().toLowerCase() ==
                category;

        final areaMatches =
            area == null ||
            area.isEmpty ||
            recipe.area.trim().toLowerCase() ==
                area;

        return categoryMatches && areaMatches;
      },
    ).toList();

    filteredResults.assignAll(result);
  }

  // =========================================================
  // CATEGORY FILTER
  // =========================================================

  Future<void> setCategory(String? category) async {
    selectedCategory.value = category;

    _applyFilters();
  }

  // =========================================================
  // AREA / COUNTRY FILTER
  // =========================================================

  Future<void> setArea(String? area) async {
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
    searchQuery.value = '';

    searchResults.clear();
    filteredResults.clear();

    errorMessage.value = '';

    selectedCategory.value = null;
    selectedArea.value = null;
  }

  // =========================================================
  // ACTIVE FILTER CHECK
  // =========================================================

  bool get hasActiveFilters {
    return selectedCategory.value != null ||
        selectedArea.value != null;
  }
}

