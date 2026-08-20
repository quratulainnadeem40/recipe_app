import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/routes/app_routes.dart';
import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/core/theme/app_text_styles.dart';
import 'package:recipe_app/features/favorites/controllers/favorites_controller.dart';
import 'package:recipe_app/features/favorites/views/widgets/favorite_recipe_card.dart';

class FavoritesScreen extends GetView<FavoritesController> {
  const FavoritesScreen({
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
          'Favorites',
          style: AppTextStyles.headingMedium.copyWith(
            color: headingColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // =======================================================
      // BODY
      // =======================================================

      body: Obx(
        () {
          // ===================================================
          // EMPTY FAVORITES
          // ===================================================

          if (controller.favorites.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                ),

                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    // =========================================
                    // EMPTY ICON
                    // =========================================

                    Container(
                      width: 100,
                      height: 100,

                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primary
                                .withOpacity(0.18)
                            : AppColors.primaryLight,

                        shape: BoxShape.circle,

                        border: Border.all(
                          color: borderColor,
                          width: 1,
                        ),
                      ),

                      child: Icon(
                        Icons.favorite_border_rounded,
                        size: 52,
                        color: iconColor,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // =========================================
                    // EMPTY TITLE
                    // =========================================

                    Text(
                      'No Favorite Recipes',

                      textAlign: TextAlign.center,

                      style:
                          AppTextStyles.headingMedium
                              .copyWith(
                        color: headingColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // =========================================
                    // DESCRIPTION
                    // =========================================

                    Text(
                      'Your favorite recipes will appear here.',

                      textAlign: TextAlign.center,

                      style:
                          AppTextStyles.bodyMedium
                              .copyWith(
                        color: bodyColor,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // =========================================
                    // EXPLORE BUTTON
                    // =========================================

                    ElevatedButton.icon(
                      onPressed: () {
                        // Open Home screen
                        Get.offNamed(
                          AppRoutes.home,
                        );
                      },

                      icon: const Icon(
                        Icons.explore_rounded,
                      ),

                      label: const Text(
                        'Explore Recipes',
                      ),

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.primary,

                        foregroundColor:
                            AppColors.white,

                        minimumSize:
                            const Size(210, 50),

                        elevation: 0,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
                        ),

                        textStyle:
                            AppTextStyles.button,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // ===================================================
          // FAVORITE RECIPE LIST
          // ===================================================

          return ListView.builder(
            padding: const EdgeInsets.all(16),

            itemCount:
                controller.favorites.length,

            itemBuilder: (
              context,
              index,
            ) {
              final recipe =
                  controller.favorites[index];

              return Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 12,
                ),

                child: FavoriteRecipeCard(
                  recipe: recipe,

                  // =========================================
                  // REMOVE FAVORITE
                  // =========================================

                  onRemove: () {
                    controller.removeFavorite(
                      recipe.id,
                    );
                  },

                  // =========================================
                  // RECIPE DETAILS
                  // =========================================

                  onTap: () {
                    Get.toNamed(
                      AppRoutes.recipeDetails,
                      arguments: recipe.id,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}