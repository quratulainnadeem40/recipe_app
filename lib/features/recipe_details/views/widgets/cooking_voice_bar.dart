import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../controllers/recipe_details_controller.dart';

class CookingVoiceBar extends StatelessWidget {
  const CookingVoiceBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecipeDetailsController>();
    final theme = Theme.of(context);

    return Obx(() {
      final bool hasSteps = controller.totalSteps > 0;
      final bool isSpeaking = controller.isSpeaking.value;
      final bool isPaused = controller.isPaused.value;

      if (!hasSteps) {
        return const SizedBox.shrink();
      }

      return SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(
            12,
            0,
            12,
            12,
          ),
          padding: const EdgeInsets.fromLTRB(
            16,
            14,
            16,
            12,
          ),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: theme.dividerColor.withValues(
                alpha: 0.35,
              ),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 25,
                offset: const Offset(0, 8),
                color: Colors.black.withValues(
                  alpha: 0.10,
                ),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // =================================================
              // HEADER
              // =================================================

              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      isSpeaking
                          ? Icons.volume_up_rounded
                          : Icons.record_voice_over_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          isSpeaking
                              ? 'Cooking Assistant'
                              : 'Ready to Cook?',
                          style: theme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Step ${controller.currentStepNumber} '
                          'of ${controller.totalSteps}',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.55),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // =================================================
                  // REPEAT
                  // =================================================

                  IconButton(
                    tooltip: 'Repeat',
                    onPressed: controller.repeatStep,
                    icon: const Icon(
                      Icons.replay_rounded,
                    ),
                    color: AppColors.primary,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // =================================================
              // PROGRESS
              // =================================================

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: controller.cookingProgress,
                  minHeight: 5,
                  backgroundColor:
                      AppColors.primaryLight,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // =================================================
              // MAIN PLAY / PAUSE BUTTON
              // =================================================

              Row(
                children: [
                  // Previous
                  _VoiceActionButton(
                    icon: Icons.skip_previous_rounded,
                    onTap: controller.previousStep,
                  ),

                  const SizedBox(width: 8),

                  // Main button
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!isSpeaking) {
                            controller.startCooking();
                          } else if (isPaused) {
                            controller.resumeVoice();
                          } else {
                            controller.pauseVoice();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(17),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Icon(
                              !isSpeaking
                                  ? Icons.play_arrow_rounded
                                  : isPaused
                                      ? Icons.play_arrow_rounded
                                      : Icons.pause_rounded,
                              size: 25,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              !isSpeaking
                                  ? 'Start Cooking'
                                  : isPaused
                                      ? 'Resume'
                                      : 'Pause',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Next
                  _VoiceActionButton(
                    icon: Icons.skip_next_rounded,
                    onTap: controller.nextStep,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // =================================================
              // CURRENT STEP
              // =================================================

              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.format_quote_rounded,
                    size: 17,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      controller.currentInstruction,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        height: 1.4,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.65),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

// =============================================================
// SMALL VOICE ACTION BUTTON
// =============================================================

class _VoiceActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _VoiceActionButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryLight,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 52,
          height: 52,
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 25,
          ),
        ),
      ),
    );
  }
}