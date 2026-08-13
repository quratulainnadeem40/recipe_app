import 'package:flutter/material.dart';
import 'package:recipe_app/features/home/models/recipe_models.dart';

class RecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final VoidCallback? onTap;
  final bool horizontal;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
    this.horizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: horizontal ? 220 : double.infinity,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        margin: const EdgeInsets.only(right: 12),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 150,
                child: Image.network(
                  recipe.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.restaurant,
                        size: 50,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}