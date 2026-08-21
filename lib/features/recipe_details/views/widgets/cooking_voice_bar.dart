import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/recipe_details/controllers/recipe_details_controller.dart' show RecipeController;

class CookingVoiceBar extends StatelessWidget {
  const CookingVoiceBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final RecipeController controller = Get.find<RecipeController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final isSpeaking = controller.isSpeaking.value;
      final isPaused = controller.isPaused.value;

      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: (isSpeaking ? AppColors.primary : Colors.black).withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                // ==========================================
                // CORE FIX: Wrapped color and border inside BoxDecoration
                // ==========================================
                decoration: BoxDecoration(
                  color: isDark 
                      ? Colors.black.withOpacity(0.78) 
                      : Colors.white.withOpacity(0.90),
                  border: Border.all(
                    color: isSpeaking 
                        ? AppColors.primary.withOpacity(0.3) 
                        : Colors.grey.withOpacity(0.15),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(24), // Maintain perfect curved corners
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Step progress header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Step ${controller.currentStepNumber} of ${controller.totalSteps}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          '${(controller.cookingProgress * 100).toInt()}% Done',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Linear Progress Bar using cookingProgress
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: controller.cookingProgress,
                        backgroundColor: AppColors.primaryLight,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        minHeight: 5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Instruction Display Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade900.withOpacity(0.4) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Obx(
                        () => Text(
                          controller.currentInstruction.value,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            height: 1.4,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.65,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Navigation Media Controllers
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Repeat Button
                        IconButton(
                          tooltip: 'Repeat',
                          onPressed: controller.repeatStep,
                          icon: const Icon(Icons.replay_circle_filled_rounded),
                          color: AppColors.primary.withOpacity(0.8),
                          iconSize: 28,
                        ),

                        // Back Button
                        IconButton(
                          tooltip: 'Previous Step',
                          onPressed: controller.previousStep,
                          icon: const Icon(Icons.skip_previous_rounded),
                          color: AppColors.primary,
                          iconSize: 32,
                        ),

                        // Main Play/Pause Button
                        GestureDetector(
                          onTap: () {
                            if (!isSpeaking) {
                              controller.startCooking();
                            } else if (isPaused) {
                              controller.resumeVoice();
                            } else {
                              controller.pauseVoice();
                            }
                          },
                          child: Container(
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Icon(
                              isSpeaking && !isPaused
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),

                        // Next Button
                        IconButton(
                          tooltip: 'Next Step',
                          onPressed: controller.nextStep,
                          icon: const Icon(Icons.skip_next_rounded),
                          color: AppColors.primary,
                          iconSize: 32,
                        ),

                        // Stop Button
                        IconButton(
                          tooltip: 'Stop Cooking',
                          onPressed: () => controller.stopSpeaking(),
                          icon: const Icon(Icons.stop_circle_rounded),
                          color: Colors.redAccent.withOpacity(0.8),
                          iconSize: 28,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}