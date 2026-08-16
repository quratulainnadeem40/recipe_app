import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/features/feedback/controller/feedback_controller.dart';
import 'package:recipe_app/features/feedback/views/feedback_text_field.dart';
import 'package:recipe_app/features/feedback/views/rating_widget.dart';


class FeedbackScreen
    extends GetView<FeedbackController> {
  const FeedbackScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final User? user =
        FirebaseAuth.instance.currentUser;

    final String userId = user?.uid ?? '';

    final String userName =
        user?.displayName?.trim().isNotEmpty == true
            ? user!.displayName!.trim()
            : 'User';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Center(
              child: Icon(
                Icons.rate_review_rounded,
                size: 70,
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                'How was your experience?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 8),

            const Center(
              child: Text(
                'Your feedback helps us improve the app.',
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Rate your experience',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const RatingWidget(),

            const SizedBox(height: 20),

            const Text(
              'Your feedback',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const FeedbackTextField(),

            const SizedBox(height: 24),

            Obx(
              () {
                if (controller.isLoading.value) {
                  return const SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: userId.isEmpty
                        ? null
                        : () {
                            controller.submitFeedback(
                              userId: userId,
                              userName: userName,
                            );
                          },
                    icon: const Icon(
                      Icons.send_rounded,
                    ),
                    label: const Text(
                      'Submit Feedback',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}