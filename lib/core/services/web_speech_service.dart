import 'dart:js_interop';

@JS('SpeechSynthesisUtterance')

external JSObject _createUtterance(JSString text);

@JS('speechSynthesis.speak')
external void _speak(JSObject utterance);

@JS('speechSynthesis.pause')
external void _pause();

@JS('speechSynthesis.resume')
external void _resume();

@JS('speechSynthesis.cancel')
external void _cancel();

class WebSpeechService {
  WebSpeechService._();

  static final WebSpeechService instance =
      WebSpeechService._();

  bool get isSupported => true;

  void speak(String text) {
    if (text.trim().isEmpty) return;

    _cancel();

    final JSObject utterance =
        _createUtterance(text.toJS);

    _speak(utterance);
  }

  void pause() {
    _pause();
  }

  void resume() {
    _resume();
  }

  void stop() {
    _cancel();
  }
}