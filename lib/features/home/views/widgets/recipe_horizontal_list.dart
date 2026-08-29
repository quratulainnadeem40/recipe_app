import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/routes/app_routes.dart';
import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/home/models/recipe_models.dart';
import 'recipe_card.dart';

class RecipeHorizontalList extends StatelessWidget {
  final List<RecipeModel> recipes;

  const RecipeHorizontalList({
    super.key,
    required this.recipes,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    // ============================================================
    // EMPTY STATE
    // ============================================================

    if (recipes.isEmpty) {
      return SizedBox(
        height: 220,

        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              Container(
                padding:
                    const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.restaurant_menu_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'No trending recipes found',

                style: TextStyle(
                  color: textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ============================================================
    // HORIZONTAL RECIPE LIST
    // ============================================================

    return SizedBox(
      height: 235,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];

          return Container(
            width: 175,
            margin: const EdgeInsets.only(
              right: 14,
            ),


            child: RecipeCard(
              recipe: recipe,
              horizontal: true,

              onTap: () {
                if (recipe.id.trim().isEmpty) {
                  return;
                }

                Get.toNamed(
                  AppRoutes.recipeDetails,
                  arguments: recipe.id,
                );
              },
            ),
          );
        },
      ),
    );
  }
}