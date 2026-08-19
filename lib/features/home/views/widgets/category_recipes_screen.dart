import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          '$category Recipes',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isCategoryLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        if (controller.categoryErrorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                controller.categoryErrorMessage.value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }

        if (controller.categoryRecipes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant_rounded,
                  size: 64,
                  color: AppColors.textHint.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 12),
                Text(
                  'No $category recipes found',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 16,
            childAspectRatio: 0.72,
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