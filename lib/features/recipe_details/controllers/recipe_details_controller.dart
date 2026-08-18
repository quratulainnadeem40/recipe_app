import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

import 'package:recipe_app/features/home/models/recipe_models.dart';
import 'package:recipe_app/features/recipe_details/model/recipe_detail_model.dart';
import 'package:recipe_app/features/recipe_details/repositories/recipe_detail_repository.dart';

class RecipeDetailsController extends GetxController {
  final RecipeDetailsRepository repository;

  RecipeDetailsController({
    required this.repository,
  });

  // =========================================================
  // RECIPE DETAILS
  // =========================================================

  final Rxn<RecipeDetailsModel> recipe =
      Rxn<RecipeDetailsModel>();

  // =========================================================
  // UI STATE
  // =========================================================

  final RxBool isLoading = false.obs;

  final RxString errorMessage = ''.obs;

  final RxInt currentImageIndex = 0.obs;

  // =========================================================
  // RECIPE ID
  // =========================================================

  String? recipeId;

  // =========================================================
  // TEXT TO SPEECH
  // =========================================================

  final FlutterTts flutterTts = FlutterTts();

  final RxBool isSpeaking = false.obs;

  final RxBool isPaused = false.obs;

  String _lastSpokenText = '';

  // =========================================================
  // INITIALIZATION
  // =========================================================

  @override
  void onInit() {
    super.onInit();

    _initializeTts();

    _handleArguments();
  }

  // =========================================================
  // INITIALIZE TTS
  // =========================================================

  Future<void> _initializeTts() async {
    try {
      await flutterTts.setLanguage('en-US');
      await flutterTts.setSpeechRate(0.45);
      await flutterTts.setPitch(1.0);
      await flutterTts.setVolume(1.0);

      // -------------------------------------------------------
      // START
      // -------------------------------------------------------

      flutterTts.setStartHandler(() {
        isSpeaking.value = true;
        isPaused.value = false;
      });

      // -------------------------------------------------------
      // COMPLETE
      // -------------------------------------------------------

      flutterTts.setCompletionHandler(() {
        isSpeaking.value = false;
        isPaused.value = false;
      });

      // -------------------------------------------------------
      // CANCEL
      // -------------------------------------------------------

      flutterTts.setCancelHandler(() {
        isSpeaking.value = false;
        isPaused.value = false;
      });

      // -------------------------------------------------------
      // ERROR
      // -------------------------------------------------------

      flutterTts.setErrorHandler((message) {
        isSpeaking.value = false;
        isPaused.value = false;
      });

      // -------------------------------------------------------
      // PAUSE
      // -------------------------------------------------------

      flutterTts.setPauseHandler(() {
        isSpeaking.value = false;
        isPaused.value = true;
      });

      // -------------------------------------------------------
      // CONTINUE
      // -------------------------------------------------------

      flutterTts.setContinueHandler(() {
        isSpeaking.value = true;
        isPaused.value = false;
      });
    } catch (_) {
      // TTS initialization failure should not break
      // the Recipe Details screen.
    }
  }

  // =========================================================
  // HANDLE ROUTE ARGUMENTS
  // =========================================================

  void _handleArguments() {
    final dynamic arguments = Get.arguments;

    // ---------------------------------------------------------
    // CASE 1: RecipeModel
    // ---------------------------------------------------------

    if (arguments is RecipeModel) {
      final String id = arguments.id.trim();

      if (id.isNotEmpty) {
        recipeId = id;
        getRecipeDetails(id);
      } else {
        errorMessage.value = 'Recipe ID not found.';
      }

      return;
    }

    // ---------------------------------------------------------
    // CASE 2: String ID
    // ---------------------------------------------------------

    if (arguments is String) {
      final String id = arguments.trim();

      if (id.isNotEmpty) {
        recipeId = id;
        getRecipeDetails(id);
      } else {
        errorMessage.value = 'Recipe ID not found.';
      }

      return;
    }

    // ---------------------------------------------------------
    // CASE 3: Invalid / Missing Arguments
    // ---------------------------------------------------------

    errorMessage.value =
        'Recipe information not found.';
  }

  // =========================================================
  // GET RECIPE DETAILS
  // =========================================================

