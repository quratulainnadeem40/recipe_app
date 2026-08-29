class RecipeModel {
  final String id;
  final String name;
  final String image;
  final String category;
  final String area;
  final String shortInfo;
  final int? prepTime;
  final String? difficultyOverride;

  const RecipeModel({
    required this.id,
    required this.name,
    required this.image,
    this.category = '',
    this.area = '',
    this.shortInfo = '',
    this.prepTime,
    this.difficultyOverride,
  });

  factory RecipeModel.fromJson(
    Map<String, dynamic> json, {
    String fallbackCategory = '',
    String fallbackArea = '',
  }) {
    final rawPrep = (json['prepTime'] ?? '').toString();
    final parsedPrep = int.tryParse(RegExp(r'\d+').firstMatch(rawPrep)?.group(0) ?? '');
    final rawDiff = (json['difficulty'] ?? json['strDifficulty'] ?? '').toString().trim();

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
      prepTime: parsedPrep,
      difficultyOverride: rawDiff.isNotEmpty ? rawDiff : null,
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
    String? difficultyOverride,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      category: category ?? this.category,
      area: area ?? this.area,
      shortInfo: shortInfo ?? this.shortInfo,
      prepTime: prepTime ?? this.prepTime,
      difficultyOverride: difficultyOverride ?? this.difficultyOverride,
    );
  }

  // ============================================================
  // FILTERING HELPERS
  // ============================================================

  String get difficulty {
    if (difficultyOverride != null && difficultyOverride!.trim().isNotEmpty) {
      final d = difficultyOverride!.trim().toLowerCase();
      if (d == 'easy') return 'Easy';
      if (d == 'medium') return 'Medium';
      if (d == 'hard') return 'Hard';
    }
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
        nm.contains('dal') ||
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
      'mutton',
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
      'mussel',
      'squid',
      'crab',
      'lobster',
      'keema',
      'kheema',
      'seekh',
      'boti',
      'tikka',
      'karahi',
      'nihari',
      'paye',
      'haleem',
      'kunna',
      'chargha',
      'sajji',
      'dum pukht',
      'kofta',
    ];

    for (final word in nonVegWords) {
      if (cat.contains(word) || nm.contains(word)) return false;
    }

    return cat.contains('dessert') ||
        cat.contains('pasta') ||
        cat.contains('side') ||
        cat.contains('starter') ||
        cat.contains('breakfast') ||
        nm.contains('salad') ||
        nm.contains('soup') ||
        nm.contains('veg') ||
        nm.contains('cheese') ||
        nm.contains('paneer') ||
        nm.contains('potato') ||
        nm.contains('aloo') ||
        nm.contains('gobi') ||
        nm.contains('bhindi') ||
        nm.contains('palak') ||
        nm.contains('daal') ||
        nm.contains('dal') ||
        nm.contains('chana') ||
        nm.contains('chickpea') ||
        nm.contains('lentil') ||
        nm.contains('egg') ||
        nm.contains('bread') ||
        nm.contains('roti') ||
        nm.contains('naan') ||
        nm.contains('paratha') ||
        nm.contains('halwa') ||
        nm.contains('kheer') ||
        nm.contains('gulab jamun') ||
        nm.contains('cake') ||
        nm.contains('pie') ||
        nm.contains('cookie') ||
        nm.contains('pasta') ||
        nm.contains('rice') ||
        nm.contains('pulao') ||
        nm.contains('tofu') ||
        nm.contains('mushroom') ||
        nm.contains('spinach') ||
        nm.contains('bean') ||
        nm.contains('sabzi');
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
      'mutton',
      'goat',
      'fish',
      'salmon',
      'tuna',
      'shrimp',
      'prawn',
      'meat',
      'keema',
      'kheema',
      'bacon',
      'turkey',
      'duck',
      'clam',
      'mussel',
      'squid',
      'crab',
      'lobster',
      'seekh',
      'boti',
      'tikka',
      'karahi',
      'nihari',
      'paye',
      'haleem',
      'kunna',
      'chargha',
      'sajji',
      'kofta',
      'egg',
      'omelette',
      'cheese',
      'paneer',
      'butter',
      'ghee',
      'milk',
      'cream',
      'malai',
      'yogurt',
      'dahi',
      'raita',
      'kheer',
      'custard',
      'honey',
      'whey',
    ];

    for (final word in nonVeganWords) {
      if (cat.contains(word) || nm.contains(word)) return false;
    }

    return nm.contains('vegan') ||
        nm.contains('tofu') ||
        nm.contains('plant') ||
        nm.contains('avocado') ||
        nm.contains('hummus') ||
        nm.contains('spinach') ||
        nm.contains('lentil') ||
        nm.contains('daal') ||
        nm.contains('dal') ||
        nm.contains('chana') ||
        nm.contains('aloo') ||
        nm.contains('gobi') ||
        nm.contains('bhindi') ||
        nm.contains('sabzi') ||
        nm.contains('salad') ||
        nm.contains('mushroom') ||
        nm.contains('corn') ||
        nm.contains('bean') ||
        nm.contains('rice') ||
        nm.contains('fruit') ||
        nm.contains('smoothie') ||
        nm.contains('roti') ||
        nm.contains('chapati') ||
        cat == 'side' ||
        cat == 'starter';
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
      'deep fry',
      'deep-fried',
      'sugar',
      'pork',
      'tart',
      'pastry',
      'halwa',
      'gulab jamun',
      'jalebi',
      'rasmalai',
      'samosa',
      'pakora',
      'puri',
      'paratha',
      'nihari',
      'paye',
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
        nm.contains('salmon') ||
        nm.contains('boiled') ||
        nm.contains('steam') ||
        nm.contains('steamed') ||
        nm.contains('daal') ||
        nm.contains('dal') ||
        nm.contains('tikka') ||
        nm.contains('oats') ||
        nm.contains('fruit') ||
        nm.contains('juice') ||
        nm.contains('shake') ||
        nm.contains('green') ||
        nm.contains('herb') ||
        nm.contains('olive') ||
        nm.contains('avocado') ||
        nm.contains('spinach') ||
        nm.contains('broccoli') ||
        nm.contains('quinoa') ||
        nm.contains('egg') ||
        nm.contains('paneer') ||
        nm.contains('tofu');
  }
}
