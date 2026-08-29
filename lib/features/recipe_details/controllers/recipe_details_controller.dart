import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:recipe_app/features/favorites/controllers/favorites_controller.dart';
import 'package:recipe_app/features/favorites/models/favorite_recipe_model.dart';

import '../model/recipe_detail_model.dart';


import 'package:recipe_app/features/recipe_details/repositories/recipe_detail_repository.dart';

class RecipeController extends GetxController {
  // =========================================================
  // REPOSITORY
  // =========================================================

  final RecipeRepository repository;

  // =========================================================
  // TTS
  // =========================================================

  final FlutterTts _flutterTts = FlutterTts();

  // =========================================================
  // RECIPE STATE
  // =========================================================

  final Rxn<Recipe> recipe = Rxn<Recipe>();

  final RxBool isLoading = false.obs;

  final RxString errorMessage = ''.obs;

  // =========================================================
  // VOICE ASSISTANT STATE
  // =========================================================

  final RxBool isSpeaking = false.obs;

  final RxBool isPaused = false.obs;

  final RxInt currentStep = 0.obs;

  final RxString currentInstruction =
      'Tap Play to start cooking guide!'.obs;

  List<String> _stepsToSpeak = [];

  // =========================================================
  // CONSTRUCTOR
  // =========================================================

  RecipeController({
    required this.repository,
  });

  // =========================================================
  // ON INIT
  // =========================================================

  @override
  void onInit() {
    super.onInit();

    _initTts();

    // Update voice steps whenever recipe changes
    ever<Recipe?>(recipe, (Recipe? r) {
      if (r != null) {
        if (r.steps.isNotEmpty) {
          _stepsToSpeak = r.steps;
          currentInstruction.value = r.steps.first;
        }

        // Sync favorite state
        _syncFavoriteState();
      }
    });
  }

  // =========================================================
  // TTS INITIALIZATION
  // =========================================================

  void _initTts() {
    _flutterTts.setStartHandler(() {
      isSpeaking.value = true;
      isPaused.value = false;
    });

    _flutterTts.setCompletionHandler(() {
      _speakNextStepAuto();
    });

    _flutterTts.setCancelHandler(() {
      isSpeaking.value = false;
      isPaused.value = false;
    });

    _flutterTts.setErrorHandler((msg) {
      debugPrint('TTS Error: $msg');
      stopSpeaking();
    });
  }

  // =========================================================
  // VOICE GETTERS
  // =========================================================

  int get totalSteps {
    return _stepsToSpeak.isNotEmpty
        ? _stepsToSpeak.length
        : (recipe.value?.steps.length ?? 0);
  }

  int get currentStepNumber {
    return totalSteps > 0
        ? currentStep.value + 1
        : 0;
  }

  double get cookingProgress {
    return totalSteps > 0
        ? (currentStep.value + 1) / totalSteps
        : 0.0;
  }

  // =========================================================
  // FAVORITES CONTROLLER
  // =========================================================

  FavoritesController get favoritesController {
    if (Get.isRegistered<FavoritesController>()) {
      return Get.find<FavoritesController>();
    }

    return Get.put(FavoritesController());
  }

  // =========================================================
  // SYNC FAVORITE STATE
  // =========================================================

  void _syncFavoriteState() {
    final currentRecipe = recipe.value;

    if (currentRecipe == null) {
      return;
    }

    if (currentRecipe.id.trim().isEmpty) {
      return;
    }

    final bool actualFavoriteState =
        favoritesController.isFavorite(
      currentRecipe.id,
    );

    if (currentRecipe.isFavorite != actualFavoriteState) {
      recipe.value = Recipe(
        id: currentRecipe.id,
        name: currentRecipe.name,
        cuisine: currentRecipe.cuisine,
        category: currentRecipe.category,
        rating: currentRecipe.rating,
        reviews: currentRecipe.reviews,
        difficulty: currentRecipe.difficulty,
        imageUrl: currentRecipe.imageUrl,
        prepTime: currentRecipe.prepTime,
        ingredients: currentRecipe.ingredients,
        steps: currentRecipe.steps,
        instructions: currentRecipe.instructions,
        youtubeUrl: currentRecipe.youtubeUrl,
        isFavorite: actualFavoriteState,
      );
    }
  }

  // =========================================================
  // TOGGLE FAVORITE
  // =========================================================
  //
  // NOTE:
  // RecipeDetailScreen now handles its favorite button
  // directly through FavoritesController.
  //
  // This method is kept for backward compatibility with
  // any other screen/controller that may still call it.
  // =========================================================

