import 'package:flutter/material.dart';

import '../../models/favorite_recipe_model.dart';

class FavoriteRecipeCard extends StatelessWidget {
  final FavoriteRecipeModel recipe;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const FavoriteRecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // ==========================================
            // RECIPE IMAGE
            // ==========================================
            SizedBox(
              width: 110,
              height: 110,
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
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),

            // ==========================================
            // RECIPE INFORMATION
            // ==========================================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  recipe.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // ==========================================
            // REMOVE FAVORITE
            // ==========================================
            IconButton(
              onPressed: onRemove,
              icon: const Icon(
                Icons.favorite_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}