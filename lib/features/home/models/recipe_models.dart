class RecipeModel {
  final String id;
  final String name;
  final String image;
  final String category;
  final String area;
  final String shortInfo;

  const RecipeModel({
    required this.id,
    required this.name,
    required this.image,
    this.category = '',
    this.area = '',
    this.shortInfo = '',
  });

  factory RecipeModel.fromJson(
    Map<String, dynamic> json, {
    String fallbackCategory = '',
    String fallbackArea = '',
  }) {
    return RecipeModel(
      id: (json['idMeal'] ?? json['id'] ?? '').toString(),
      name: (json['strMeal'] ?? json['name'] ?? '').toString(),
      image: (json['strMealThumb'] ?? json['image'] ?? '').toString(),
      category: (
        json['strCategory'] ??
        json['category'] ??
        fallbackCategory
      ).toString(),
      area: (
        json['strArea'] ??
        json['area'] ??
        fallbackArea
      ).toString(),
      shortInfo: (
        json['strInstructions'] ??
        json['shortInfo'] ??
        ''
      ).toString(),
    );
  }

  RecipeModel copyWith({
    String? id,
    String? name,
    String? image,
    String? category,
    String? area,
    String? shortInfo,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      category: category ?? this.category,
      area: area ?? this.area,
      shortInfo: shortInfo ?? this.shortInfo,
    );
  }
}