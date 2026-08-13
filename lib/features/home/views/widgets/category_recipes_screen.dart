import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/features/home/controllers/home_controller.dart';
import 'package:recipe_app/features/home/views/widgets/recipe_card.dart';

class CategoryRecipesScreen extends StatelessWidget {
  final String category;

  const CategoryRecipesScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('$category Recipes'),
      ),
      body: Obx(() {
        if (controller.isCategoryLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.categoryErrorMessage.value.isNotEmpty) {
          return Center(
            child: Text(
              controller.categoryErrorMessage.value,
              textAlign: TextAlign.center,
            ),
          );
        }

        if (controller.categoryRecipes.isEmpty) {
          return const Center(
            child: Text('No recipes found'),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.68,
          ),
          itemCount: controller.categoryRecipes.length,
          itemBuilder: (context, index) {
            final recipe = controller.categoryRecipes[index];

            return RecipeCard(
              recipe: recipe,
              horizontal: false,
              onTap: () {
                Get.toNamed(
                  '/recipe-details',
                  arguments: recipe.id,
                );
              },
            );
          },
        );
      }),
    );
  }
}