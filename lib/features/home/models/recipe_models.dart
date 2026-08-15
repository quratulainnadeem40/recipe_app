class RecipeModel {
  final String id;
  final String name;
  final String image;
  final String category;
  final String area;
  final String shortInfo;

  RecipeModel({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.area,
    required this.shortInfo,
  });

  factory RecipeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final String category =
        json['strCategory']?.toString() ?? 'Recipe';

    final String area =
        json['strArea']?.toString() ?? 'International';

    return RecipeModel(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal']?.toString() ?? '',
      image: json['strMealThumb']?.toString() ?? '',
      category: category,
      area: area,
      shortInfo: _getShortInfo(category),
    );
  }

  static String _getShortInfo(String category) {
    switch (category.toLowerCase()) {
      case 'chicken':
        return 'Tender spiced chicken dish';

      case 'beef':
        return 'Rich savory beef dish';

      case 'lamb':
        return 'Juicy aromatic lamb dish';

      case 'pasta':
        return 'Delicious Italian pasta dish';

      case 'seafood':
        return 'Fresh flavorful seafood dish';

      case 'vegetarian':
        return 'Fresh healthy vegetable dish';

      case 'dessert':
        return 'Sweet delicious dessert treat';

      case 'side':
        return 'Perfect flavorful side dish';

      case 'starter':
        return 'Tasty appetizer to enjoy';

      case 'breakfast':
        return 'Delicious morning breakfast meal';

      case 'miscellaneous':
        return 'Delicious homemade comfort food';

      case 'pork':
        return 'Tender flavorful pork dish';

      case 'goat':
        return 'Rich aromatic goat dish';

      default:
        return 'Delicious homemade recipe';
    }
  }
}