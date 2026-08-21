// ============================================================
// RECIPE MODEL
// ============================================================

class Recipe {
  final String id;
  final String name;

  // ==========================================================
  // BASIC INFORMATION
  // ==========================================================

  final String cuisine;
  final String category;
  final String difficulty;

  // ==========================================================
  // RATING
  // ==========================================================

  final double rating;
  final int reviews;

  // ==========================================================
  // TIME
  // ==========================================================

  final int prepTime;

  // ==========================================================
  // IMAGE
  // ==========================================================

  final String imageUrl;

  // ==========================================================
  // RECIPE CONTENT
  // ==========================================================

  final List<String> ingredients;
  final List<String> steps;

  // ==========================================================
  // EXTRA RECIPE DETAIL DATA
  // ==========================================================

  final String instructions;
  final String youtubeUrl;
  final List<String> tags;

  // ==========================================================
  // FAVORITE
  // ==========================================================

  bool isFavorite;

  // ==========================================================
  // CONSTRUCTOR
  // ==========================================================

  Recipe({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.difficulty,
    required this.imageUrl,
    required this.prepTime,
    required this.ingredients,
    required this.steps,
    this.instructions = '',
    this.youtubeUrl = '',
    this.tags = const [],
    this.isFavorite = false,
  });

  // ==========================================================
  // JSON → RECIPE
  // ==========================================================

  factory Recipe.fromJson(
    Map<String, dynamic> json,
  ) {
    final List<String> parsedIngredients = [];

    for (int i = 1; i <= 20; i++) {
      final String ingredient =
          (json['strIngredient$i'] ?? '').toString().trim();

      final String measure =
          (json['strMeasure$i'] ?? '').toString().trim();

      if (ingredient.isNotEmpty) {
        if (measure.isNotEmpty) {
          parsedIngredients.add(
            '$measure $ingredient',
          );
        } else {
          parsedIngredients.add(ingredient);
        }
      }
    }

    // ========================================================
    // TAGS
    // ========================================================

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

    // ========================================================
    // INSTRUCTIONS
    // ========================================================

    final String parsedInstructions =
        (json['strInstructions'] ?? '').toString().trim();

    final List<String> parsedSteps = [];

    if (parsedInstructions.isNotEmpty) {
      parsedSteps.addAll(
        parsedInstructions
            .split(RegExp(r'\r?\n+'))
            .map((step) => step.trim())
            .where((step) => step.isNotEmpty),
      );

      if (parsedSteps.isEmpty) {
        parsedSteps.add(parsedInstructions);
      }
    }

    // ========================================================
    // RETURN
    // ========================================================

    return Recipe(
      id: (json['idMeal'] ?? '').toString().trim(),

      name: (json['strMeal'] ?? '').toString().trim(),

      cuisine:
          (json['strArea'] ?? '').toString().trim(),

      category:
          (json['strCategory'] ?? '').toString().trim(),

      rating:
          double.tryParse(
                (json['rating'] ?? '0').toString(),
              ) ??
              0.0,

      reviews:
          int.tryParse(
                (json['reviews'] ?? '0').toString(),
              ) ??
              0,

      difficulty:
          (json['difficulty'] ?? 'Easy').toString().trim(),

      imageUrl:
          (json['strMealThumb'] ?? '').toString().trim(),

      prepTime:
          int.tryParse(
                (json['prepTime'] ?? '0').toString(),
              ) ??
              0,

      ingredients: parsedIngredients,

      steps: parsedSteps,

      instructions: parsedInstructions,

      youtubeUrl:
          (json['strYoutube'] ?? '').toString().trim(),

      tags: parsedTags,
    );
  }

  // ==========================================================
  // COPY WITH
  // ==========================================================

  Recipe copyWith({
    String? id,
    String? name,
    String? cuisine,
    String? category,
    double? rating,
    int? reviews,
    String? difficulty,
    String? imageUrl,
    int? prepTime,
    List<String>? ingredients,
    List<String>? steps,
    String? instructions,
    String? youtubeUrl,
    List<String>? tags,
    bool? isFavorite,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      cuisine: cuisine ?? this.cuisine,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      difficulty: difficulty ?? this.difficulty,
      imageUrl: imageUrl ?? this.imageUrl,
      prepTime: prepTime ?? this.prepTime,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      instructions: instructions ?? this.instructions,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  // ==========================================================
  // HELPERS FOR UI
  // ==========================================================

  bool get hasImage => imageUrl.trim().isNotEmpty;

  bool get hasIngredients => ingredients.isNotEmpty;

  bool get hasSteps => steps.isNotEmpty;

  bool get hasInstructions =>
      instructions.trim().isNotEmpty;

  bool get hasYoutubeVideo =>
      youtubeUrl.trim().isNotEmpty;

  bool get hasTags => tags.isNotEmpty;

  int get ingredientCount => ingredients.length;

  int get stepCount => steps.length;

  // ==========================================================
  // DISPLAY VALUES
  // ==========================================================

  String get displayCuisine {
    return cuisine.isEmpty ? 'International' : cuisine;
  }

  String get displayCategory {
    return category.isEmpty ? 'Recipe' : category;
  }

  String get displayDifficulty {
    return difficulty.isEmpty ? 'Easy' : difficulty;
  }

  String get displayPrepTime {
    if (prepTime <= 0) {
      return 'Time not available';
    }

    return '$prepTime min';
  }

  // ==========================================================
  // INSTRUCTION STEPS
  // ==========================================================

  List<String> get instructionSteps {
    if (instructions.trim().isEmpty) {
      return steps;
    }

    final List<String> parsedSteps = instructions
        .split(RegExp(r'\r?\n+'))
        .map((step) => step.trim())
        .where((step) => step.isNotEmpty)
        .toList();

    if (parsedSteps.isEmpty) {
      return [instructions.trim()];
    }

    return parsedSteps;
  }

  // ==========================================================
  // EMPTY MODEL
  // ==========================================================

  static Recipe empty() {
    return Recipe(
      id: '',
      name: '',
      cuisine: '',
      category: '',
      rating: 0.0,
      reviews: 0,
      difficulty: '',
      imageUrl: '',
      prepTime: 0,
      ingredients: const [],
      steps: const [],
      instructions: '',
      youtubeUrl: '',
      tags: const [],
      isFavorite: false,
    );
  }
}