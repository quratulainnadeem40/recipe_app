import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/recipe_details/controllers/recipe_details_controller.dart';
import 'package:recipe_app/features/recipe_details/model/recipe_detail_model.dart';

class RecipeDetailsScreen
    extends GetView<RecipeDetailsController> {
  const RecipeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Recipe Details',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Obx(() {
        // =====================================================
        // LOADING
        // =====================================================

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // =====================================================
        // ERROR
        // =====================================================

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: controller.retry,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // =====================================================
        // RECIPE
        // =====================================================

        final RecipeDetailsModel? recipe =
            controller.recipe.value;

        if (recipe == null) {
          return const Center(
            child: Text(
              'Recipe not found.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.retry,
          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(),
            padding:
                const EdgeInsets.only(bottom: 30),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // =================================================
                // IMAGE
                // =================================================

                _buildRecipeImage(recipe),

                // =================================================
                // CONTENT
                // =================================================

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      // =================================================
                      // RECIPE NAME
                      // =================================================

                      Text(
                        recipe.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // =================================================
                      // CATEGORY + AREA
                      // =================================================

                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoChip(
                              Icons.category_outlined,
                              recipe.category,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildInfoChip(
                              Icons.public,
                              recipe.area,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // =================================================
                      // VOICE PLAYER
                      // =================================================

                      _buildVoicePlayer(),

                      const SizedBox(height: 28),

                      // =================================================
                      // INGREDIENTS
                      // =================================================

                      _buildSectionTitle(
                        'Ingredients',
                        Icons.restaurant_menu,
                      ),

                      const SizedBox(height: 12),

                      _buildIngredients(recipe),

                      const SizedBox(height: 28),

                      // =================================================
                      // INSTRUCTIONS
                      // =================================================

                      _buildSectionTitle(
                        'Cooking Instructions',
                        Icons.menu_book_outlined,
                      ),

                      const SizedBox(height: 12),

                      _buildInstructions(recipe),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ===========================================================
  // RECIPE IMAGE
  // ===========================================================

  Widget _buildRecipeImage(
    RecipeDetailsModel recipe,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 280,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        child: recipe.image.trim().isEmpty
            ? Container(
                color: Colors.grey.shade200,
                child: const Center(
                  child: Icon(
                    Icons.restaurant,
                    size: 70,
                    color: Colors.grey,
                  ),
                ),
              )
            : Image.network(
                recipe.image,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
                loadingBuilder:
                    (context, child, progress) {
                  if (progress == null) {
                    return child;
                  }

                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                },
              ),
      ),
    );
  }

  // ===========================================================
  // INFO CHIP
  // ===========================================================

  Widget _buildInfoChip(
    IconData icon,
    String text,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text.trim().isEmpty
                  ? 'N/A'
                  : text,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // VOICE PLAYER
  // ===========================================================

  Widget _buildVoicePlayer() {
    return Obx(() {
      final bool isSpeaking =
          controller.isSpeaking.value;

      final bool isPaused =
          controller.isPaused.value;

      final bool isLoading =
          controller.isVoiceLoading.value;

      final String voiceError =
          controller.voiceError.value;

      final double speed =
          controller.playbackSpeed.value;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset:
                  const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // =================================================
            // HEADER
            // =================================================

            Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColors.primary
                        .withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.record_voice_over,
                    color:
                        AppColors.primary,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recipe Voice',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Listen to the complete recipe',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // =================================================
                // SPEED MENU
                // =================================================

                PopupMenuButton<double>(
                  tooltip:
                      'Voice Speed',
                  onSelected:
                      controller
                          .setSpeechSpeed,
                  itemBuilder:
                      (context) {
                    return const [
                      PopupMenuItem<double>(
                        value: 0.5,
                        child:
                            Text('0.5x'),
                      ),
                      PopupMenuItem<double>(
                        value: 0.75,
                        child:
                            Text('0.75x'),
                      ),
                      PopupMenuItem<double>(
                        value: 1.0,
                        child:
                            Text('1.0x'),
                      ),
                      PopupMenuItem<double>(
                        value: 1.25,
                        child:
                            Text('1.25x'),
                      ),
                      PopupMenuItem<double>(
                        value: 1.5,
                        child:
                            Text('1.5x'),
                      ),
                      PopupMenuItem<double>(
                        value: 2.0,
                        child:
                            Text('2.0x'),
                      ),
                    ];
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          Colors.grey.shade100,
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Text(
                      '${speed.toStringAsFixed(speed == speed.roundToDouble() ? 1 : 2)}x',
                      style:
                          const TextStyle(
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // =================================================
            // STATUS
            // =================================================

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              decoration:
                  BoxDecoration(
                color:
                    AppColors.lightBackground,
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isSpeaking
                        ? Icons.volume_up
                        : isPaused
                            ? Icons.pause_circle_outline
                            : isLoading
                                ? Icons.hourglass_top
                                : Icons.headphones,
                    color:
                        AppColors.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isLoading
                          ? 'Starting recipe voice...'
                          : isSpeaking
                              ? 'Recipe voice is playing'
                              : isPaused
                                  ? 'Recipe voice is paused'
                                  : 'Ready to play recipe voice',
                      style:
                          const TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =================================================
            // MAIN CONTROL
            // =================================================

            Center(
              child: SizedBox(
                width: 68,
                height: 68,
                child: isLoading
                    ? Container(
                        decoration:
                            BoxDecoration(
                          color:
                              AppColors.primary,
                          shape:
                              BoxShape.circle,
                        ),
                        child:
                            const Padding(
                          padding:
                              EdgeInsets.all(
                            19,
                          ),
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor:
                                AlwaysStoppedAnimation<
                                    Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      )
                    : FloatingActionButton(
                        elevation: 0,
                        backgroundColor:
                            AppColors.primary,
                        onPressed: () {
                          // ===================================
                          // PLAYING
                          // ===================================

                          if (isSpeaking) {
                            controller
                                .pauseRecipe();
                            return;
                          }

                          // ===================================
                          // PAUSED
                          // ===================================

                          if (isPaused) {
                            controller
                                .resumeRecipe();
                            return;
                          }

                          // ===================================
                          // STOPPED / NEW PLAY
                          // ===================================

                          controller
                              .speakRecipe();
                        },
                        child: Icon(
                          isSpeaking
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 34,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 12),

            // =================================================
            // BUTTON LABEL
            // =================================================

            Center(
              child: Text(
                isLoading
                    ? 'Starting voice...'
                    : isSpeaking
                        ? 'Pause'
                        : isPaused
                            ? 'Resume'
                            : 'Play Recipe',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),

            // =================================================
            // STOP
            // =================================================

            if (isSpeaking || isPaused) ...[
              const SizedBox(height: 8),
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    controller
                        .stopRecipe();
                  },
                  icon: const Icon(
                    Icons.stop_circle_outlined,
                    size: 20,
                  ),
                  label: const Text(
                    'Stop Voice',
                  ),
                ),
              ),
            ],

            // =================================================
            // ERROR
            //
            // Only REAL errors are shown.
            // Chrome SpeechSynthesisErrorEvent is filtered
            // inside controller.
            // =================================================

            if (voiceError.isNotEmpty)
              Container(
                width: double.infinity,
                margin:
                    const EdgeInsets.only(
                  top: 10,
                ),
                padding:
                    const EdgeInsets.all(12),
                decoration:
                    BoxDecoration(
                  color: Colors.red
                      .withOpacity(0.06),
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                  border: Border.all(
                    color: Colors.red
                        .withOpacity(0.15),
                  ),
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color:
                          Colors.redAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        voiceError,
                        style:
                            const TextStyle(
                          color:
                              Colors.redAccent,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }

  // ===========================================================
  // SECTION TITLE
  // ===========================================================

  Widget _buildSectionTitle(
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 23,
        ),
        const SizedBox(width: 9),
        Text(
          title,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // ===========================================================
  // INGREDIENTS
  // ===========================================================

  Widget _buildIngredients(
    RecipeDetailsModel recipe,
  ) {
    if (recipe.ingredients.isEmpty) {
      return Container(
        width: double.infinity,
        padding:
            const EdgeInsets.all(16),
        decoration:
            BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(16),
        ),
        child: const Text(
          'No ingredients available.',
        ),
      );
    }

    return Column(
      children: List.generate(
        recipe.ingredients.length,
        (index) {
          final String ingredient =
              recipe.ingredients[index]
                  .trim();

          if (ingredient.isEmpty) {
            return const SizedBox
                .shrink();
          }

          final String measure =
              index <
                      recipe.measures
                          .length
                  ? recipe
                      .measures[index]
                      .trim()
                  : '';

          return Container(
            width: double.infinity,
            margin:
                const EdgeInsets.only(
              bottom: 10,
            ),
            padding:
                const EdgeInsets.all(15),
            decoration:
                BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(
                15,
              ),
              border: Border.all(
                color:
                    Colors.grey.shade200,
              ),
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin:
                      const EdgeInsets.only(
                    top: 6,
                  ),
                  decoration:
                      BoxDecoration(
                    color:
                        AppColors.primary,
                    shape:
                        BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    measure.isEmpty
                        ? ingredient
                        : '$measure  $ingredient',
                    style:
                        const TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ===========================================================
  // INSTRUCTIONS
  // ===========================================================

  Widget _buildInstructions(
    RecipeDetailsModel recipe,
  ) {
    final String instructions =
        recipe.instructions.trim();

    if (instructions.isEmpty) {
      return Container(
        width: double.infinity,
        padding:
            const EdgeInsets.all(16),
        decoration:
            BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(16),
        ),
        child: const Text(
          'No cooking instructions available.',
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color:
              Colors.grey.shade200,
        ),
      ),
      child: Text(
        instructions,
        style:
            const TextStyle(
          fontSize: 15,
          height: 1.65,
          color: Colors.black87,
        ),
      ),
    );
  }
}