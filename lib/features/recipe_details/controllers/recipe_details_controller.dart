import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

import '../model/recipe_detail_model.dart';
import '../repositories/recipe_detail_repository.dart';

class RecipeDetailsController extends GetxController {
  final RecipeDetailsRepository repository;

  RecipeDetailsController({
    required this.repository,
  });

  // ===========================================================
  // TTS
  // ===========================================================

  final FlutterTts _tts = FlutterTts();

  // ===========================================================
  // RECIPE DATA
  // ===========================================================

  final Rxn<RecipeDetailsModel> recipeDetails =
      Rxn<RecipeDetailsModel>();

  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  // ===========================================================
  // FAVORITE
  // ===========================================================

  final RxBool isFavorite = false.obs;

  // ===========================================================
  // COOKING STATE
  // ===========================================================

  final RxInt currentStepIndex = 0.obs;

  final RxBool isSpeaking = false.obs;

  final RxBool isPaused = false.obs;

  final RxBool isCooking = false.obs;

  // ===========================================================
  // VOICE TYPE
  // ===========================================================

  final RxString voiceMode = 'none'.obs;

  // none
  // ingredient
  // instruction

  // ===========================================================
  // INITIALIZATION
  // ===========================================================

  @override
  void onInit() {
    super.onInit();

    _setupTts();

    final String? recipeId =
        Get.arguments?.toString();

    if (recipeId != null &&
        recipeId.isNotEmpty) {
      fetchDetails(recipeId);
    } else {
      isLoading.value = false;
      errorMessage.value =
          'Invalid Recipe ID';
    }
  }

  // ===========================================================
  // SETUP TTS
  // ===========================================================

  Future<void> _setupTts() async {
    await _tts.setLanguage('en-US');

    await _tts.setSpeechRate(0.45);

    await _tts.setPitch(1.0);

    await _tts.setVolume(1.0);

    await _tts.awaitSpeakCompletion(true);

    _tts.setStartHandler(() {
      isSpeaking.value = true;
      isPaused.value = false;
    });

    _tts.setCompletionHandler(() {
      isSpeaking.value = false;
      isPaused.value = false;
      voiceMode.value = 'none';

      // Automatically move to next instruction
      // only during Start Cooking mode.
      if (isCooking.value &&
          instructionSteps.isNotEmpty) {
        if (currentStepIndex.value <
            instructionSteps.length - 1) {
          currentStepIndex.value++;
          _speakCurrentInstruction();
        } else {
          isCooking.value = false;
        }
      }
    });

    _tts.setCancelHandler(() {
      isSpeaking.value = false;
      isPaused.value = false;
    });

    _tts.setErrorHandler((message) {
      isSpeaking.value = false;
      isPaused.value = false;
      voiceMode.value = 'none';
    });
  }

  // ===========================================================
  // FETCH DETAILS
  // ===========================================================

