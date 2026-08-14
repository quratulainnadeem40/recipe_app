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
            Expanded(
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
                      Icons.restaurant,
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
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                recipe.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}