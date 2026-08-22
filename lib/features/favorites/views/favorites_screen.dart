import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/routes/app_routes.dart';
import 'package:recipe_app/features/favorites/controllers/favorites_controller.dart';
import 'package:recipe_app/features/favorites/views/widgets/favorite_recipe_card.dart';
import 'package:recipe_app/features/navigation/controllers/navigation_controller.dart';

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
          // =====================================================
          // EMPTY FAVORITES
          // =====================================================

          if (controller.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite_border_rounded,
                    size: 80,
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'No Favorite Recipes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Your favorite recipes will appear here.',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  // =================================================
                  // EXPLORE RECIPES BUTTON
                  // =================================================

              ElevatedButton.icon(
  onPressed: () {
    final navigationController = Get.find<NavigationController>();
    navigationController.changePage(0);
  },
  icon: const Icon(Icons.explore_rounded),
  label: const Text('Explore Recipes'),
),


                ],
              ),
            );
          }

          // =====================================================
          // FAVORITES LIST
          // =====================================================

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.favorites.length,
            itemBuilder: (context, index) {
              final recipe = controller.favorites[index];

              return FavoriteRecipeCard(
                recipe: recipe,

                // =================================================
                // REMOVE FAVORITE
                // =================================================

                onRemove: () {
                  controller.removeFavorite(
                    recipe.id,
                  );
                },

                // =================================================
                // OPEN RECIPE DETAILS
                // =================================================

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