  Future<void> fetchDetails(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await stopVoice();

      final details =
          await repository.getRecipeDetails(id);

      recipeDetails.value = details;

      currentStepIndex.value = 0;
    } catch (e) {
      errorMessage.value =
          e.toString().replaceAll(
                'Exception: ',
                '',
              );
    } finally {
      isLoading.value = false;
    }
  }

  // ===========================================================
  // RETRY
  // ===========================================================

  Future<void> retry() async {
    final String? recipeId =
        Get.arguments?.toString();

    if (recipeId == null ||
        recipeId.isEmpty) {
      errorMessage.value =
          'Invalid Recipe ID';
      return;
    }

    await fetchDetails(recipeId);
  }

  // ===========================================================
  // INSTRUCTION STEPS
  // ===========================================================

  List<String> get instructionSteps {
    final recipe = recipeDetails.value;

    if (recipe == null) {
      return [];
    }

    return _splitInstructions(
      recipe.instructions,
    );
  }

  // ===========================================================
  // TOTAL STEPS
  // ===========================================================

  int get totalSteps {
    return instructionSteps.length;
  }

  // ===========================================================
  // CURRENT STEP NUMBER
  // ===========================================================

  int get currentStepNumber {
    if (totalSteps == 0) {
      return 0;
    }

    return currentStepIndex.value + 1;
  }

  // ===========================================================
  // CURRENT INSTRUCTION
  // ===========================================================

  String get currentInstruction {
    if (instructionSteps.isEmpty) {
      return '';
    }

    final int index =
        currentStepIndex.value;

    if (index < 0 ||
        index >= instructionSteps.length) {
      return '';
    }

    return instructionSteps[index];
  }

  // ===========================================================
  // COOKING PROGRESS
  // ===========================================================

  double get cookingProgress {
    if (totalSteps == 0) {
      return 0;
    }

    return currentStepNumber / totalSteps;
  }

  // ===========================================================
  // SPLIT INSTRUCTIONS
  // ===========================================================

  List<String> _splitInstructions(
    String instructions,
  ) {
    if (instructions.trim().isEmpty) {
      return [];
    }

    final cleaned =
        instructions
            .replaceAll('\r\n', '\n')
            .replaceAll('\r', '\n')
            .trim();

    // First try newline-based instructions.
    final lines = cleaned
        .split('\n')
        .map(
          (e) => e.trim(),
        )
        .where(
          (e) => e.isNotEmpty,
        )
        .toList();

    if (lines.length > 1) {
      return lines
          .map(_cleanStepText)
          .where(
            (e) => e.isNotEmpty,
          )
          .toList();
    }

    // If API gives one large paragraph,
    // split using sentence endings.
    final sentences = cleaned
        .split(
          RegExp(
            r'(?<=[.!?])\s+',
          ),
        )
        .map(
          (e) => e.trim(),
        )
        .where(
          (e) => e.isNotEmpty,
        )
        .toList();

    if (sentences.isNotEmpty) {
      return sentences
          .map(_cleanStepText)
          .where(
            (e) => e.isNotEmpty,
          )
          .toList();
    }

    return [_cleanStepText(cleaned)];
  }

  // ===========================================================
  // CLEAN STEP
  // ===========================================================

  String _cleanStepText(String value) {
    return value
        .replaceFirst(
          RegExp(
            r'^\s*\d+[\.\)\-:]\s*',
          ),
          '',
        )
        .replaceFirst(
          RegExp(
            r'^\s*(step)\s*\d+[\.\:\-]?\s*',
            caseSensitive: false,
          ),
          '',
        )
        .trim();
  }

  // ===========================================================
  // SELECT STEP
  // ===========================================================

  Future<void> selectStep(int index) async {
    if (index < 0 ||
        index >= instructionSteps.length) {
      return;
    }

    isCooking.value = false;

    await stopVoice();

    currentStepIndex.value = index;

    await speakInstruction(
      index,
    );
  }

  // ===========================================================
  // SPEAK ONE INSTRUCTION
  // ===========================================================

  Future<void> speakInstruction(
    int index,
  ) async {
    if (index < 0 ||
        index >= instructionSteps.length) {
      return;
    }

    isCooking.value = false;

    await stopVoice();

    currentStepIndex.value = index;

    voiceMode.value = 'instruction';

    final text =
        'Step ${index + 1}. '
        '${instructionSteps[index]}';

    await _tts.speak(text);
  }

  // ===========================================================
  // START COOKING
  // ===========================================================

  Future<void> startCooking() async {
    if (instructionSteps.isEmpty) {
      return;
    }

    await stopVoice();

    isCooking.value = true;

    if (currentStepIndex.value >=
        instructionSteps.length) {
      currentStepIndex.value = 0;
    }

    await _speakCurrentInstruction();
  }

  // ===========================================================
  // SPEAK CURRENT INSTRUCTION
  // ===========================================================

  Future<void> _speakCurrentInstruction() async {
    if (!isCooking.value) {
      return;
    }

    if (currentStepIndex.value < 0 ||
        currentStepIndex.value >=
            instructionSteps.length) {
      isCooking.value = false;
      return;
    }

    await stopVoice();

    voiceMode.value = 'instruction';

    final text =
        'Step ${currentStepIndex.value + 1}. '
        '${instructionSteps[currentStepIndex.value]}';

    await _tts.speak(text);
  }

  // ===========================================================
  // NEXT STEP
  // ===========================================================

  Future<void> nextStep() async {
    if (instructionSteps.isEmpty) {
      return;
    }

    await stopVoice();

    if (currentStepIndex.value <
        instructionSteps.length - 1) {
      currentStepIndex.value++;
    } else {
      currentStepIndex.value = 0;
    }

    if (isCooking.value) {
      await _speakCurrentInstruction();
    }
  }

  // ===========================================================
  // PREVIOUS STEP
  // ===========================================================

  Future<void> previousStep() async {
    if (instructionSteps.isEmpty) {
      return;
    }

    await stopVoice();

    if (currentStepIndex.value > 0) {
      currentStepIndex.value--;
    } else {
      currentStepIndex.value =
          instructionSteps.length - 1;
    }

    if (isCooking.value) {
      await _speakCurrentInstruction();
    }
  }

  // ===========================================================
  // REPEAT CURRENT STEP
  // ===========================================================

  Future<void> repeatStep() async {
    if (instructionSteps.isEmpty) {
      return;
    }

    await stopVoice();

    if (isCooking.value) {
      await _speakCurrentInstruction();
    } else {
      await speakInstruction(
        currentStepIndex.value,
      );
    }
  }

  // ===========================================================
  // PAUSE
  // ===========================================================

  Future<void> pauseVoice() async {
    if (!isSpeaking.value) {
      return;
    }

    await _tts.pause();

    isPaused.value = true;
  }

  // ===========================================================
  // RESUME
  // ===========================================================

  Future<void> resumeVoice() async {
  if (!isPaused.value) {
    return;
  }

  try {
    await _tts.stop();

    isPaused.value = false;
    isSpeaking.value = false;

    if (voiceMode.value == 'ingredient') {
      await speakIngredients();
      return;
    }

    if (voiceMode.value == 'instruction') {
      if (isCooking.value) {
        await _speakCurrentInstruction();
      } else {
        await speakInstruction(
          currentStepIndex.value,
        );
      }
    }
  } catch (e) {
    isPaused.value = false;
    isSpeaking.value = false;
  }
}
  // ===========================================================
  // STOP VOICE
  // ===========================================================

  Future<void> stopVoice() async {
    try {
      await _tts.stop();
    } catch (_) {}

    isSpeaking.value = false;
    isPaused.value = false;
    voiceMode.value = 'none';
  }

  // ===========================================================
  // INGREDIENT VOICE
  // ===========================================================

  Future<void> speakIngredients() async {
    final recipe = recipeDetails.value;

    if (recipe == null ||
        recipe.ingredients.isEmpty) {
      return;
    }

    isCooking.value = false;

    await stopVoice();

    voiceMode.value = 'ingredient';

    final buffer = StringBuffer();

    buffer.write(
      'Ingredients for ${recipe.name}. ',
    );

    for (int i = 0;
        i < recipe.ingredients.length;
        i++) {
      final ingredient =
          recipe.ingredients[i];

      final name =
          ingredient.name.trim();

      final measure =
          ingredient.measure.trim();

      if (name.isEmpty) {
        continue;
      }

      buffer.write(
        '${i + 1}. $name',
      );

      if (measure.isNotEmpty) {
        buffer.write(
          ', $measure',
        );
      }

      buffer.write('. ');
    }

    await _tts.speak(
      buffer.toString(),
    );
  }

  // ===========================================================
  // STOP INGREDIENT VOICE
  // ===========================================================

  Future<void> stopIngredientsVoice() async {
    await stopVoice();
  }

  // ===========================================================
  // FAVORITE
  // ===========================================================

  void toggleFavorite() {
    isFavorite.value =
        !isFavorite.value;
  }

  // ===========================================================
  // DISPOSE
  // ===========================================================

  @override
  void onClose() {
    _tts.stop();
    super.onClose();
  }
}