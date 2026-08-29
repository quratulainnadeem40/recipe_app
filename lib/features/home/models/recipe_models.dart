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
    if (cat == 'vegetarian' || cat == 'vegan') return true;
    final nonVegWords = [
      'chicken',
      'beef',
      'pork',
      'lamb',
      'goat',
      'fish',
      'salmon',
      'tuna',
      'shrimp',
      'prawn',
      'meat',
      'bacon',
      'turkey',
      'duck',
      'clam',
      'mussel'
    ];
    for (final word in nonVegWords) {
      if (cat.contains(word) || nm.contains(word)) return false;
    }
    return cat.contains('dessert') ||
        cat.contains('pasta') ||
        cat.contains('side') ||
        nm.contains('salad') ||
        nm.contains('soup') ||
        nm.contains('veg') ||
        nm.contains('cheese') ||
        nm.contains('potato') ||
        nm.contains('bread') ||
        nm.contains('cake') ||
        nm.contains('pie') ||
        nm.contains('paneer') ||
        nm.contains('dal');
  }

  bool get isVegan {
    final cat = category.toLowerCase();
    final nm = name.toLowerCase();
    if (cat == 'vegan') return true;
    final nonVeganWords = [
      'chicken',
      'beef',
      'pork',
      'lamb',
      'goat',
      'fish',
      'salmon',
      'shrimp',
      'meat',
      'egg',
      'cheese',
      'butter',
      'milk',
      'cream',
      'bacon'
    ];
    for (final word in nonVeganWords) {
      if (cat.contains(word) || nm.contains(word)) return false;
    }
    return nm.contains('vegan') ||
        nm.contains('tofu') ||
        nm.contains('plant') ||
        nm.contains('avocado') ||
        nm.contains('salad') ||
        nm.contains('hummus') ||
        nm.contains('spinach') ||
        nm.contains('lentil') ||
        nm.contains('bean');
  }

  bool get isHealthy {
    final cat = category.toLowerCase();
    final nm = name.toLowerCase();
    final unHealthyWords = [
      'cake',
      'pie',
      'pudding',
      'fudge',
      'cookie',
      'sweet',
      'chocolate',
      'fried',
      'sugar',
      'pork',
      'tart'
    ];
    for (final word in unHealthyWords) {
      if (cat.contains(word) || nm.contains(word)) return false;
    }
    return cat == 'vegan' ||
        cat == 'vegetarian' ||
        cat == 'seafood' ||
        cat == 'starter' ||
        nm.contains('salad') ||
        nm.contains('soup') ||
        nm.contains('grilled') ||
        nm.contains('fresh') ||
        nm.contains('lemon') ||
        nm.contains('fish') ||
        nm.contains('boiled') ||
        nm.contains('steam');
  }
}
