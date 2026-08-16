import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/features/feedback/model/feedback_model.dart';
import 'package:recipe_app/features/feedback/repositories/feedback_repositories.dart';


class FeedbackController extends GetxController {
  final FeedbackRepository repository;

  FeedbackController({
    required this.repository,
  });

  // =========================================================
  // CONTROLLERS
  // =========================================================

  late final TextEditingController messageController;

  // =========================================================
  // RATING
  // =========================================================

  final RxInt selectedRating = 0.obs;

  // =========================================================
  // LOADING
  // =========================================================

  final RxBool isLoading = false.obs;

  // =========================================================
  // INIT
  // =========================================================

  @override
  void onInit() {
    super.onInit();

    messageController = TextEditingController();
  }

  // =========================================================
  // SET RATING
  // =========================================================

  void setRating(int rating) {
    if (rating >= 1 && rating <= 5) {
      selectedRating.value = rating;
    }
  }

  // =========================================================
  // SUBMIT FEEDBACK
  // =========================================================

  Future<void> submitFeedback({
    required String userId,
    required String userName,
  }) async {
    final message = messageController.text.trim();

    // ---------------------------------------------------------
    // VALIDATION
    // ---------------------------------------------------------

    if (selectedRating.value == 0) {
      Get.snackbar(
        'Rating Required',
        'Please select a rating.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (message.isEmpty) {
      Get.snackbar(
        'Feedback Required',
        'Please write your feedback.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final feedback = FeedbackModel(
        userId: userId,
        userName: userName,
        rating: selectedRating.value,
        message: message,
        createdAt: DateTime.now(),
      );

      await repository.submitFeedback(feedback);

      messageController.clear();
      selectedRating.value = 0;

      Get.snackbar(
        'Thank You!',
        'Your feedback has been submitted successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit feedback. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}