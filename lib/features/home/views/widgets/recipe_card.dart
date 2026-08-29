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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        splashColor: AppColors.primary.withValues(alpha: 0.1),
        highlightColor: AppColors.primary.withValues(alpha: 0.05),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: AppColors.primary.withValues(alpha: isDark ? 0.08 : 0.03),
                blurRadius: 18,
                offset: const Offset(0, 6),
                spreadRadius: -2,
              ),
            ],
          ),
          child: horizontal
              ? _buildHorizontalCard(textPrimary, textSecondary, isDark)
              : _buildVerticalCard(textPrimary, textSecondary, isDark),
        ),
      ),
    );
  }

  // ============================================================
  // VERTICAL CARD (CATEGORY GRIDS & FULL LISTS)
  // ============================================================
  Widget _buildVerticalCard(
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    final categoryText = recipe.category.trim().isNotEmpty
        ? recipe.category
        : 'Chef Special';

    final areaText = recipe.area.trim().isNotEmpty
        ? recipe.area
        : 'Global';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Stack with Badges
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 1.25,
              child: _buildImage(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(21),
                ),
              ),
            ),

            // Gradient Scrim at bottom of image
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 44,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.55),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Rating Pill (Bottom-Left on image)
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.70),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 12,
                      color: Colors.amber,
                    ),
                    SizedBox(width: 2.5),
                    Text(
                      '4.8',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Cuisine/Area Badge (Top-Left)
            if (recipe.area.trim().isNotEmpty)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.public_rounded,
                        size: 11,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        recipe.area,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Favorite Button (Top-Right)
            Positioned(
              top: 8,
              right: 8,
              child: _favoriteButton(),
            ),
          ],
        ),

        // Info Section
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Tag Pill & Recipe Title
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2.5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$categoryText • $areaText',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      recipe.name.trim().isNotEmpty
                          ? recipe.name
                          : 'Delicious Recipe',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                        height: 1.25,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),

                // Cooking Stats & View Details Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 12.5,
                          color: textSecondary,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '25m',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'View Recipe →',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // HORIZONTAL CARD (HOME TRENDING CAROUSEL)
  // ============================================================
  Widget _buildHorizontalCard(
    Color textPrimary,
    Color textSecondary,
    bool isDark,
  ) {
    final categoryText = recipe.category.trim().isNotEmpty
        ? recipe.category
        : 'Trending';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Stack
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 1.30,
              child: _buildImage(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(21),
                ),
              ),
            ),

            // Gradient Scrim
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 44,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.55),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Rating Pill (Bottom-Left)
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.70),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 12,
                      color: Colors.amber,
                    ),
                    SizedBox(width: 2.5),
                    Text(
                      '4.9',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Category Pill (Top-Left)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  '🔥 $categoryText',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            // Favorite Button (Top-Right)
            Positioned(
              top: 8,
              right: 8,
              child: _favoriteButton(),
            ),
          ],
        ),

        // Info Section
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2.5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Chef Recommendation',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      recipe.name.trim().isNotEmpty
                          ? recipe.name
                          : 'Delicious Recipe',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                        height: 1.25,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 12.5,
                          color: textSecondary,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '25-30m',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'View Details →',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
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
        final isFavorite = controller.isFavorite(recipe.id);

        return Material(
          color: Colors.black.withValues(alpha: 0.45),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              final favoriteRecipe = FavoriteRecipeModel(
                id: recipe.id,
                name: recipe.name,
                image: recipe.image,
              );

              controller.toggleFavorite(favoriteRecipe);
              controller.update();
            },
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: isFavorite ? Colors.redAccent : Colors.white,
                size: 18,
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
              errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _imageLoading();
              },
            ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.primaryLight,
      child: const Center(
        child: Icon(
          Icons.restaurant_rounded,
          color: AppColors.primary,
          size: 32,
        ),
      ),
    );
  }

  Widget _imageLoading() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.primaryLight,
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}