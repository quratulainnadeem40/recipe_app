import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/features/home/models/recipe_models.dart'; // [5]
import 'package:recipe_app/features/home/repositories/home_repository.dart'; // [5]
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

  // Master lists for fallback
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

  // ============================================================
  // DYNAMIC FILTER LISTS (ONLY OPTIONS WITH AVAILABLE RECIPES)
  // ============================================================

  List<String> get availableAreas {
    final Map<String, int> counts = {};
    for (final r in allRecipes) {
      final area = r.area.trim();
      if (area.isNotEmpty) {
        counts[area] = (counts[area] ?? 0) + 1;
      }
    }
    final list = counts.keys.toList()..sort();
    return list;
  }

  int getRecipeCountForArea(String area) {
    return allRecipes
        .where((r) => r.area.toLowerCase() == area.toLowerCase())
        .length;
  }

  List<String> get availableCategories {
    final Map<String, int> counts = {};
    for (final r in allRecipes) {
      final cat = r.category.trim();
      if (cat.isNotEmpty) {
        counts[cat] = (counts[cat] ?? 0) + 1;
      }
    }
    final list = counts.keys.toList()..sort();
    return list;
  }

  int getRecipeCountForCategory(String category) {
    return allRecipes
        .where((r) => r.category.toLowerCase() == category.toLowerCase())
        .length;
  }

  List<String> get availableDifficulties {
    final list = ['Easy', 'Medium', 'Hard'];
    return list
        .where((d) => getRecipeCountForDifficulty(d) > 0)
        .toList();
  }

  int getRecipeCountForDifficulty(String diff) {
    return allRecipes.where((r) => r.difficulty == diff).length;
  }

  List<String> get availableTimes {
    final times = [
      'Under 15 mins',
      'Under 30 mins',
      'Under 45 mins',
      'Under 60 mins',
    ];
    return times.where((t) => getRecipeCountForTime(t) > 0).toList();
  }

  int getRecipeCountForTime(String timeFilter) {
    return allRecipes.where((r) {
      final time = r.estimatedTimeMinutes;
      if (timeFilter.contains('15') && time <= 15) return true;
      if (timeFilter.contains('30') && time <= 30) return true;
      if (timeFilter.contains('45') && time <= 45) return true;
      if (timeFilter.contains('60') && time <= 60) return true;
      return false;
    }).length;
  }

  List<String> get availableDiets {
    final diets = ['Vegetarian', 'Vegan', 'Healthy'];
    return diets.where((d) => getRecipeCountForDiet(d) > 0).toList();
  }

  int getRecipeCountForDiet(String diet) {
    return allRecipes.where((r) {
      if (diet == 'Vegetarian' && r.isVegetarian) return true;
      if (diet == 'Vegan' && r.isVegan) return true;
      if (diet == 'Healthy' && r.isHealthy) return true;
      return false;
    }).length;
  }


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

