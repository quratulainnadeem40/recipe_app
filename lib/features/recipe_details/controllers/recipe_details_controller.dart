import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

import 'package:recipe_app/features/recipe_details/model/recipe_detail_model.dart';
import 'package:recipe_app/features/recipe_details/repositories/recipe_detail_repository.dart';

class RecipeController extends GetxController {
  final RecipeRepository repository;

  RecipeController({
    required this.repository,
  });

  // ===========================================================
  // RECIPES
  // ===========================================================

  final RxList<Recipe> recipes = <Recipe>[].obs;

  final RxList<Recipe> filteredRecipes = <Recipe>[].obs;

  // ===========================================================
  // FILTERS
  // ===========================================================

  final RxList<String> activeFilters = <String>[].obs;

  final RxString selectedCuisine = ''.obs;

  final RxString selectedCategory = ''.obs;

  final RxString selectedDifficulty = ''.obs;

  final RxnInt selectedMaxPrepTime = RxnInt();

  // ===========================================================
  // SEARCH
  // ===========================================================

  final RxString searchQuery = ''.obs;

  final RxList<String> recentSearches = <String>[].obs;

  // ===========================================================
  // SUGGESTIONS
  // ===========================================================

  final RxList<Recipe> suggestions = <Recipe>[].obs;

  final RxBool showSuggestions = false.obs;

  // ===========================================================
  // SORT
  // ===========================================================

  final RxString selectedSort = ''.obs;

  // ===========================================================
  // LOADING / ERROR
  // ===========================================================

  final RxBool isLoading = false.obs;

  final RxString errorMessage = ''.obs;

  // ===========================================================
  // COOKING VOICE
  // ===========================================================

  final FlutterTts _tts = FlutterTts();

  final RxBool isSpeaking = false.obs;

  final RxBool isPaused = false.obs;

  final RxInt currentStep = 0.obs;

  final RxList<String> cookingSteps = <String>[].obs;

  final RxString currentInstruction = ''.obs;

  // ===========================================================
  // GETTERS
  // ===========================================================

  int get totalResults => filteredRecipes.length;

  bool get hasResults => filteredRecipes.isNotEmpty;

  bool get hasErrors => errorMessage.value.isNotEmpty;

  bool get isEmpty =>
      !isLoading.value &&
      errorMessage.value.isEmpty &&
      filteredRecipes.isEmpty;

  bool get hasActiveFilters =>
      activeFilters.isNotEmpty ||
      selectedCuisine.value.isNotEmpty ||
      selectedCategory.value.isNotEmpty ||
      selectedDifficulty.value.isNotEmpty ||
      selectedMaxPrepTime.value != null;

  // ===========================================================
  // COOKING VOICE GETTERS
  // ===========================================================

  int get totalSteps => cookingSteps.length;

  int get currentStepNumber {
    if (cookingSteps.isEmpty) {
      return 0;
    }

    return currentStep.value + 1;
  }

  double get cookingProgress {
    if (cookingSteps.isEmpty) {
      return 0.0;
    }

    return (currentStep.value + 1) / cookingSteps.length;
  }

  // ===========================================================
  // INIT
  // ===========================================================

  @override
  void onInit() {
    super.onInit();

    recentSearches.addAll([
      'Chicken Karahi',
      'Pasta Alfredo',
      'Biryani',
    ]);

    _initCookingVoice();

    loadRecipes();
  }

  // ===========================================================
  // INITIALIZE COOKING VOICE
  // ===========================================================

  Future<void> _initCookingVoice() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    _tts.setStartHandler(() {
      isSpeaking.value = true;
      isPaused.value = false;
    });

    _tts.setCompletionHandler(() {
      isSpeaking.value = false;
      isPaused.value = false;

      if (currentStep.value < cookingSteps.length - 1) {
        currentStep.value++;

        currentInstruction.value =
            cookingSteps[currentStep.value];
      }
    });

    _tts.setCancelHandler(() {
      isSpeaking.value = false;
      isPaused.value = false;
    });

