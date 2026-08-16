
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../home/models/recipe_models.dart';

class SearchRecipeCard extends StatelessWidget {
  final RecipeModel recipe;

  const SearchRecipeCard({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          Get.toNamed(
            AppRoutes.recipeDetails,
            arguments: recipe.id,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // RECIPE IMAGE
            // =====================================================

            AspectRatio(
              aspectRatio: 1.25,
              child: Image.network(
                recipe.image,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return const Center(
                    child: Icon(
                      Icons.restaurant_rounded,
                      size: 45,
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
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                      ),
                    ),
                  );
                },
              ),
            ),

            // =====================================================
            // RECIPE INFORMATION
            // =====================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                10,
                8,
                10,
                10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // -------------------------------------------------
                  // RECIPE NAME
                  // -------------------------------------------------

                  Text(
                    recipe.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // -------------------------------------------------
                  // AREA + CATEGORY
                  // -------------------------------------------------

                  Text(
                    '🍴 ${recipe.area} • ${recipe.category}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
