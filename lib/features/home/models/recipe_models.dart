class RecipeModel {
  final String id;
  final String name;
  final String image;
  final String category;
  final String area;
  final String shortInfo;
  final int? prepTime;

  const RecipeModel({
    required this.id,
    required this.name,
    required this.image,
    this.category = '',
    this.area = '',
    this.shortInfo = '',
    this.prepTime,
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
      prepTime: int.tryParse(
        (json['prepTime'] ?? '').toString(),
      ),
    );
  }

  RecipeModel copyWith({
    String? id,
    String? name,
    String? image,
    String? category,
    String? area,
    String? shortInfo,
    int? prepTime,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      category: category ?? this.category,
      area: area ?? this.area,
      shortInfo: shortInfo ?? this.shortInfo,
      prepTime: prepTime ?? this.prepTime,
    );
  }

  // ============================================================
  // FILTERING HELPERS
  // ============================================================

  String get difficulty {
    final time = estimatedTimeMinutes;
    if (time <= 20) return 'Easy';
    if (time <= 40) return 'Medium';
    return 'Hard';
  }

  int get estimatedTimeMinutes {
    if (prepTime != null && prepTime! > 0) {
      return prepTime!;
    }
    final cat = category.toLowerCase();
    final nm = name.toLowerCase();

    // 15 Mins: Quick meals, Snacks, Salads, Dips, Breakfast, Drinks
    if (cat == 'breakfast' ||
        cat == 'starter' ||
        cat == 'side' ||
        nm.contains('salad') ||
        nm.contains('snack') ||
        nm.contains('shake') ||
        nm.contains('sandwich') ||
        nm.contains('toast') ||
        nm.contains('omelette') ||
        nm.contains('egg') ||
        nm.contains('chaat') ||
        nm.contains('raita') ||
        nm.contains('jalebi') ||
        nm.contains('tea') ||
        nm.contains('chai') ||
        nm.contains('falooda')) {
      return 15;
    }

    // 25 Mins: Desserts, Seafood, Quick Daal, Fast Stir-fry, Tikkas, Kababs
    if (cat == 'dessert' ||
        cat == 'seafood' ||
        cat == 'pasta' ||
        nm.contains('fish') ||
        nm.contains('prawn') ||
        nm.contains('shrimp') ||
        nm.contains('soup') ||
        nm.contains('halwa') ||
        nm.contains('kheer') ||
        nm.contains('gulab jamun') ||
        nm.contains('bhindi') ||
        nm.contains('paneer') ||
        nm.contains('daal') ||
        nm.contains('fry') ||
        nm.contains('stir fry') ||
        nm.contains('seekh') ||
        nm.contains('boti') ||
        nm.contains('tikka') ||
        nm.contains('chapli') ||
        nm.contains('burger') ||
        nm.contains('samosa') ||
        nm.contains('roll') ||
        nm.contains('paratha')) {
      return 25;
    }

    // 40 Mins: Chicken curries, Karahi, Handi, Qorma, Rice, Pulao
    if (cat == 'chicken' ||
        nm.contains('chicken') ||
        nm.contains('karahi') ||
        nm.contains('handi') ||
        nm.contains('korma') ||
        nm.contains('pulao') ||
        nm.contains('rice') ||
        nm.contains('biryani') ||
        nm.contains('curry') ||
        nm.contains('saag') ||
        nm.contains('kofta')) {
      return 40;
    }

    // 55 Mins: Beef, Lamb, Nihari, Haleem, Paye, Kunna, Slow cooked roasts
    if (cat == 'beef' ||
        cat == 'lamb' ||
        cat == 'goat' ||
        nm.contains('beef') ||
        nm.contains('mutton') ||
        nm.contains('nihari') ||
        nm.contains('haleem') ||
        nm.contains('paye') ||
        nm.contains('kunna') ||
        nm.contains('roast') ||
        nm.contains('chargha') ||
        nm.contains('sajji') ||
        nm.contains('dum pukht') ||
        nm.contains('raan')) {
      return 55;
    }

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