    _tts.setErrorHandler((message) {
      isSpeaking.value = false;
      isPaused.value = false;

      Get.snackbar(
        'Voice Error',
        message.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  // ===========================================================
  // SET COOKING STEPS
  // ===========================================================

  void setCookingSteps(List<String> steps) {
    cookingSteps.assignAll(
      steps
          .map((step) => step.trim())
          .where((step) => step.isNotEmpty)
          .toList(),
    );

    currentStep.value = 0;

    if (cookingSteps.isNotEmpty) {
      currentInstruction.value =
          cookingSteps.first;
    } else {
      currentInstruction.value = '';
    }

    isSpeaking.value = false;
    isPaused.value = false;
  }

  // ===========================================================
  // START COOKING
  // ===========================================================

  Future<void> startCooking() async {
    if (cookingSteps.isEmpty) {
      Get.snackbar(
        'No Instructions',
        'Cooking instructions are not available.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    await _tts.stop();

    currentStep.value = 0;

    currentInstruction.value =
        cookingSteps.first;

    isPaused.value = false;

    await _tts.speak(
      currentInstruction.value,
    );
  }

  // ===========================================================
  // PAUSE VOICE
  // ===========================================================

  Future<void> pauseVoice() async {
    if (!isSpeaking.value) {
      return;
    }

    try {
      await _tts.pause();

      isSpeaking.value = false;
      isPaused.value = true;
    } catch (_) {
      isPaused.value = false;
    }
  }

  // ===========================================================
  // RESUME VOICE
  // ===========================================================

  Future<void> resumeVoice() async {
    if (!isPaused.value) {
      return;
    }

    if (currentInstruction.value.trim().isEmpty) {
      return;
    }

    try {
      await _tts.speak(
        currentInstruction.value,
      );

      isPaused.value = false;
      isSpeaking.value = true;
    } catch (_) {
      isPaused.value = false;
    }
  }

  // ===========================================================
  // NEXT STEP
  // ===========================================================

  Future<void> nextStep() async {
    if (cookingSteps.isEmpty) {
      return;
    }

    if (currentStep.value >= cookingSteps.length - 1) {
      await _tts.stop();

      isSpeaking.value = false;
      isPaused.value = false;

      return;
    }

    await _tts.stop();

    currentStep.value++;

    currentInstruction.value =
        cookingSteps[currentStep.value];

    isPaused.value = false;

    await _tts.speak(
      currentInstruction.value,
    );
  }

  // ===========================================================
  // PREVIOUS STEP
  // ===========================================================

  Future<void> previousStep() async {
    if (cookingSteps.isEmpty) {
      return;
    }

    if (currentStep.value <= 0) {
      return;
    }

    await _tts.stop();

    currentStep.value--;

    currentInstruction.value =
        cookingSteps[currentStep.value];

    isPaused.value = false;

    await _tts.speak(
      currentInstruction.value,
    );
  }

  // ===========================================================
  // REPEAT STEP
  // ===========================================================

  Future<void> repeatStep() async {
    if (cookingSteps.isEmpty) {
      return;
    }

    if (currentInstruction.value.trim().isEmpty) {
      return;
    }

    await _tts.stop();

    isPaused.value = false;

    await _tts.speak(
      currentInstruction.value,
    );
  }

  // ===========================================================
  // STOP COOKING
  // ===========================================================

  Future<void> stopCooking() async {
    await _tts.stop();

    isSpeaking.value = false;
    isPaused.value = false;

    if (cookingSteps.isNotEmpty) {
      currentStep.value = 0;

      currentInstruction.value =
          cookingSteps.first;
    }
  }

  // ===========================================================
  // LOAD ALL RECIPES
  // ===========================================================

  Future<void> loadRecipes() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final List<Recipe> result =
          await repository.getRecipes();

      recipes.assignAll(result);

      applyFilters();
    } catch (e) {
      errorMessage.value = _cleanError(e);

      recipes.clear();
      filteredRecipes.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // ===========================================================
  // SEARCH
  // ===========================================================

  void searchRecipes(String query) {
    final String cleanQuery = query.trim();

    searchQuery.value = cleanQuery;

    if (cleanQuery.isEmpty) {
      suggestions.clear();
      showSuggestions.value = false;

      applyFilters();

      return;
    }

    _updateSuggestions(cleanQuery);

    showSuggestions.value = true;

    applyFilters();

    addRecentSearch(cleanQuery);
  }

  // ===========================================================
  // SEARCH SUGGESTIONS
  // ===========================================================

  void _updateSuggestions(String query) {
    final String value = query.toLowerCase();

    final List<Recipe> result = recipes
        .where(
          (recipe) =>
              recipe.name
                  .toLowerCase()
                  .contains(value) ||
              recipe.cuisine
                  .toLowerCase()
                  .contains(value) ||
              recipe.category
                  .toLowerCase()
                  .contains(value),
        )
        .take(8)
        .toList();

    suggestions.assignAll(result);
  }

  // ===========================================================
  // SELECT SUGGESTION
  // ===========================================================

  void selectSuggestion(Recipe recipe) {
    searchQuery.value = recipe.name;

    showSuggestions.value = false;

    suggestions.clear();

    addRecentSearch(recipe.name);

    applyFilters();
  }

  // ===========================================================
  // HIDE SUGGESTIONS
  // ===========================================================

  void hideSuggestions() {
    showSuggestions.value = false;
  }

  // ===========================================================
  // RECENT SEARCH
  // ===========================================================

  void addRecentSearch(String query) {
    final String cleanQuery = query.trim();

    if (cleanQuery.isEmpty) {
      return;
    }

    recentSearches.remove(cleanQuery);

    recentSearches.insert(
      0,
      cleanQuery,
    );

    if (recentSearches.length > 5) {
      recentSearches.removeLast();
    }
  }

  // ===========================================================
  // CLEAR RECENT SEARCHES
  // ===========================================================

  void clearRecentSearches() {
    recentSearches.clear();
  }

  // ===========================================================
  // SELECT COUNTRY / CUISINE
  // ===========================================================

  void selectCuisine(String cuisine) {
    final String value = cuisine.trim();

    selectedCuisine.value = value;

    _replaceFilter(
      type: 'cuisine',
      value: value,
    );

    applyFilters();
  }

  // ===========================================================
  // SELECT CATEGORY
  // ===========================================================

  void selectCategory(String category) {
    final String value = category.trim();

    selectedCategory.value = value;

    _replaceFilter(
      type: 'category',
      value: value,
    );

    applyFilters();
  }

  // ===========================================================
  // SELECT DIFFICULTY
  // ===========================================================

  void selectDifficulty(String difficulty) {
    final String value = difficulty.trim();

    selectedDifficulty.value = value;

    _removeDifficultyFilters();

    if (value.isNotEmpty) {
      activeFilters.add(value);
    }

    applyFilters();
  }

  // ===========================================================
  // SELECT PREP TIME
  // ===========================================================

  void selectPrepTime(int? maxMinutes) {
    selectedMaxPrepTime.value = maxMinutes;

    activeFilters.removeWhere(
      (filter) =>
          filter == 'Under 15 min' ||
          filter == 'Under 30 min' ||
          filter == 'Under 45 min' ||
          filter == 'Under 60 min',
    );

    if (maxMinutes != null) {
      activeFilters.add(
        'Under $maxMinutes min',
      );
    }

    applyFilters();
  }

  // ===========================================================
  // ADD FILTER
  // ===========================================================

  void addFilter(String filter) {
    final String value = filter.trim();

    if (value.isEmpty) {
      return;
    }

    if (!activeFilters.contains(value)) {
      activeFilters.add(value);
    }

    if (value == 'Easy' ||
        value == 'Medium' ||
        value == 'Hard') {
      selectedDifficulty.value = value;
    }

    final match = RegExp(
      r'^Under\s+(\d+)\s+min$',
      caseSensitive: false,
    ).firstMatch(value);

    if (match != null) {
      selectedMaxPrepTime.value =
          int.tryParse(match.group(1)!);
    }

    applyFilters();
  }

  // ===========================================================
  // REMOVE FILTER
  // ===========================================================

  void removeFilter(String filter) {
    activeFilters.remove(filter);

    if (filter == selectedCuisine.value) {
      selectedCuisine.value = '';
    }

    if (filter == selectedCategory.value) {
      selectedCategory.value = '';
    }

    if (filter == 'Easy' ||
        filter == 'Medium' ||
        filter == 'Hard') {
      selectedDifficulty.value = '';
    }

    if (filter.startsWith('Under ')) {
      selectedMaxPrepTime.value = null;
    }

    applyFilters();
  }

  // ===========================================================
  // REPLACE FILTER
  // ===========================================================

  void _replaceFilter({
    required String type,
    required String value,
  }) {
    if (type == 'cuisine') {
      final oldCuisine =
          selectedCuisine.value;

      if (oldCuisine.isNotEmpty) {
        activeFilters.remove(oldCuisine);
      }
    }

    if (type == 'category') {
      final oldCategory =
          selectedCategory.value;

      if (oldCategory.isNotEmpty) {
        activeFilters.remove(oldCategory);
      }
    }

    if (value.isNotEmpty &&
        !activeFilters.contains(value)) {
      activeFilters.add(value);
    }
  }

  // ===========================================================
  // REMOVE DIFFICULTY FILTERS
  // ===========================================================

  void _removeDifficultyFilters() {
    activeFilters.removeWhere(
      (filter) =>
          filter == 'Easy' ||
          filter == 'Medium' ||
          filter == 'Hard',
    );
  }

  // ===========================================================
  // APPLY ALL FILTERS
  // ===========================================================

  void applyFilters() {
    List<Recipe> results =
        List<Recipe>.from(recipes);

    final String cuisine =
        selectedCuisine.value
            .trim()
            .toLowerCase();

    if (cuisine.isNotEmpty) {
      results = results
          .where(
            (recipe) =>
                recipe.cuisine
                    .trim()
                    .toLowerCase() ==
                cuisine,
          )
          .toList();
    }

    final String category =
        selectedCategory.value
            .trim()
            .toLowerCase();

    if (category.isNotEmpty) {
      results = results
          .where(
            (recipe) =>
                recipe.category
                    .trim()
                    .toLowerCase() ==
                category,
          )
          .toList();
    }

    final String difficulty =
        selectedDifficulty.value
            .trim()
            .toLowerCase();

    if (difficulty.isNotEmpty) {
      results = results
          .where(
            (recipe) =>
                recipe.difficulty
                    .trim()
                    .toLowerCase() ==
                difficulty,
          )
          .toList();
    }

    final int? maxTime =
        selectedMaxPrepTime.value;

    if (maxTime != null) {
      results = results
          .where(
            (recipe) =>
                recipe.prepTime <= maxTime,
          )
          .toList();
    }

    final String query =
        searchQuery.value
            .trim()
            .toLowerCase();

    if (query.isNotEmpty) {
      results = results.where(
        (recipe) {
          return recipe.name
                  .toLowerCase()
                  .contains(query) ||
              recipe.cuisine
                  .toLowerCase()
                  .contains(query) ||
              recipe.category
                  .toLowerCase()
                  .contains(query);
        },
      ).toList();
    }

    _sortList(
      results,
      selectedSort.value,
    );

    filteredRecipes.assignAll(results);
  }

  // ===========================================================
  // SORT
  // ===========================================================

  void sortRecipes(String sortBy) {
    selectedSort.value = sortBy.trim();

    final List<Recipe> results =
        List<Recipe>.from(
      filteredRecipes,
    );

    _sortList(
      results,
      selectedSort.value,
    );

    filteredRecipes.assignAll(results);
  }

  void _sortList(
    List<Recipe> list,
    String sortBy,
  ) {
    switch (sortBy) {
      case 'Popular':
        list.sort(
          (a, b) =>
              b.reviews.compareTo(a.reviews),
        );
        break;

      case 'Rating':
        list.sort(
          (a, b) =>
              b.rating.compareTo(a.rating),
        );
        break;

      case 'Time':
        list.sort(
          (a, b) =>
              a.prepTime.compareTo(b.prepTime),
        );
        break;
    }
  }

  // ===========================================================
  // CLEAR ALL FILTERS
  // ===========================================================

  void clearAllFilters() {
    activeFilters.clear();

    selectedCuisine.value = '';
    selectedCategory.value = '';
    selectedDifficulty.value = '';
    selectedMaxPrepTime.value = null;

    searchQuery.value = '';

    selectedSort.value = '';

    suggestions.clear();
    showSuggestions.value = false;

    filteredRecipes.assignAll(recipes);
  }

  // ===========================================================
  // CLEAR SEARCH
  // ===========================================================

  void clearSearch() {
    searchQuery.value = '';

    suggestions.clear();

    showSuggestions.value = false;

    applyFilters();
  }

  // ===========================================================
  // FAVORITE
  // ===========================================================

  void toggleFavorite(String recipeId) {
    final int index =
        recipes.indexWhere(
      (recipe) => recipe.id == recipeId,
    );

    if (index == -1) {
      return;
    }

    final Recipe oldRecipe =
        recipes[index];

    final Recipe updatedRecipe =
        oldRecipe.copyWith(
      isFavorite:
          !oldRecipe.isFavorite,
    );

    recipes[index] = updatedRecipe;

    final int filteredIndex =
        filteredRecipes.indexWhere(
      (recipe) => recipe.id == recipeId,
    );

    if (filteredIndex != -1) {
      filteredRecipes[filteredIndex] =
          updatedRecipe;
    }

    recipes.refresh();
    filteredRecipes.refresh();
  }

  // ===========================================================
  // RETRY
  // ===========================================================

  Future<void> retry() async {
    errorMessage.value = '';

    await loadRecipes();
  }

  // ===========================================================
  // ERROR CLEANER
  // ===========================================================

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst(
          'Exception: ',
          '',
        );
  }

  // ===========================================================
  // CLOSE
  // ===========================================================

  @override
  void onClose() {
    _tts.stop();

    super.onClose();
  }
}