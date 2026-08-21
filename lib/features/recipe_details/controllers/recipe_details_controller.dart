import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Ensure flutter_tts is added to pubspec.yaml
import '../model/recipe_detail_model.dart';

// REPOSITORY IMPORT: Ensure the path is correct as per your folder structure
import 'package:recipe_app/features/recipe_details/repositories/recipe_detail_repository.dart';

class RecipeController extends GetxController {
  // ==========================================
  // CORE FIX: Added Repository Dependency
  // ==========================================
  final RecipeRepository repository;

  final FlutterTts _flutterTts = FlutterTts();

  final Rxn<Recipe> recipe = Rxn<Recipe>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // ==========================================
  // VOICE ASSISTANT STATE VARIABLES & REACTIVES
  // ==========================================
  final RxBool isSpeaking = false.obs;
  final RxBool isPaused = false.obs;
  final RxInt currentStep = 0.obs;
  final RxString currentInstruction = 'Tap Play to start cooking guide!'.obs;

  List<String> _stepsToSpeak = [];

  // ==========================================
  // CORE FIX: Constructor accepting the Repository
  // ==========================================
  RecipeController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    _initTts();

    // Auto-update instructions whenever recipe details change
    ever(recipe, (Recipe? r) {
      if (r != null && r.steps.isNotEmpty) {
        _stepsToSpeak = r.steps;
        currentInstruction.value = r.steps.first;
      }
    });
  }

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
      debugPrint("TTS Error: $msg");
      stopSpeaking();
    });
  }

  // ==========================================
  // GETTERS EXPECTED BY COOKING VOICE SCREEN
  // ==========================================
  int get totalSteps => _stepsToSpeak.isNotEmpty ? _stepsToSpeak.length : (recipe.value?.steps.length ?? 0);
  int get currentStepNumber => (totalSteps > 0) ? (currentStep.value + 1) : 0;
  double get cookingProgress => (totalSteps > 0) ? (currentStep.value + 1) / totalSteps : 0.0;

  // ==========================================
  // COOKING VOICE METHOD CONNECTIONS
  // ==========================================

  // Starts cooking narration from step 1
  void startCooking() {
    if (_stepsToSpeak.isEmpty && recipe.value != null) {
      _stepsToSpeak = recipe.value!.steps;
    }
    if (_stepsToSpeak.isNotEmpty) {
      currentStep.value = 0;
      isSpeaking.value = true;
      isPaused.value = false;
      _speakCurrentStep();
    }
  }

  // Resumes speaking safely
  Future<void> resumeVoice() async {
    isPaused.value = false;
    await _speakCurrentStep();
  }

  // Pauses speaking safely
  Future<void> pauseVoice() async {
    await _flutterTts.stop();
    isPaused.value = true;
  }

  // Repeats active step reading
  Future<void> repeatStep() async {
    await _speakCurrentStep();
  }

  // Go to previous step
  Future<void> previousStep() async {
    if (currentStep.value > 0) {
      currentStep.value--;
      await _speakCurrentStep();
    }
  }

  // Go to next step
  Future<void> nextStep() async {
    if (currentStep.value + 1 < totalSteps) {
      currentStep.value++;
      await _speakCurrentStep();
    }
  }

  // Stop everything
  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
    isSpeaking.value = false;
    isPaused.value = false;
    currentStep.value = 0;
    if (_stepsToSpeak.isNotEmpty) {
      currentInstruction.value = _stepsToSpeak.first;
    }
  }

  // Helper read functions
  Future<void> _speakCurrentStep() async {
    if (_stepsToSpeak.isEmpty && recipe.value != null) {
      _stepsToSpeak = recipe.value!.steps;
    }
    if (_stepsToSpeak.isEmpty) return;

    if (currentStep.value < _stepsToSpeak.length) {
      String textToSpeak = _stepsToSpeak[currentStep.value];
      currentInstruction.value = textToSpeak;
      await _flutterTts.speak("Step ${currentStep.value + 1}: $textToSpeak");
    } else {
      stopSpeaking();
    }
  }

  Future<void> _speakNextStepAuto() async {
    if (currentStep.value + 1 < _stepsToSpeak.length) {
      currentStep.value++;
      await _speakCurrentStep();
    } else {
      stopSpeaking();
    }
  }

  Future<void> startSpeaking(List<String> steps) async {
    _stepsToSpeak = steps;
    currentStep.value = 0;
    isSpeaking.value = true;
    isPaused.value = false;
    await _speakCurrentStep();
  }

  Future<void> pauseSpeaking() async {
    await pauseVoice();
  }

  Future<void> resumeSpeaking() async {
    await resumeVoice();
  }

  Future<void> speakSpecificStep(List<String> steps, int index) async {
    _stepsToSpeak = steps;
    currentStep.value = index;
    isSpeaking.value = true;
    isPaused.value = false;
    await _speakCurrentStep();
  }

  void toggleFavorite(String id) {
    if (recipe.value != null && recipe.value!.id == id) {
      final updatedRecipe = Recipe(
        id: recipe.value!.id,
        name: recipe.value!.name,
        cuisine: recipe.value!.cuisine,
        category: recipe.value!.category,
        rating: recipe.value!.rating,
        reviews: recipe.value!.reviews,
        difficulty: recipe.value!.difficulty,
        imageUrl: recipe.value!.imageUrl,
        prepTime: recipe.value!.prepTime,
        ingredients: recipe.value!.ingredients,
        steps: recipe.value!.steps,
        instructions: recipe.value!.instructions,
        youtubeUrl: recipe.value!.youtubeUrl,
        isFavorite: !recipe.value!.isFavorite,
      );
      recipe.value = updatedRecipe;
    }
  }

  void retry() {
    errorMessage.value = '';
  }

  @override
  void onClose() {
    _flutterTts.stop();
    super.onClose();
  }
}