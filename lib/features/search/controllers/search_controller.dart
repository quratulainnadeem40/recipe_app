import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/features/home/models/recipe_models.dart'; // [5]
import 'package:recipe_app/features/home/repositories/home_repository.dart'; // [5]
import 'package:recipe_app/features/home/repositories/home_repository.dart';
import 'package:recipe_app/features/navigation/controllers/navigation_controller.dart';

// Class name badal kar RecipeSearchController kiya taake Flutter SDK se clash na ho
class RecipeSearchController extends GetxController {
  final HomeRepository repository; // [5]

  RecipeSearchController({required this.repository}); // [5]

  // Core Variables
  final TextEditingController searchTextController = TextEditingController(); // [2]
  final RxString searchQuery = ''.obs; // [2]
  final RxBool isLoading = false.obs; // [4]
  final RxString errorMessage = ''.obs; // [4]

  // Results Lists (RecipeModel standard use ho raha hai) [2, 3]
  final RxList<RecipeModel> searchResults = <RecipeModel>[].obs;
  final RxList<RecipeModel> filteredResults = <RecipeModel>[].obs;
  final RxList<RecipeModel> allRecipes = <RecipeModel>[].obs;

  // Live Suggestions & Recent Searches [3]
  final RxList<RecipeModel> suggestions = <RecipeModel>[].obs;
  final RxBool showSuggestions = false.obs;
  final RxBool isSuggestionLoading = false.obs;
  final RxList<RecipeModel> recentSearches = <RecipeModel>[].obs;

  // Filters UI State
  final RxList<String> activeFilters = <String>[].obs; 
  final RxnString selectedCategory = RxnString(); // [4]
  final RxnString selectedArea = RxnString(); // [4]
  final RxString selectedCuisine = ''.obs;

  // Tracking request
  int _searchRequestId = 0; // [6]

  // UI List View Getter
  List<RecipeModel> get displayedResults => filteredResults;

  // Dropdown lists for UI [6, 7]
  final List<String> categories = const [
    'Beef', 'Breakfast', 'Chicken', 'Dessert', 'Goat', 'Lamb', 
    'Miscellaneous', 'Pasta', 'Pork', 'Seafood', 'Side', 'Starter', 'Vegan', 'Vegetarian',
  ];

  final List<String> areas = const [
    'American', 'British', 'Canadian', 'Chinese', 'Croatian', 'Dutch', 
    'Egyptian', 'Filipino', 'French', 'Greek', 'Indian', 'Irish', 'Italian', 
    'Jamaican', 'Japanese', 'Kenyan', 'Malaysian', 'Mexican', 'Moroccan', 
    'Pakistani', 'Polish', 'Portuguese', 'Russian', 'Spanish', 'Thai', 
    'Tunisian', 'Turkish', 'Ukrainian', 'Uruguayan', 'Vietnamese',
  ];

@override
void onInit() {
  super.onInit();

  loadInitialRecipes();

  ever(selectedCuisine, (cuisine) {
    selectedArea.value =
        cuisine.isEmpty ? null : cuisine;

    _applyFilters();
  });

  final navigationController =
      Get.find<NavigationController>();

  ever(
    navigationController.exploreType,
    (_) {
      _handleExploreNavigation(navigationController);
    },
  );
}

void _handleExploreNavigation(
  NavigationController navigationController,
) {
  final type = navigationController.exploreType.value;

  if (type == 'allCountries') {
    selectedArea.value = null;
    selectedCategory.value = null;
    searchTextController.clear();
    searchQuery.value = '';

    searchResults.assignAll(allRecipes);
    _applyFilters();
  }

  if (type == 'allCategories') {
    selectedArea.value = null;
    selectedCategory.value = null;
    searchTextController.clear();
    searchQuery.value = '';

    searchResults.assignAll(allRecipes);
    _applyFilters();
  }

  if (type == 'trending') {
    selectedArea.value = null;
    selectedCategory.value = null;
    searchTextController.clear();
    searchQuery.value = '';

    searchResults.assignAll(allRecipes);
    _applyFilters();
  }

  if (type == 'country') {
    selectedCategory.value = null;
    selectedArea.value =
        navigationController.exploreArea.value;

    searchTextController.clear();
    searchQuery.value = '';

    searchResults.assignAll(allRecipes);
    _applyFilters();
  }

  if (type == 'category') {
    selectedArea.value = null;
    selectedCategory.value =
        navigationController.exploreCategory.value;

    searchTextController.clear();
    searchQuery.value = '';

    searchResults.assignAll(allRecipes);
    _applyFilters();
  }

  if (type == 'query') {
    selectedArea.value = null;
    selectedCategory.value = null;

    final query =
        navigationController.exploreQuery.value;

    searchTextController.text = query;

    searchRecipes(query);
  }
}
  Future<void> loadInitialRecipes() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Empty search → HomeRepository getAllRecipes()
      final recipes = await repository.searchRecipes('');

