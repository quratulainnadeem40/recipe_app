import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/favorites/controllers/favorites_controller.dart';
import 'package:recipe_app/features/favorites/models/favorite_recipe_model.dart';

import '../../models/recipe_models.dart';

class RecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final bool horizontal;
  final VoidCallback? onTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.horizontal = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final card = Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder
              : AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: horizontal
          ? _buildHorizontalCard(
              textPrimary,
              textSecondary,
            )
          : _buildVerticalCard(
              textPrimary,
              textSecondary,
            ),
    );

    return GestureDetector(
      onTap: onTap,
      child: card,
    );
  }

  // ============================================================
  // VERTICAL CARD
  // ============================================================

  Widget _buildVerticalCard(
    Color textPrimary,
    Color textSecondary,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 1.15,
              child: _buildImage(
                borderRadius:
                    const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
            ),

            // ==================================================
            // FAVORITE BUTTON
            // ==================================================

            Positioned(
              top: 10,
              right: 10,
              child: _favoriteButton(),
            ),
          ],
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(
            10,
            9,
            10,
            11,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                recipe.name.trim().isNotEmpty
                    ? recipe.name
                    : 'Unknown Recipe',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  height: 1.2,
                  color: textPrimary,
                ),
              ),

              const SizedBox(height: 5),

              if (recipe.category.trim().isNotEmpty)
                Text(
                  recipe.category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),

              if (recipe.area.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    recipe.area,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textSecondary.withValues(
                        alpha: 0.75,
                      ),
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // HORIZONTAL CARD
  // ============================================================

  Widget _buildHorizontalCard(
    Color textPrimary,
    Color textSecondary,
  ) {
    return SizedBox(
      width: 210,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.15,
                child: _buildImage(
                  borderRadius:
                      const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
              ),

              // ==================================================
              // FAVORITE BUTTON
              // ==================================================

              Positioned(
                top: 10,
                right: 10,
                child: _favoriteButton(),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              10,
              9,
              10,
              11,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name.trim().isNotEmpty
                      ? recipe.name
                      : 'Unknown Recipe',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    height: 1.2,
                    color: textPrimary,
                  ),
                ),

                const SizedBox(height: 5),

                if (recipe.category.trim().isNotEmpty)
                  Text(
                    recipe.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FAVORITE BUTTON
  // ============================================================

  Widget _favoriteButton() {
    return GetBuilder<FavoritesController>(
      init: Get.isRegistered<FavoritesController>()
          ? null
          : FavoritesController(),
      builder: (controller) {
        final isFavorite =
            controller.isFavorite(recipe.id);

        return Material(
          color: Colors.white.withValues(alpha: 0.92),
          shape: const CircleBorder(),
          elevation: 2,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              final favoriteRecipe =
                  FavoriteRecipeModel(
                id: recipe.id,
                name: recipe.name,
                image: recipe.image,
              );

              controller.toggleFavorite(
                favoriteRecipe,
              );

              controller.update();
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: isFavorite
                    ? Colors.red
                    : AppColors.primary,
                size: 21,
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // IMAGE
  // ============================================================

  Widget _buildImage({
    required BorderRadius borderRadius,
  }) {
    final imageUrl = recipe.image.trim();

    return ClipRRect(
      borderRadius: borderRadius,
      child: imageUrl.isEmpty
          ? _imagePlaceholder()
          : Image.network(
              imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return _imagePlaceholder();
              },
              loadingBuilder: (
                context,
                child,
                loadingProgress,
              ) {
                if (loadingProgress == null) {
                  return child;
                }

                return _imageLoading();
              },
            ),
    );
  }

  // ============================================================
  // IMAGE PLACEHOLDER
  // ============================================================

  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.primaryLight,
      child: const Center(
        child: Icon(
          Icons.restaurant_rounded,
          color: AppColors.primary,
          size: 34,
        ),
      ),
    );
  }

  // ============================================================
  // IMAGE LOADING
  // ============================================================

  Widget _imageLoading() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.primaryLight,
      child: const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}