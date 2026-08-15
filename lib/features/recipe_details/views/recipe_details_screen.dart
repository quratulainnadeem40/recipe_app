import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/features/recipe_details/controllers/recipe_details_controller.dart';

class RecipeDetailsScreen extends GetView<RecipeDetailsController> {
  const RecipeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
      ),
      body: Obx(() {
        // Loading
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Error
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    final String id =
                        Get.arguments as String;

                    controller.getRecipeDetails(id);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // No data
        final recipe = controller.recipe.value;

        if (recipe == null) {
          return const Center(
            child: Text('Recipe not found'),
          );
        }

        // Recipe Details
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              SizedBox(
                width: double.infinity,
                height: 280,
                child: Image.network(
                  recipe.image,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 60,
                      ),
                    );
                  },
                ),
              ),

              // Recipe Name
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  20,
                  16,
                  8,
                ),
                child: Text(
                  recipe.name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Category & Area
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _InfoItem(
                        title: 'Category',
                        value: recipe.category,
                      ),
                    ),
                    Expanded(
                      child: _InfoItem(
                        title: 'Cuisine',
                        value: recipe.area,
                      ),
                    ),
                  ],
                ),
              ),

              // Ingredients
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  24,
                  16,
                  12,
                ),
                child: Text(
                  'Ingredients',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                  children: List.generate(
                    recipe.ingredients.length,
                    (index) {
                      final ingredient =
                          recipe.ingredients[index];

                      final measure =
                          recipe.measures[index];

                      return Padding(
                        padding:
                            const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '• ',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '$ingredient${measure.isNotEmpty ? ' - $measure' : ''}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Instructions
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  24,
                  16,
                  12,
                ),
                child: Text(
                  'Instructions',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  30,
                ),
                child: Text(
                  recipe.instructions,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _InfoItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}