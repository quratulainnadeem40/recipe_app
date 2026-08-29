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

  // ============================================================
  // FILTERING HELPERS
  // ============================================================

  String get difficulty {
    final hash = id.hashCode.abs();
    if (hash % 3 == 0) return 'Easy';
    if (hash % 3 == 1) return 'Medium';
    return 'Hard';
  }

  int get estimatedTimeMinutes {
    final hash = id.hashCode.abs();
    final rem = hash % 4;
    if (rem == 0) return 15;
    if (rem == 1) return 25;
    if (rem == 2) return 40;
    return 55;
  }

  bool get isVegetarian {
    final cat = category.toLowerCase();
    final nm = name.toLowerCase();
    return cat.contains('vegetarian') ||
        cat.contains('vegan') ||
        cat.contains('dessert') ||
        cat.contains('pasta') ||
        nm.contains('salad') ||
        nm.contains('soup') ||
        nm.contains('vegetable') ||
        nm.contains('paneer') ||
        nm.contains('dal') ||
        nm.contains('curry') ||
        (!cat.contains('beef') &&
            !cat.contains('chicken') &&
            !cat.contains('pork') &&
            !cat.contains('lamb') &&
            !cat.contains('goat') &&
            !cat.contains('seafood'));
  }

  bool get isVegan {
    final cat = category.toLowerCase();
    final nm = name.toLowerCase();
    return cat.contains('vegan') ||
        nm.contains('vegan') ||
        nm.contains('tofu') ||
        nm.contains('salad') ||
        nm.contains('plant');
  }

  bool get isHealthy {
    final cat = category.toLowerCase();
    final nm = name.toLowerCase();
    return cat.contains('vegan') ||
        cat.contains('vegetarian') ||
        cat.contains('seafood') ||
        cat.contains('starter') ||
        nm.contains('salad') ||
        nm.contains('soup') ||
        nm.contains('grilled') ||
        nm.contains('fresh') ||
        nm.contains('lemon') ||
        nm.contains('fish');
  }
}