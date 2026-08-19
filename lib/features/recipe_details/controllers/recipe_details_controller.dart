import 'package:flutter/material.dart';
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
  // RECIPE
  // =========================================================

  final Rxn<RecipeDetailsModel> recipe = Rxn<RecipeDetailsModel>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentImageIndex = 0.obs;

  String? recipeId;

  // =========================================================
  // TTS / VOICE
  // =========================================================

  final FlutterTts flutterTts = FlutterTts();

  final RxBool isSpeaking = false.obs;
  final RxBool isPaused = false.obs;
  final RxBool isVoiceLoading = false.obs;
  final RxDouble playbackSpeed = 1.0.obs;
  final RxString voiceError = ''.obs;

  final Rx<Duration> audioPosition = Duration.zero.obs;
  final Rx<Duration> audioDuration = Duration.zero.obs;

  // =========================================================
  // INTERNAL STATE
  // =========================================================

  bool _voiceInitialized = false;
  bool _isStopping = false;
  bool _ignoreSpeechError = false;

  List<String> _speechSentences = [];
  int _currentSentenceIndex = 0;

  // =========================================================
  // INIT
  // =========================================================

  @override
  void onInit() {
    super.onInit();
    _initializeVoice();
    _handleArguments();
  }

  // =========================================================
  // INITIALIZE VOICE
  // =========================================================

  Future<void> _initializeVoice() async {
    if (_voiceInitialized) return;

    try {
      await flutterTts.setLanguage('en-US');
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(_speechRate(playbackSpeed.value));

      flutterTts.setStartHandler(() {
        if (_isStopping) return;

        isVoiceLoading.value = false;
        isSpeaking.value = true;
        isPaused.value = false;
        voiceError.value = '';
      });

      flutterTts.setCompletionHandler(() {
        if (_isStopping || isPaused.value) return;

        _currentSentenceIndex++;

        if (_currentSentenceIndex < _speechSentences.length) {
          _speakCurrentSentence();
        } else {
          _finishSpeech();
        }
      });

      flutterTts.setErrorHandler((dynamic message) {
        if (_isStopping || _ignoreSpeechError) return;

        final String error = message.toString().toLowerCase();

        if (_isNormalBrowserSpeechError(error)) {
          isVoiceLoading.value = false;
          voiceError.value = '';
          return;
        }

        isVoiceLoading.value = false;
        isSpeaking.value = false;
        isPaused.value = false;
        voiceError.value = 'Voice playback failed.';
      });

      flutterTts.setCancelHandler(() {
        if (_isStopping || _ignoreSpeechError) return;

        isVoiceLoading.value = false;
        isSpeaking.value = false;
        voiceError.value = '';
      });

      _voiceInitialized = true;
    } catch (_) {
      _voiceInitialized = false;
      voiceError.value = 'Unable to initialize voice.';
    }
  }

  // =========================================================
  // MAIN ACTION BUTTON TRIGGER (Play / Pause / Resume)
  // =========================================================

  Future<void> togglePlayPause() async {
    if (isSpeaking.value) {
      await pauseRecipe();
    } else if (isPaused.value) {
      await resumeRecipe();
    } else {
      await speakRecipe();
    }
  }

  // =========================================================
  // ARGUMENTS & FETCH
  // =========================================================

  void _handleArguments() {
    final dynamic arguments = Get.arguments;

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

    errorMessage.value = 'Recipe information not found.';
  }

  Future<void> getRecipeDetails(String id) async {
    final String cleanId = id.trim();

    if (cleanId.isEmpty) {
      recipe.value = null;
      errorMessage.value = 'Recipe ID not found.';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      currentImageIndex.value = 0;

      await _silentStop();

      final RecipeDetailsModel result =
          await repository.getRecipeDetails(cleanId);

      if (result.id.trim().isEmpty) {
        recipe.value = null;
        errorMessage.value = 'Recipe details not found.';
        return;
      }

      recipe.value = result;
      recipeId = result.id.trim();
    } catch (_) {
      recipe.value = null;
      errorMessage.value = 'Failed to load recipe details.';
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================
  // SENTENCES BUILDER
  // =========================================================

  List<String> _buildRecipeSentences() {
    final RecipeDetailsModel? currentRecipe = recipe.value;
    if (currentRecipe == null) return [];

    final List<String> sentences = [];

    final String name = currentRecipe.name.trim();
    if (name.isNotEmpty) {
      sentences.add('Today we are going to make $name.');
    }

    final String category = currentRecipe.category.trim();
    if (category.isNotEmpty) {
      sentences.add('Category: $category.');
    }

    final String area = currentRecipe.area.trim();
    if (area.isNotEmpty) {
      sentences.add('Cuisine: $area.');
    }

    sentences.add('Here are the ingredients you will need.');

    for (int i = 0; i < currentRecipe.ingredients.length; i++) {
      final String ingredient = currentRecipe.ingredients[i].trim();
      if (ingredient.isEmpty) continue;

      String measure = '';
      if (i < currentRecipe.measures.length) {
        measure = currentRecipe.measures[i].trim();
      }

      if (measure.isNotEmpty) {
        sentences.add('$measure of $ingredient.');
      } else {
        sentences.add('$ingredient.');
      }
    }

    sentences.add('Now let us start cooking.');

    final String instructions = currentRecipe.instructions.trim();
    if (instructions.isNotEmpty) {
      final rawSteps = instructions.split(RegExp(r'(?<=[.!?])|\n+'));
      for (var step in rawSteps) {
        final cleanStep = step.trim();
        if (cleanStep.isNotEmpty) {
          sentences.add(cleanStep);
        }
      }
    }

    return sentences;
  }

  // =========================================================
  // SPEAK
  // =========================================================

  Future<void> speakRecipe() async {
    final sentences = _buildRecipeSentences();
    if (sentences.isEmpty) {
      voiceError.value = 'No recipe text is available.';
      return;
    }

    try {
      voiceError.value = '';

      if (!_voiceInitialized) {
        await _initializeVoice();
      }

      if (!_voiceInitialized) {
        isVoiceLoading.value = false;
        voiceError.value = 'Unable to initialize voice.';
        return;
      }

      await _silentStop();

      _speechSentences = sentences;
      _currentSentenceIndex = 0;

      isVoiceLoading.value = true;
      isSpeaking.value = false;
      isPaused.value = false;

      await _speakCurrentSentence();
    } catch (e) {
      isVoiceLoading.value = false;
      isSpeaking.value = false;
      isPaused.value = false;
      if (!_isNormalBrowserSpeechError(e.toString().toLowerCase())) {
        voiceError.value = 'Unable to play recipe voice.';
      }
    }
  }

  Future<void> _speakCurrentSentence() async {
    if (_speechSentences.isEmpty ||
        _currentSentenceIndex >= _speechSentences.length) {
      _finishSpeech();
      return;
    }

    await _applyVoiceSettings();

    final String currentText = _speechSentences[_currentSentenceIndex];
    if (currentText.trim().isEmpty) {
      _currentSentenceIndex++;
      await _speakCurrentSentence();
      return;
    }

    isSpeaking.value = true;
    isPaused.value = false;
    isVoiceLoading.value = false;

    await flutterTts.speak(currentText);
  }

  // =========================================================
  // PAUSE
  // =========================================================

  Future<void> pauseRecipe() async {
    try {
      voiceError.value = '';
      _ignoreSpeechError = true;

      // Unset states manually before calling engine stop
      isSpeaking.value = false;
      isPaused.value = true;
      isVoiceLoading.value = false;

      await flutterTts.stop();
    } catch (_) {
      isSpeaking.value = false;
      isPaused.value = true;
      isVoiceLoading.value = false;
    } finally {
      _ignoreSpeechError = false;
    }
  }

  // =========================================================
  // RESUME
  // =========================================================

  Future<void> resumeRecipe() async {
    if (_speechSentences.isEmpty) {
      // Agar list khali ho toh dobara full recipe list build karke Play karain
      await speakRecipe();
      return;
    }

    try {
      voiceError.value = '';
      _ignoreSpeechError = true;

      await flutterTts.stop();
      await Future.delayed(const Duration(milliseconds: 100));

      isVoiceLoading.value = true;
      isPaused.value = false;

      await _speakCurrentSentence();
    } catch (e) {
      isVoiceLoading.value = false;
      isSpeaking.value = false;
      isPaused.value = true;
      if (!_isNormalBrowserSpeechError(e.toString().toLowerCase())) {
        voiceError.value = 'Unable to resume voice.';
      }
    } finally {
      _ignoreSpeechError = false;
    }
  }

  // =========================================================
  // STOP
  // =========================================================

  Future<void> stopRecipe({bool showMessage = true}) async {
    try {
      _isStopping = true;
      _ignoreSpeechError = true;

      voiceError.value = '';

      try {
        await flutterTts.stop();
      } catch (_) {}

      isSpeaking.value = false;
      isPaused.value = false;
      isVoiceLoading.value = false;

      _speechSentences = [];
      _currentSentenceIndex = 0;

      audioPosition.value = Duration.zero;
      audioDuration.value = Duration.zero;

      if (showMessage) {
        Get.snackbar(
          'Voice Stopped',
          'Recipe voice has been stopped.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        );
      }
    } catch (_) {
      voiceError.value = '';
    } finally {
      _ignoreSpeechError = false;
      _isStopping = false;
    }
  }

  Future<void> _silentStop() async {
    _isStopping = true;
    _ignoreSpeechError = true;

    try {
      await flutterTts.stop();
    } catch (_) {
    } finally {
      isSpeaking.value = false;
      isPaused.value = false;
      isVoiceLoading.value = false;
      _ignoreSpeechError = false;
      _isStopping = false;
    }
  }

  Future<void> _applyVoiceSettings() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(_speechRate(playbackSpeed.value));
  }

  Future<void> setSpeechSpeed(double speed) async {
    final double cleanSpeed = speed.clamp(0.5, 2.0).toDouble();
    playbackSpeed.value = cleanSpeed;
    voiceError.value = '';

    try {
      await flutterTts.setSpeechRate(_speechRate(cleanSpeed));

      if (isSpeaking.value) {
        await flutterTts.stop();
        await _speakCurrentSentence();
      }
    } catch (_) {
      voiceError.value = 'Unable to change voice speed.';
    }
  }

  double _speechRate(double speed) {
    if (speed <= 0.5) return 0.25;
    if (speed <= 0.75) return 0.35;
    if (speed <= 1.0) return 0.50;
    if (speed <= 1.25) return 0.58;
    if (speed <= 1.5) return 0.65;
    return 0.75;
  }

  void _finishSpeech() {
    isVoiceLoading.value = false;
    isSpeaking.value = false;
    isPaused.value = false;
    _currentSentenceIndex = 0;
    voiceError.value = '';
  }

  bool _isNormalBrowserSpeechError(String error) {
    final String text = error.toLowerCase();
    return text.contains('speechsynthesiserrorevent') ||
        text.contains('speechsynthesis error') ||
        text.contains('[object speechsynthesis') ||
        text.contains('interrupted') ||
        text.contains('cancel') ||
        text.contains('canceled') ||
        text.contains('cancelled');
  }

  Future<void> seekTo(Duration position) async {}
  Future<void> skipForward() async {}
  Future<void> skipBackward() async {}

  String formatDuration(Duration duration) {
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    final int seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  void changeImage(int index) {
    if (index < 0) return;
    currentImageIndex.value = index;
  }

  Future<void> retry() async {
    final String? id = recipeId;
    if (id != null && id.trim().isNotEmpty) {
      await getRecipeDetails(id);
      return;
    }
    _handleArguments();
  }

  @override
  void onClose() {
    _isStopping = true;
    _ignoreSpeechError = true;

    flutterTts.stop();

    recipe.value = null;
    errorMessage.value = '';
    recipeId = null;

    isSpeaking.value = false;
    isPaused.value = false;
    isVoiceLoading.value = false;

    playbackSpeed.value = 1.0;
    voiceError.value = '';

    audioPosition.value = Duration.zero;
    audioDuration.value = Duration.zero;

    _speechSentences = [];
    _currentSentenceIndex = 0;
    _voiceInitialized = false;

    super.onClose();
  }
}