  Future<void> getRecipeDetails(
    String id,
  ) async {
    final String cleanId = id.trim();

    if (cleanId.isEmpty) {
      recipe.value = null;

      errorMessage.value =
          'Recipe ID not found.';

      return;
    }

    try {
      isLoading.value = true;

      errorMessage.value = '';

      currentImageIndex.value = 0;

      // -------------------------------------------------------
      // STOP CURRENT SPEECH
      // -------------------------------------------------------

      await stopRecipe();

      // -------------------------------------------------------
      // LOAD RECIPE FROM API
      // -------------------------------------------------------

      final RecipeDetailsModel result =
          await repository.getRecipeDetails(
        cleanId,
      );

      // -------------------------------------------------------
      // VALIDATE RESPONSE
      // -------------------------------------------------------

      if (result.id.trim().isEmpty) {
        recipe.value = null;

        errorMessage.value =
            'Recipe details not found.';

        return;
      }

      // -------------------------------------------------------
      // SUCCESS
      // -------------------------------------------------------

      recipe.value = result;

      recipeId = result.id.trim();
    } catch (_) {
      recipe.value = null;

      errorMessage.value =
          'Failed to load recipe details.';
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================
  // BUILD RECIPE VOICE TEXT
  // =========================================================

  String _buildRecipeSpeech() {
    final RecipeDetailsModel? currentRecipe =
        recipe.value;

    if (currentRecipe == null) {
      return '';
    }

    // ---------------------------------------------------------
    // INGREDIENTS
    // ---------------------------------------------------------

    final List<String> ingredientLines = [];

    for (
      int index = 0;
      index < currentRecipe.ingredients.length;
      index++
    ) {
      final String ingredient =
          currentRecipe.ingredients[index].trim();

      if (ingredient.isEmpty) {
        continue;
      }

      final String measure =
          index < currentRecipe.measures.length
              ? currentRecipe.measures[index].trim()
              : '';

      if (measure.isNotEmpty) {
        ingredientLines.add(
          '$measure of $ingredient',
        );
      } else {
        ingredientLines.add(ingredient);
      }
    }

    final String ingredientsText =
        ingredientLines.join('. ');

    // ---------------------------------------------------------
    // INSTRUCTIONS
    // ---------------------------------------------------------

    final String instructions =
        currentRecipe.instructions.trim();

    // ---------------------------------------------------------
    // COMPLETE SPEECH
    // ---------------------------------------------------------

    return '''
Recipe name: ${currentRecipe.name.trim()}.

Category: ${currentRecipe.category.trim()}.

Cuisine: ${currentRecipe.area.trim()}.

Ingredients:
$ingredientsText.

Cooking instructions:
$instructions.
''';
  }

  // =========================================================
  // SPEAK RECIPE
  // =========================================================

  Future<void> speakRecipe() async {
    final String speechText =
        _buildRecipeSpeech();

    if (speechText.trim().isEmpty) {
      return;
    }

    try {
      // Stop previous speech first.
      await flutterTts.stop();

      _lastSpokenText = speechText;

      isSpeaking.value = true;
      isPaused.value = false;

      await flutterTts.setLanguage('en-US');
      await flutterTts.setSpeechRate(0.45);
      await flutterTts.setPitch(1.0);
      await flutterTts.setVolume(1.0);

      await flutterTts.speak(
        _lastSpokenText,
      );
    } catch (_) {
      isSpeaking.value = false;
      isPaused.value = false;

      Get.snackbar(
        'Voice Error',
        'Unable to play the recipe voice.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // =========================================================
  // PAUSE RECIPE
  // =========================================================

  Future<void> pauseRecipe() async {
    if (!isSpeaking.value) {
      return;
    }

    try {
      await flutterTts.pause();

      isSpeaking.value = false;
      isPaused.value = true;
    } catch (_) {
      // Ignore unsupported pause errors.
    }
  }

  // =========================================================
  // RESUME RECIPE
  // =========================================================
  //
  // flutter_tts does not provide reliable cross-platform
  // resume-from-exact-word behavior.
  //
  // Therefore Resume starts the saved recipe speech again.
  // =========================================================

  Future<void> resumeRecipe() async {
    if (!isPaused.value) {
      return;
    }

    if (_lastSpokenText.trim().isEmpty) {
      await speakRecipe();
      return;
    }

    try {
      await flutterTts.stop();

      isSpeaking.value = true;
      isPaused.value = false;

      await flutterTts.speak(
        _lastSpokenText,
      );
    } catch (_) {
      isSpeaking.value = false;
      isPaused.value = false;
    }
  }

  // =========================================================
  // STOP RECIPE
  // =========================================================

  Future<void> stopRecipe() async {
    try {
      await flutterTts.stop();
    } catch (_) {
      // Ignore stop errors.
    }

    isSpeaking.value = false;
    isPaused.value = false;
  }

  // =========================================================
  // SPEECH SPEED
  // =========================================================

  Future<void> setSpeechRate(
    double rate,
  ) async {
    await flutterTts.setSpeechRate(rate);
  }

  // =========================================================
  // CHANGE IMAGE
  // =========================================================

  void changeImage(
    int index,
  ) {
    if (index < 0) {
      return;
    }

    currentImageIndex.value = index;
  }

  // =========================================================
  // RETRY
  // =========================================================

  Future<void> retry() async {
    final String? id = recipeId;

    if (id != null && id.trim().isNotEmpty) {
      await getRecipeDetails(id);
      return;
    }

    _handleArguments();
  }

  // =========================================================
  // CLEANUP
  // =========================================================

  @override
  void onClose() {
    flutterTts.stop();

    recipe.value = null;

    errorMessage.value = '';

    recipeId = null;

    isSpeaking.value = false;

    isPaused.value = false;

    _lastSpokenText = '';

    super.onClose();
  }
}