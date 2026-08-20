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
        height: 260,
        child: Center(
          child: Text(
            'No recipes found',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];

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