      allRecipes.assignAll(recipes);
      searchResults.assignAll(recipes);

      _applyFilters();
    } catch (e) {
      errorMessage.value =
          'Failed to load recipes: ${e.toString()}';

      print('Error loading initial recipes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchRecipes(String value) async {
    final query = value.trim();

    searchQuery.value = query;
    isLoading.value = true;
    errorMessage.value = '';

    _searchRequestId++;
    final requestId = _searchRequestId;

    try {
      List<RecipeModel> results;

      if (query.isEmpty) {
        results = List.from(allRecipes);
      } else {
        results = await repository.searchRecipes(query);
      }

      if (requestId == _searchRequestId) {
        searchResults.assignAll(results);
        _applyFilters();
      }
    } catch (e) {
      if (requestId == _searchRequestId) {
        errorMessage.value = e.toString();
      }
    } finally {
      if (requestId == _searchRequestId) {
        isLoading.value = false;
      }
    }
  }



  // Filter actions
  void addFilter(String filter) {
    if (!activeFilters.contains(filter)) {
      activeFilters.add(filter);
      _applyFilters();
    }
  }

  void removeFilter(String filter) {
    if (activeFilters.contains(filter)) {
      activeFilters.remove(filter);
      _applyFilters();
    }
  }

  // Filter computation logic [9]
  void _applyFilters() {
    List<RecipeModel> temp = List.from(searchResults);

    // 1. Category filter
    if (selectedCategory.value != null && selectedCategory.value!.isNotEmpty) {
      temp = temp.where((recipe) => 
        recipe.category.toLowerCase() == selectedCategory.value!.toLowerCase()
      ).toList();
    }

    // 2. Area/Cuisine filter
    if (selectedArea.value != null && selectedArea.value!.isNotEmpty) {
      temp = temp.where((recipe) => 
        recipe.area.toLowerCase() == selectedArea.value!.toLowerCase()
      ).toList();
    }

    // 3. Easy/Medium/Hard mock difficulties matching logic
    if (activeFilters.isNotEmpty) {
      temp = temp.where((recipe) {
        bool matches = true;
        final selectedDifficulty = activeFilters.where((f) => ['Easy', 'Medium', 'Hard'].contains(f)).toList();
        if (selectedDifficulty.isNotEmpty) {
          matches = matches && (recipe.category.isEmpty || selectedDifficulty.any((d) => recipe.category.contains(d) || recipe.id.hashCode % 3 == 0));
        }
        return matches;
      }).toList();
    }

    filteredResults.assignAll(temp);
  }

  void clearAllFilters() {
    activeFilters.clear();
    selectedCuisine.value = '';
    selectedArea.value = null;
    selectedCategory.value = null;
    searchTextController.clear();
    searchQuery.value = '';
    searchRecipes('');
  }

  bool get hasActiveFilters => activeFilters.isNotEmpty || selectedCuisine.value.isNotEmpty;

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}