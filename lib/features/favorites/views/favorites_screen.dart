
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/routes/app_routes.dart';
import 'package:recipe_app/features/favorites/views/widgets/favorite_recipe_card.dart';
import 'package:recipe_app/features/favorites/views/widgets/favorites_recipe_card.dart';

import '../controllers/favorites_controller.dart';

class FavoritesScreen extends GetView<FavoritesController> {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: Obx(
        () {
          // ==========================================
          // EMPTY FAVORITES
          // ==========================================

          if (controller.favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 80,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No Favorite Recipes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your favorite recipes will appear here.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // ==========================================
          // FAVORITES LIST
          // ==========================================

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.favorites.length,
            itemBuilder: (context, index) {
              final recipe = controller.favorites[index];

              return FavoriteRecipeCard(
                recipe: recipe,

                // ====================================
                // REMOVE FAVORITE
                // ====================================

                onRemove: () {
                  controller.removeFavorite(recipe.id);
                },

                // ====================================
                // OPEN RECIPE DETAILS
                // ====================================

                onTap: () {
                  Get.toNamed(
                    AppRoutes.recipeDetails,
                    arguments: recipe.id,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
