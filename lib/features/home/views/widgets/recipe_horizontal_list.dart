import 'package:flutter/material.dart';

import 'package:recipe_app/features/home/models/recipe_models.dart';
import 'package:recipe_app/features/home/views/widgets/recipe_card.dart';

class RecipeHorizontalList extends StatelessWidget {
  final List<RecipeModel> recipes;
  final Function(RecipeModel)? onRecipeTap;

  const RecipeHorizontalList({
    super.key,
    required this.recipes,
    this.onRecipeTap,
  });

  @override
  Widget build(BuildContext context) {
    if (recipes.isEmpty) {
      return const SizedBox(
        height: 365,
        child: Center(
          child: Text(
            'No recipes found',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 365,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final RecipeModel recipe = recipes[index];

          return RecipeCard(
            recipe: recipe,
            horizontal: true,
            onTap: () {
              onRecipeTap?.call(recipe);
            },
          );
        },
      ),
    );
  }
}