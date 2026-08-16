import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/features/feedback/model/feedback_model.dart';


class FeedbackRepository {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> submitFeedback(
    FeedbackModel feedback,
  ) async {
    await _firestore
        .collection('feedback')
        .add(feedback.toMap());
  }
}