Future<void> _handleExploreNavigation(
  NavigationController navigationController,
) async {
  final type = navigationController.exploreType.value;
  if (type.isEmpty) return;

  if (type == 'allCountries' ||
      type == 'allCategories' ||
      type == 'trending') {
    activeFilters.clear();
    selectedArea.value = null;
    selectedCategory.value = null;
    searchTextController.clear();
    searchQuery.value = '';

    searchResults.assignAll(allRecipes);
    _applyFilters();
    return;
  }

  if (type == 'country') {
    final area = navigationController.exploreArea.value.trim();
    activeFilters.clear();
    selectedCategory.value = null;
    selectedArea.value = area.isNotEmpty ? area : null;

    if (area.isNotEmpty && !activeFilters.contains(area)) {
      activeFilters.add(area);
    }

    searchTextController.clear();
    searchQuery.value = '';

    // Immediately filter current recipes
    searchResults.assignAll(allRecipes);
    _applyFilters();

    // Also fetch all country recipes from API to guarantee full coverage
    if (area.isNotEmpty) {
      try {
        isLoading.value = true;
        final countryRecipes = await repository.getRecipesByCountry(area);
        if (countryRecipes.isNotEmpty) {
          for (final r in countryRecipes) {
            if (!allRecipes.any((existing) => existing.id == r.id)) {
              allRecipes.add(r);
            }
          }
          searchResults.assignAll(allRecipes);
          _applyFilters();
        }
      } catch (_) {
      } finally {
        isLoading.value = false;
      }
    }
    return;
  }

  if (type == 'category') {
    final category = navigationController.exploreCategory.value.trim();
    activeFilters.clear();
    selectedArea.value = null;
    selectedCategory.value = category.isNotEmpty ? category : null;

    if (category.isNotEmpty && !activeFilters.contains(category)) {
      activeFilters.add(category);
    }

    searchTextController.clear();
    searchQuery.value = '';

    // Immediately filter current recipes
    searchResults.assignAll(allRecipes);
    _applyFilters();

    // Also fetch all category recipes from API to guarantee full coverage
    if (category.isNotEmpty) {
      try {
        isLoading.value = true;
        final catRecipes = await repository.getRecipesByCategory(category);
        if (catRecipes.isNotEmpty) {
          for (final r in catRecipes) {
            if (!allRecipes.any((existing) => existing.id == r.id)) {
              allRecipes.add(r);
            }
          }
          searchResults.assignAll(allRecipes);
          _applyFilters();
        }
      } catch (_) {
      } finally {
        isLoading.value = false;
      }
    }
    return;
  }

  if (type == 'query') {
    activeFilters.clear();
    selectedArea.value = null;
    selectedCategory.value = null;

    final query = navigationController.exploreQuery.value.trim();
    searchTextController.text = query;
    searchRecipes(query);
    return;
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
    if (selectedArea.value != null &&
        selectedArea.value!.toLowerCase() == filter.toLowerCase()) {
      selectedArea.value = null;
    }
    if (selectedCategory.value != null &&
        selectedCategory.value!.toLowerCase() == filter.toLowerCase()) {
      selectedCategory.value = null;
    }
    if (activeFilters.contains(filter)) {
      activeFilters.remove(filter);
    }
    _applyFilters();
  }

  void toggleFilter(String filter) {
    if (activeFilters.contains(filter)) {
      removeFilter(filter);
    } else {
      addFilter(filter);
    }
  }


  // Filter computation logic across all categories
  void _applyFilters() {
    List<RecipeModel> temp = searchQuery.value.trim().isEmpty
        ? List.from(allRecipes)
        : List.from(searchResults);

    // 1. Text Query Filter (if active)
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      temp = temp.where((recipe) {
        return recipe.name.toLowerCase().contains(query) ||
            recipe.category.toLowerCase().contains(query) ||
            recipe.area.toLowerCase().contains(query) ||
            recipe.shortInfo.toLowerCase().contains(query);
      }).toList();
    }

    // 2. Category Filter (selectedCategory or from activeFilters)
    final activeCategoryFilters = activeFilters
        .where((f) =>
            availableCategories.contains(f) || categories.contains(f))
        .toList();

    if (selectedCategory.value != null &&
        selectedCategory.value!.isNotEmpty &&
        !activeCategoryFilters.contains(selectedCategory.value)) {
      activeCategoryFilters.add(selectedCategory.value!);
    }

    if (activeCategoryFilters.isNotEmpty) {
      temp = temp.where((recipe) {
        return activeCategoryFilters.any(
          (c) => c.toLowerCase() == recipe.category.toLowerCase(),
        );
      }).toList();
    }

    // 3. Area / Cuisine Filter (selectedArea or from activeFilters)
    final activeCuisineFilters = activeFilters
        .where((f) => availableAreas.contains(f) || areas.contains(f))
        .toList();

    if (selectedArea.value != null &&
        selectedArea.value!.isNotEmpty &&
        !activeCuisineFilters.contains(selectedArea.value)) {
      activeCuisineFilters.add(selectedArea.value!);
    }

    if (activeCuisineFilters.isNotEmpty) {
      temp = temp.where((recipe) {
        return activeCuisineFilters.any(
          (c) => c.toLowerCase() == recipe.area.toLowerCase(),
        );
      }).toList();
    }

    // 4. Difficulty Filter ('Easy', 'Medium', 'Hard')
    final selectedDifficulties = activeFilters
        .where((f) => ['Easy', 'Medium', 'Hard'].contains(f))
        .toList();

    if (selectedDifficulties.isNotEmpty) {
      temp = temp.where((recipe) {
        return selectedDifficulties.contains(recipe.difficulty);
      }).toList();
    }

    // 5. Prep Time Filter ('Under 15 mins', 'Under 30 mins', 'Under 45 mins', 'Under 60 mins')
    final selectedTimes =
        activeFilters.where((f) => f.contains('min')).toList();

    if (selectedTimes.isNotEmpty) {
      temp = temp.where((recipe) {
        final time = recipe.estimatedTimeMinutes;
        for (final tf in selectedTimes) {
          if (tf.contains('15') && time <= 15) return true;
          if (tf.contains('30') && time <= 30) return true;
          if (tf.contains('45') && time <= 45) return true;
          if (tf.contains('60') && time <= 60) return true;
        }
        return false;
      }).toList();
    }

    // 6. Dietary Filter ('Vegetarian', 'Vegan', 'Healthy')
    final selectedDiets = activeFilters
        .where((f) => ['Vegetarian', 'Vegan', 'Healthy'].contains(f))
        .toList();

    if (selectedDiets.isNotEmpty) {
      temp = temp.where((recipe) {
        for (final diet in selectedDiets) {
          if (diet == 'Vegetarian' && recipe.isVegetarian) return true;
          if (diet == 'Vegan' && recipe.isVegan) return true;
          if (diet == 'Healthy' && recipe.isHealthy) return true;
        }
        return false;
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
    searchResults.assignAll(allRecipes);
    _applyFilters();
  }

  bool get hasActiveFilters =>
      activeFilters.isNotEmpty ||
      selectedCuisine.value.isNotEmpty ||
      selectedArea.value != null ||
      selectedCategory.value != null;


  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}