  void toggleFavorite(String id) {
    final currentRecipe = recipe.value;

    if (currentRecipe == null) {
      debugPrint(
        'toggleFavorite: Recipe is not loaded in RecipeController.',
      );
      return;
    }

    if (currentRecipe.id != id) {
      debugPrint(
        'toggleFavorite: Recipe ID mismatch.',
      );
      return;
    }

    if (id.trim().isEmpty) {
      return;
    }

    final favoriteRecipe = FavoriteRecipeModel(
      id: currentRecipe.id,
      name: currentRecipe.name,
      image: currentRecipe.imageUrl,
    );

    // Actual favorite storage
    favoritesController.toggleFavorite(
      favoriteRecipe,
    );

    // Update local recipe state
    final bool newFavoriteState =
        favoritesController.isFavorite(
      currentRecipe.id,
    );

    recipe.value = Recipe(
      id: currentRecipe.id,
      name: currentRecipe.name,
      cuisine: currentRecipe.cuisine,
      category: currentRecipe.category,
      rating: currentRecipe.rating,
      reviews: currentRecipe.reviews,
      difficulty: currentRecipe.difficulty,
      imageUrl: currentRecipe.imageUrl,
      prepTime: currentRecipe.prepTime,
      ingredients: currentRecipe.ingredients,
      steps: currentRecipe.steps,
      instructions: currentRecipe.instructions,
      youtubeUrl: currentRecipe.youtubeUrl,
      isFavorite: newFavoriteState,
    );

    // Existing snackbar behavior preserved
    Get.snackbar(
      newFavoriteState
          ? 'Added to Favorites ❤️'
          : 'Removed from Favorites 💔',
      newFavoriteState
          ? '${currentRecipe.name} added to favorites.'
          : '${currentRecipe.name} removed from favorites.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }

  // =========================================================
  // SET FAVORITE STATE
  // =========================================================

  void setFavoriteState(bool value) {
    final currentRecipe = recipe.value;

    if (currentRecipe == null) {
      return;
    }

    recipe.value = Recipe(
      id: currentRecipe.id,
      name: currentRecipe.name,
      cuisine: currentRecipe.cuisine,
      category: currentRecipe.category,
      rating: currentRecipe.rating,
      reviews: currentRecipe.reviews,
      difficulty: currentRecipe.difficulty,
      imageUrl: currentRecipe.imageUrl,
      prepTime: currentRecipe.prepTime,
      ingredients: currentRecipe.ingredients,
      steps: currentRecipe.steps,
      instructions: currentRecipe.instructions,
      youtubeUrl: currentRecipe.youtubeUrl,
      isFavorite: value,
    );
  }

  // =========================================================
  // CHECK FAVORITE
  // =========================================================

  bool isFavorite(String id) {
    if (id.trim().isEmpty) {
      return false;
    }

    return favoritesController.isFavorite(id);
  }

  // =========================================================
  // START COOKING
  // =========================================================

  void startCooking() {
    if (_stepsToSpeak.isEmpty &&
        recipe.value != null) {
      _stepsToSpeak = recipe.value!.steps;
    }

    if (_stepsToSpeak.isNotEmpty) {
      currentStep.value = 0;
      isSpeaking.value = true;
      isPaused.value = false;

      _speakCurrentStep();
    }
  }

  // =========================================================
  // RESUME VOICE
  // =========================================================

  Future<void> resumeVoice() async {
    isPaused.value = false;

    await _speakCurrentStep();
  }

  // =========================================================
  // PAUSE VOICE
  // =========================================================

  Future<void> pauseVoice() async {
    await _flutterTts.stop();

    isPaused.value = true;
  }

  // =========================================================
  // REPEAT STEP
  // =========================================================

  Future<void> repeatStep() async {
    await _speakCurrentStep();
  }

  // =========================================================
  // PREVIOUS STEP
  // =========================================================

  Future<void> previousStep() async {
    if (currentStep.value > 0) {
      currentStep.value--;

      await _speakCurrentStep();
    }
  }

  // =========================================================
  // NEXT STEP
  // =========================================================

  Future<void> nextStep() async {
    if (currentStep.value + 1 < totalSteps) {
      currentStep.value++;

      await _speakCurrentStep();
    }
  }

  // =========================================================
  // STOP SPEAKING
  // =========================================================

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();

    isSpeaking.value = false;
    isPaused.value = false;
    currentStep.value = 0;

    if (_stepsToSpeak.isNotEmpty) {
      currentInstruction.value =
          _stepsToSpeak.first;
    }
  }

  // =========================================================
  // SPEAK CURRENT STEP
  // =========================================================

  Future<void> _speakCurrentStep() async {
    if (_stepsToSpeak.isEmpty &&
        recipe.value != null) {
      _stepsToSpeak = recipe.value!.steps;
    }

    if (_stepsToSpeak.isEmpty) {
      return;
    }

    if (currentStep.value <
        _stepsToSpeak.length) {
      final String textToSpeak =
          _stepsToSpeak[currentStep.value];

      currentInstruction.value =
          textToSpeak;

      await _flutterTts.speak(
        'Step ${currentStep.value + 1}: $textToSpeak',
      );
    } else {
      await stopSpeaking();
    }
  }

  // =========================================================
  // AUTO NEXT STEP
  // =========================================================

  Future<void> _speakNextStepAuto() async {
    if (currentStep.value + 1 <
        _stepsToSpeak.length) {
      currentStep.value++;

      await _speakCurrentStep();
    } else {
      await stopSpeaking();
    }
  }

  // =========================================================
  // START SPEAKING
  // =========================================================

  Future<void> startSpeaking(
    List<String> steps,
  ) async {
    _stepsToSpeak = steps;

    currentStep.value = 0;

    isSpeaking.value = true;
    isPaused.value = false;

    await _speakCurrentStep();
  }

  // =========================================================
  // PAUSE SPEAKING
  // =========================================================

  Future<void> pauseSpeaking() async {
    await pauseVoice();
  }

  // =========================================================
  // RESUME SPEAKING
  // =========================================================

  Future<void> resumeSpeaking() async {
    await resumeVoice();
  }

  // =========================================================
  // SPEAK SPECIFIC STEP
  // =========================================================

  Future<void> speakSpecificStep(
    List<String> steps,
    int index,
  ) async {
    if (steps.isEmpty) {
      return;
    }

    _stepsToSpeak = steps;

    currentStep.value =
        index.clamp(0, steps.length - 1);

    isSpeaking.value = true;
    isPaused.value = false;

    await _speakCurrentStep();
  }

  // =========================================================
  // CLOSE
  // =========================================================

  @override
  void onClose() {
    _flutterTts.stop();

    super.onClose();
  }
}