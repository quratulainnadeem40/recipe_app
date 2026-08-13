class RecipeDetailsModel {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String image;
  final String youtube;

  final List<String> ingredients;
  final List<String> measures;

  RecipeDetailsModel({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.image,
    required this.youtube,
    required this.ingredients,
    required this.measures,
  });

  factory RecipeDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final List<String> ingredients = [];
    final List<String> measures = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient =
          json['strIngredient$i']?.toString().trim() ?? '';

      final measure =
          json['strMeasure$i']?.toString().trim() ?? '';

      if (ingredient.isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(measure);
      }
    }

    return RecipeDetailsModel(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal']?.toString() ?? '',
      category: json['strCategory']?.toString() ?? '',
      area: json['strArea']?.toString() ?? '',
      instructions:
          json['strInstructions']?.toString() ?? '',
      image: json['strMealThumb']?.toString() ?? '',
      youtube: json['strYoutube']?.toString() ?? '',
      ingredients: ingredients,
      measures: measures,
    );
  }
}