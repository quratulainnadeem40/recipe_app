import 'package:flutter/material.dart';
import 'package:recipe_app/features/favorites/models/favorite_recipe_model.dart';

class FavoriteRecipeCard extends StatelessWidget {
  final FavoriteRecipeModel recipe;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const FavoriteRecipeCard({
    super.key,
    required this.recipe,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: recipe.image.isNotEmpty
              ? Image.network(
                  recipe.image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.fastfood, size: 40),
                )
              : const Icon(Icons.fastfood, size: 40),
        ),
        title: Text(
          recipe.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: onRemove,
        ),
      ),
    );
  }
}