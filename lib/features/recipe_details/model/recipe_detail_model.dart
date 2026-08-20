class IngredientItem {
  final String name;
  final String measure;

  const IngredientItem({
    required this.name,
    required this.measure,
  });
}

class RecipeDetailsModel {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbUrl;
  final String youtubeUrl;
  final List<String> tags;
  final List<IngredientItem> ingredients;

  const RecipeDetailsModel({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbUrl,
    required this.youtubeUrl,
    required this.tags,
    required this.ingredients,
  });

  factory RecipeDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final List<IngredientItem> parsedIngredients = [];

    // =========================================================
    // INGREDIENTS
    // TheMealDB: strIngredient1 ... strIngredient20
    // =========================================================

    for (int i = 1; i <= 20; i++) {
      final String ingredient =
          (json['strIngredient$i'] ?? '').toString().trim();

      final String measure =
          (json['strMeasure$i'] ?? '').toString().trim();

      if (ingredient.isNotEmpty) {
        parsedIngredients.add(
          IngredientItem(
            name: ingredient,
            measure: measure,
          ),
        );
      }
    }

    // =========================================================
    // TAGS
    // =========================================================

    final List<String> parsedTags = [];

    final String rawTags =
        (json['strTags'] ?? '').toString().trim();

    if (rawTags.isNotEmpty) {
      parsedTags.addAll(
        rawTags
            .split(',')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty),
      );
    }

    // =========================================================
    // MAIN IMAGE
    // =========================================================

    final String image =
        (json['strMealThumb'] ?? '').toString().trim();

    // =========================================================
    // RETURN MODEL
    // =========================================================

    return RecipeDetailsModel(
      id: (json['idMeal'] ?? '').toString(),
      name: (json['strMeal'] ?? '').toString().trim(),
      category: (json['strCategory'] ?? '').toString().trim(),
      area: (json['strArea'] ?? '').toString().trim(),
      instructions:
          (json['strInstructions'] ?? '').toString().trim(),
      thumbUrl: image,
      youtubeUrl:
          (json['strYoutube'] ?? '').toString().trim(),
      tags: parsedTags,
      ingredients: parsedIngredients,
    );
  }

  // =========================================================
  // COPY WITH
  // =========================================================

  RecipeDetailsModel copyWith({
    String? id,
    String? name,
    String? category,
    String? area,
    String? instructions,
    String? thumbUrl,
    String? youtubeUrl,
    List<String>? tags,
    List<IngredientItem>? ingredients,
  }) {
    return RecipeDetailsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      area: area ?? this.area,
      instructions: instructions ?? this.instructions,
      thumbUrl: thumbUrl ?? this.thumbUrl,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      tags: tags ?? this.tags,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  // =========================================================
  // HELPERS
  // =========================================================

  bool get hasImage => thumbUrl.isNotEmpty;

  bool get hasIngredients => ingredients.isNotEmpty;

  bool get hasInstructions => instructions.isNotEmpty;

  bool get hasYoutubeVideo => youtubeUrl.isNotEmpty;

  bool get hasTags => tags.isNotEmpty;

  int get ingredientCount => ingredients.length;

  // =========================================================
  // INSTRUCTION STEPS
  // =========================================================

  List<String> get instructionSteps {
    if (instructions.trim().isEmpty) {
      return [];
    }

    final List<String> steps = instructions
        .split(RegExp(r'\r?\n+'))
        .map((step) => step.trim())
        .where((step) => step.isNotEmpty)
        .toList();

    // If API returned one large paragraph,
    // keep it as one readable instruction instead
    // of creating broken steps.
    if (steps.isEmpty) {
      return [instructions.trim()];
    }

    return steps;
  }
}