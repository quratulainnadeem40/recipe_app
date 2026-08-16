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

    return SizedBox(
      width: horizontal ? 275 : double.infinity,
      height: 190,

      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        margin: const EdgeInsets.only(right: 12),

        child: InkWell(
          onTap: onTap,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              // =====================================================
              // IMAGE + FAVORITE
              // =====================================================

              SizedBox(
                width: double.infinity,
                height: 105,

                child: Stack(
                  fit: StackFit.expand,
                  children: [

                    Image.network(
                      recipe.image,
                      fit: BoxFit.cover,

                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return const Center(
                          child: Icon(
                            Icons.restaurant,
                            size: 40,
                          ),
                        );
                      },

                      loadingBuilder: (
                        context,
                        child,
                        loadingProgress,
                      ) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                    ),

                    // =================================================
                    // FAVORITE BUTTON
                    // =================================================

                    Positioned(
                      top: 6,
                      right: 6,

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

                                onPressed: () {
                                  final favoriteRecipe =
                                      FavoriteRecipeModel(
                                    id: recipe.id,
                                    name: recipe.name,
                                    image: recipe.image,
                                  );

                                  favoritesController
                                      .toggleFavorite(
                                    favoriteRecipe,
                                  );
                                },

                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,

                                  color: isFavorite
                                      ? Colors.red
                                      : Colors.grey,

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

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  10,
                  5,
                  10,
                  4,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,

                  children: [

                    // =================================================
                    // NAME
                    // =================================================

                    Text(
                      recipe.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 2),

                    // =================================================
                    // AREA + CATEGORY
                    // =================================================

                    Text(
                      '🍴 ${recipe.area} • ${recipe.category}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 10.5,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 2),

                    // =================================================
                    // SHORT INFO
                    // =================================================

                    Text(
                      recipe.shortInfo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 10.5,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 1),

                    // =================================================
                    // EXTRA WORDS
                    // =================================================

                    Text(
                      '${recipe.category} • ${recipe.area} • Tasty • Easy',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}