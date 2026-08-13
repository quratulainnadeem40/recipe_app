class RecipeModel {
  final String id;
  final String name;
  final String image;

  RecipeModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal']?.toString() ?? '',
      image: json['strMealThumb']?.toString() ?? '',
    );
  }
}