import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/feedback/controller/feedback_controller.dart';
import 'package:recipe_app/features/feedback/views/feedback_text_field.dart';
import 'package:recipe_app/features/feedback/views/rating_widget.dart';

class FeedbackScreen extends GetView<FeedbackController> {
  const FeedbackScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // =========================================================
    // THEME
    // =========================================================

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // =========================================================
    // COLORS
    // =========================================================

    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.background;

    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final headingColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.primary;

    final bodyColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final iconColor = isDark
        ? AppColors.primaryLight
        : AppColors.primary;

    final borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.border;

    // =========================================================
    // FIREBASE USER
    // =========================================================

    final User? user =
        FirebaseAuth.instance.currentUser;

    final String userId =
        user?.uid ?? '';

    final String userName =
        user?.displayName?.trim().isNotEmpty == true
            ? user!.displayName!.trim()
            : 'User';

    // =========================================================
    // SCREEN
    // =========================================================

    return Scaffold(
      backgroundColor: backgroundColor,

      // =======================================================
      // APP BAR
      // =======================================================

      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: headingColor,
        elevation: 0,
        centerTitle: true,

        title: Text(
          'Feedback',
          style: TextStyle(
            color: headingColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // =======================================================
      // BODY
      // =======================================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 20),

            // =================================================
            // FEEDBACK ICON
            // =================================================

            Center(
              child: Container(
                width: 90,
                height: 90,

                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primary
                          .withOpacity(0.20)
                      : AppColors.primaryLight,

                  shape: BoxShape.circle,

                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.border,
                    width: 1,
                  ),
                ),

                child: Icon(
                  Icons.rate_review_rounded,
                  size: 48,
                  color: iconColor,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =================================================
            // MAIN HEADING
            // =================================================

            Center(
              child: Text(
                'How was your experience?',

                style: TextStyle(
                  color: headingColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),

                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 8),

            // =================================================
            // DESCRIPTION
            // =================================================

            Center(
              child: Text(
                'Your feedback helps us improve the app.',

                style: TextStyle(
                  color: bodyColor,
                  fontSize: 14,
                  height: 1.5,
                ),

                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 28),

            // =================================================
            // RATING SECTION
            // =================================================

            Text(
              'Rate your experience',

              style: TextStyle(
                color: headingColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),

              decoration: BoxDecoration(
                color: surfaceColor,

                borderRadius:
                    BorderRadius.circular(14),

                border: Border.all(
                  color: borderColor,
                ),
              ),

              child: const RatingWidget(),
            ),

            const SizedBox(height: 24),

            // =================================================
            // FEEDBACK LABEL
            // =================================================

            Text(
              'Your feedback',

              style: TextStyle(
                color: headingColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            // =================================================
            // FEEDBACK TEXT FIELD
            // =================================================

            const FeedbackTextField(),

            const SizedBox(height: 26),

            // =================================================
            // SUBMIT BUTTON
            // =================================================

            Obx(
              () {
                if (controller.isLoading.value) {
                  return SizedBox(
                    width: double.infinity,
                    height: 52,

                    child: Center(
                      child: CircularProgressIndicator(
                        color: iconColor,
                        strokeWidth: 2.8,
                      ),
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
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.primary,

                      foregroundColor:
                          AppColors.white,

                      disabledBackgroundColor:
                          isDark
                              ? AppColors.darkSurface
                              : AppColors.inputBackground,

                      disabledForegroundColor:
                          isDark
                              ? AppColors.darkTextDisabled
                              : AppColors.textDisabled,

                      elevation: 0,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
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