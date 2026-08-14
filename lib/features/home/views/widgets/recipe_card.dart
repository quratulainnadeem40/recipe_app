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
      width: horizontal ? 220 : double.infinity,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        margin: const EdgeInsets.only(right: 12),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // IMAGE + FAVORITE BUTTON
              // ==========================================
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: Image.network(
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
                            size: 50,
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
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),

                  // ======================================
                  // FAVORITE BUTTON
                  // ======================================
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
                          color: Colors.white.withOpacity(0.9),
                          shape: const CircleBorder(),
                          child: IconButton(
                            onPressed: () {
                              final favoriteRecipe =
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
                                  : Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              // ==========================================
              // RECIPE NAME
              // ==========================================
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  recipe.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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