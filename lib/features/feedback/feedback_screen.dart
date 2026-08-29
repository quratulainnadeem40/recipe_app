import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/core/theme/app_text_styles.dart';
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
    // THEME COLORS
    // =========================================================

    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.background;

    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final iconColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.primary;

    final borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.border;

    // =========================================================
    // LOCAL USER INFO
    // =========================================================

    final storage = GetStorage();
    final String userId = 'local_user';
    final String userName = storage.read<String>('userName') ?? 'COOKmate User';

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
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,

        title: Text(
          'Feedback',
          style: AppTextStyles.headingMedium.copyWith(
            color: textPrimary,
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      ? AppColors.primary.withOpacity(0.20)
                      : AppColors.primaryLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor,
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
                style: AppTextStyles.headingMedium.copyWith(
                  color: textPrimary,
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
                style: AppTextStyles.bodyMedium.copyWith(
                  color: textSecondary,
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
              style: AppTextStyles.labelLarge.copyWith(
                color: textPrimary,
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
                borderRadius: BorderRadius.circular(14),
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
              style: AppTextStyles.labelLarge.copyWith(
                color: textPrimary,
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
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.primary,
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
                    label: Text(
                      'Submit Feedback',
                      style: AppTextStyles.button.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,

                      // Use existing colors only.
                      disabledBackgroundColor: isDark
                          ? AppColors.darkSurface
                          : AppColors.inputBackground,

                      disabledForegroundColor: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,

                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
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