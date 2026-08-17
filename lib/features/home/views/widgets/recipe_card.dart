import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/features/home/models/recipe_models.dart';
import 'package:recipe_app/features/favorites/controllers/favorites_controller.dart';
import 'package:recipe_app/features/favorites/models/favorite_recipe_model.dart';

class RecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final VoidCallback? onTap;
  final bool horizontal;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
    this.horizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    final FavoritesController favoritesController =
        Get.find<FavoritesController>();

    final ThemeData theme = Theme.of(context);

    final Color cardColor = theme.cardColor;
    final Color textColor = theme.colorScheme.onSurface;

    final Color secondaryTextColor =
        theme.textTheme.bodySmall?.color?.withValues(
              alpha: 0.65,
            ) ??
            Colors.grey;

    return SizedBox(
      width: horizontal ? 205 : double.infinity,
      height: 260,

      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        margin: const EdgeInsets.only(right: 12),
        color: cardColor,

        child: InkWell(
          onTap: onTap,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =====================================================
              // RECIPE IMAGE
              // =====================================================

              SizedBox(
                width: double.infinity,
                height: 135,

                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // =================================================
                    // IMAGE
                    // =================================================

                    Image.network(
                      recipe.image,
                      fit: BoxFit.cover,

                      loadingBuilder: (
                        context,
                        child,
                        loadingProgress,
                      ) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        );
                      },

                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                          alignment: Alignment.center,

                          child: Icon(
                            Icons.restaurant_rounded,
                            size: 40,
                            color: secondaryTextColor,
                          ),
                        );
                      },
                    ),

                    // =================================================
                    // FAVORITE BUTTON
                    // =================================================

                    Positioned(
                      top: 8,
                      right: 8,

                      child: Obx(
                        () {
                          final bool isFavorite =
                              favoritesController.isFavorite(
                            recipe.id,
                          );

                          return Material(
                            color: Colors.white.withValues(
                              alpha: 0.90,
                            ),
                            shape: const CircleBorder(),

                            child: SizedBox(
                              width: 38,
                              height: 38,

                              child: IconButton(
                                padding: EdgeInsets.zero,

                                tooltip: isFavorite
                                    ? 'Remove from favorites'
                                    : 'Add to favorites',

                                onPressed: () {
                                  final FavoriteRecipeModel
                                      favoriteRecipe =
                                      FavoriteRecipeModel(
                                    id: recipe.id,
                                    name: recipe.name,
                                    image: recipe.image,
                                  );

                                  favoritesController.toggleFavorite(
                                    favoriteRecipe,
                                  );
                                },

                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,

                                  color: isFavorite
                                      ? Colors.red
                                      : Colors.grey.shade700,

                                  size: 22,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // =====================================================
              // RECIPE INFORMATION
              // =====================================================

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    10,
                    6,
                    10,
                    6,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    mainAxisAlignment:
                        MainAxisAlignment.start,

                    children: [
                      // ===============================================
                      // RECIPE NAME
                      // ===============================================

                      Text(
                        recipe.name,

                        maxLines: 1,

                        overflow:
                            TextOverflow.ellipsis,

                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // ===============================================
                      // AREA + CATEGORY
                      // ===============================================

                      Text(
                        '🍴 ${recipe.area} • ${recipe.category}',

                        maxLines: 1,

                        overflow:
                            TextOverflow.ellipsis,

                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // ===============================================
                      // SHORT INFO
                      // ===============================================

                      Expanded(
                        child: Text(
                          recipe.shortInfo,

                          maxLines: 2,

                          overflow:
                              TextOverflow.ellipsis,

                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 9.5,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}