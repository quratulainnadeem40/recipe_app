import 'package:flutter_tts/flutter_tts.dart';

class RecipeVoiceService {
  RecipeVoiceService._();

  static final FlutterTts _tts = FlutterTts();

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    _initialized = true;
  }

  static Future<void> speak({
    required String text,
    double speed = 1.0,
  }) async {
    final String cleanText = text.trim();

    if (cleanText.isEmpty) {
      throw Exception('Recipe text is empty.');
    }

    await initialize();

    await _tts.setSpeechRate(
      _convertSpeedToSpeechRate(speed),
    );

    await _tts.speak(cleanText);
  }

  static Future<void> pause() async {
    await _tts.pause();
  }

  static Future<void> stop() async {
    await _tts.stop();
  }

  static Future<void> resume({
    required String text,
    double speed = 1.0,
  }) async {
    final String cleanText = text.trim();

    if (cleanText.isEmpty) {
      throw Exception('Recipe text is empty.');
    }

    await initialize();

    await _tts.setSpeechRate(
      _convertSpeedToSpeechRate(speed),
    );

    await _tts.speak(cleanText);
  }

  static Future<void> setSpeed(
    double speed,
  ) async {
    await initialize();

    await _tts.setSpeechRate(
      _convertSpeedToSpeechRate(speed),
    );
  }

  static double _convertSpeedToSpeechRate(
    double speed,
  ) {
    if (speed <= 0.5) {
      return 0.25;
    }

    if (speed <= 0.75) {
      return 0.35;
    }

    if (speed <= 1.0) {
      return 0.5;
    }

    if (speed <= 1.25) {
      return 0.58;
    }

    if (speed <= 1.5) {
      return 0.65;
    }

    return 0.75;
  }
}