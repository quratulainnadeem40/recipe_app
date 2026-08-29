import 'package:get_storage/get_storage.dart';
import 'package:recipe_app/features/feedback/model/feedback_model.dart';

class FeedbackRepository {
  final GetStorage _storage = GetStorage();
  static const String _feedbackKey = 'user_feedbacks';

  Future<void> submitFeedback(
    FeedbackModel feedback,
  ) async {
    try {
      final List<dynamic> existingList =
          _storage.read<List<dynamic>>(_feedbackKey) ?? [];
      final List<Map<String, dynamic>> updatedList =
          List<Map<String, dynamic>>.from(existingList);
      updatedList.add(feedback.toMap());
      await _storage.write(_feedbackKey, updatedList);
    } catch (_) {
      // Fallback
    }
  }
}