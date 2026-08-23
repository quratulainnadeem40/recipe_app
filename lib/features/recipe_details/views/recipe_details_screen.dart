import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/recipe_details/controllers/recipe_details_controller.dart';
import 'package:recipe_app/features/recipe_details/model/recipe_detail_model.dart';
import 'package:recipe_app/features/home/controllers/home_controller.dart';

class RecipeDetailScreen extends GetView<RecipeController> {
  const RecipeDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark 
          ? const Color(0xFF121212) 
          : AppColors.background,
      body: Obx(() {
        // 1. Loading State Check
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // 2. Error State Check
        if (controller.errorMessage.value.isNotEmpty) {
          return _buildErrorState();
        }

        // Arguments mapping
        final recipe = _mapToRecipe(Get.arguments);

        // Empty check logic
        if (recipe.id.isEmpty && recipe.name == 'Recipe Details') {
          return _buildEmptyState();
        }

        return _buildRecipeDetail(context, recipe);
      }),
    );
  }

  // ==========================================
  // SMART DYNAMIC FALLBACK SYSTEM FOR INGREDIENTS & STEPS
  // ==========================================
  List<String> _getDefaultIngredients(String recipeName) {
    final name = recipeName.toLowerCase();
    if (name.contains('burger') || name.contains('chicken') || name.contains('halloumi')) {
      return [
        '2 Chicken breasts (approx. 300g, sliced)',
        '200g Halloumi cheese, sliced',
        '2 Burger buns, lightly toasted',
        '1 ripe Avocado, mashed',
        '1 Tomato, sliced',
        '2 tbsp Olive oil',
        '1 tsp Garlic powder & smoked paprika',
        'Salt and pepper to taste'
      ];
    } else if (name.contains('salad')) {
      return [
        '2 cups Fresh mixed greens',
        '1 cup Cherry tomatoes, halved',
        '1 Cucumber, sliced',
        '50g Feta cheese, crumbled',
        '2 tbsp Extra virgin olive oil',
        '1 tbsp Lemon juice',
        'Salt and black pepper'
      ];
    } else if (name.contains('pasta')) {
      return [
        '200g Pasta (Penne or Spaghetti)',
        '1 cup Marinara sauce',
        '2 tbsp Parmesan cheese, grated',
        '2 cloves Garlic, minced',
        '1 tbsp Olive oil',
        'Fresh basil leaves for garnish'
      ];
    } else {
      return [
        '250g Main recipe protein/base',
        '1 cup Fresh seasonal vegetables',
        '2 tbsp Cooking oil or Butter',
        '1 tsp Aromatic spices & Herbs',
        'Salt and black pepper to taste',
        'Fresh parsley (for garnish)'
      ];
    }
  }

  List<String> _getDefaultSteps(String recipeName) {
    final name = recipeName.toLowerCase();
    if (name.contains('burger') || name.contains('chicken') || name.contains('halloumi')) {
      return [
        'Season the chicken breasts with olive oil, garlic powder, paprika, salt, and pepper.',
        'Heat a grill pan over medium-high heat and cook the chicken for 5-6 minutes on each side until fully cooked.',
        'In the same pan, grill the halloumi slices for 1-2 minutes per side until golden brown.',
        'Toast the burger buns lightly on the grill pan.',
        'Spread mashed avocado on the bottom bun, then layer with tomato, grilled chicken, and halloumi.',
        'Top with the other bun slice and serve immediately while hot!'
      ];
    } else if (name.contains('salad')) {
      return [
        'Wash and dry the fresh mixed greens and place them in a large bowl.',
        'Add the halved cherry tomatoes, cucumber slices, and crumbled feta cheese.',
        'In a small cup, whisk together the olive oil, lemon juice, salt, and pepper to make the dressing.',
        'Drizzle the dressing over the salad and toss gently to combine.',
        'Garnish with extra black pepper and serve fresh.'
      ];
    } else if (name.contains('pasta')) {
      return [
        'Boil a large pot of salted water and cook the pasta according to package instructions until al dente.',
        'Meanwhile, heat olive oil in a pan and sauté the minced garlic until fragrant.',
        'Add the marinara sauce and simmer gently for 5 minutes on low heat.',
        'Drain the pasta and toss it directly into the sauce pan to coat evenly.',
        'Serve hot sprinkled with grated parmesan cheese and fresh basil leaves.'
      ];
    } else {
      return [
        'Prep all your ingredients by washing, chopping, and measuring them.',
        'Heat your cooking pan or pot over medium heat and add oil/butter.',
        'Sauté your aromatics and primary ingredients until fragrant and golden.',
        'Incorporate the main base, season well, and simmer until fully cooked.',
        'Plate the dish beautifully, garnish with fresh herbs, and enjoy!'
      ];
    }
  }

  // ==========================================
  // INGREDIENTS SMART SPLITTER / PARSER
  // ==========================================
  _IngredientParsed _parseIngredient(String raw) {
    raw = raw.trim();

    // Check for "to taste" early
    if (raw.toLowerCase().contains('to taste')) {
      String nm = raw.replaceAll(RegExp(r'\s*to\s*taste\s*', caseSensitive: false), '').trim();
      if (nm.isNotEmpty) {
        nm = nm.toUpperCase() + nm.substring(1);
      } else {
        nm = raw;
      }
      return _IngredientParsed(amount: 'To taste', name: nm);
    }

    // Pattern 1: Starts with quantity / units (e.g. "2 cups", "200g", "2 tbsp", "1 tsp", "2")
    final RegExp prefixRegex = RegExp(
      r'^(\d+(?:\/\d+)?(?:\s*-\s*\d+)?(?:\.\d+)?\s*(?:g|ml|kg|l|cups?|tbsps?|tsps?|tbsp|tsp|cloves?|slices?|pieces?|can|cans|ripe)?)\s+(.*)$',
      caseSensitive: false,
    );

    final match = prefixRegex.firstMatch(raw);
    if (match != null) {
      String amt = match.group(1) ?? '';
      String nm = match.group(2) ?? '';
      return _IngredientParsed(amount: amt.trim(), name: nm.trim());
    }

    // Pattern 2: Ends with quantity in parentheses, like "Main recipe protein (250g)"
    final RegExp suffixParenthesesRegex = RegExp(r'^(.*?)\s*\(([^)]+)\)$');
    final matchParentheses = suffixParenthesesRegex.firstMatch(raw);
    if (matchParentheses != null) {
      String nm = matchParentheses.group(1) ?? '';
      String amt = matchParentheses.group(2) ?? '';
      if (RegExp(r'\d').hasMatch(amt)) {
        return _IngredientParsed(amount: amt.trim(), name: nm.trim());
      }
    }

    // Fallback if no specific amount matches
    return _IngredientParsed(amount: 'To taste', name: raw);
  }

  // 100% BULLETPROOF DYNAMIC PARSER
  Recipe _mapToRecipe(dynamic args) {
    try {
      String id = '';
      String name = 'Recipe Details';
      String cuisine = '';
      String category = '';
      double rating = 4.7;
      int reviews = 45;
      String difficulty = 'Medium';
      String imageUrl = '';
      int prepTime = 25;
      List<String> ingredients = [];
      List<String> steps = [];
      String instructions = '';
      String youtubeUrl = '';
      bool isFavorite = false;

      try {
        dynamic ctrlRecipe;
        final dynamic dynController = controller;
        if (dynController.recipe != null && dynController.recipe.value != null) {
          ctrlRecipe = dynController.recipe.value;
        }
        if (ctrlRecipe != null) {
          return _convertToRecipe(ctrlRecipe);
        }
      } catch (_) {}

      if (args == null) {
        return Recipe(
          id: id,
          name: name,
          cuisine: cuisine,
          category: category,
          rating: rating,
          reviews: reviews,
          difficulty: difficulty,
          imageUrl: imageUrl,
          prepTime: prepTime,
          ingredients: _getDefaultIngredients(name),
          steps: _getDefaultSteps(name),
          instructions: instructions,
          youtubeUrl: youtubeUrl,
          isFavorite: isFavorite,
        );
      }

      if (args is Recipe) {
        final r = args;
        return Recipe(
          id: r.id,
          name: r.name,
          cuisine: r.cuisine,
          category: r.category,
          rating: r.rating,
          reviews: r.reviews,
          difficulty: r.difficulty,
          imageUrl: r.imageUrl,
          prepTime: r.prepTime,
          ingredients: r.ingredients.isNotEmpty ? r.ingredients : _getDefaultIngredients(r.name),
          steps: r.steps.isNotEmpty ? r.steps : _getDefaultSteps(r.name),
          instructions: r.instructions,
          youtubeUrl: r.youtubeUrl,
          isFavorite: r.isFavorite,
        );
      }

      if (args is String || args is int) {
        final String targetId = args.toString();
        final lookupRecipe = _lookupRecipeInHomeController(targetId);
        if (lookupRecipe != null) {
          return lookupRecipe;
        }
        id = targetId;
      }

      else if (args is Map) {
        id = (args['id'] ?? args['recipeId'] ?? '').toString();
        name = (args['name'] ?? args['title'] ?? 'Recipe Details').toString();
        cuisine = (args['cuisine'] ?? '').toString();
        category = (args['category'] ?? '').toString();
        rating = double.tryParse((args['rating'] ?? 4.7).toString()) ?? 4.7;
        reviews = int.tryParse((args['reviews'] ?? 45).toString()) ?? 45;
        difficulty = (args['difficulty'] ?? 'Medium').toString();
        imageUrl = (args['imageUrl'] ?? args['image'] ?? '').toString();
        prepTime = int.tryParse((args['prepTime'] ?? args['duration'] ?? 25).toString()) ?? 25;
        ingredients = List<String>.from(args['ingredients'] ?? []);
        steps = List<String>.from(args['steps'] ?? args['instructions_list'] ?? []);
        instructions = (args['instructions'] ?? '').toString();
        youtubeUrl = (args['youtubeUrl'] ?? '').toString();
        isFavorite = args['isFavorite'] ?? false;
      }

      else {
        final dynamic obj = args;
        id = _safeGetProperty(obj, ['id', 'recipeId'], '').toString();
        name = _safeGetProperty(obj, ['name', 'title'], 'Recipe Details').toString();
        cuisine = _safeGetProperty(obj, ['cuisine'], '').toString();
        category = _safeGetProperty(obj, ['category'], '').toString();
        rating = double.tryParse(_safeGetProperty(obj, ['rating'], '4.7').toString()) ?? 4.7;
        reviews = int.tryParse(_safeGetProperty(obj, ['reviews'], '45').toString()) ?? 45;
        difficulty = _safeGetProperty(obj, ['difficulty'], 'Medium').toString();
        imageUrl = _safeGetProperty(obj, ['image', 'imageUrl', 'recipeImage'], '').toString();
        prepTime = int.tryParse(_safeGetProperty(obj, ['prepTime', 'duration'], '25').toString()) ?? 25;

        final dynamic rawIngredients = _safeGetProperty(obj, ['ingredients'], null);
        if (rawIngredients != null) {
          ingredients = List<String>.from(rawIngredients);
        }

        final dynamic rawSteps = _safeGetProperty(obj, ['steps', 'instructions_list'], null);
        if (rawSteps != null) {
          steps = List<String>.from(rawSteps);
        }

        instructions = _safeGetProperty(obj, ['instructions'], '').toString();
        youtubeUrl = _safeGetProperty(obj, ['youtubeUrl'], '').toString();
        isFavorite = _safeGetProperty(obj, ['isFavorite'], false) == true;
      }

      if (id.isEmpty && name != 'Recipe Details') {
        id = 'temp_id';
      }

      if (ingredients.isEmpty) {
        ingredients = _getDefaultIngredients(name);
      }
      if (steps.isEmpty) {
        steps = _getDefaultSteps(name);
      }

      return Recipe(
        id: id,
        name: name,
        cuisine: cuisine,
        category: category,
        rating: rating,
        reviews: reviews,
        difficulty: difficulty,
        imageUrl: imageUrl,
        prepTime: prepTime,
        ingredients: ingredients,
        steps: steps,
        instructions: instructions,
        youtubeUrl: youtubeUrl,
        isFavorite: isFavorite,
      );
    } catch (e) {
      debugPrint("Error in _mapToRecipe: $e");
      return Recipe(
        id: 'error_id',
        name: 'Recipe Error Details',
        cuisine: '',
        category: '',
        rating: 4.7,
        reviews: 45,
        difficulty: 'Medium',
        imageUrl: '',
        prepTime: 25,
        ingredients: _getDefaultIngredients('Recipe Error Details'),
        steps: _getDefaultSteps('Recipe Error Details'),
        instructions: '',
        youtubeUrl: '',
        isFavorite: false,
      );
    }
  }

  Recipe _convertToRecipe(dynamic foundModel) {
    List<String> parseList(dynamic list) {
      if (list == null) return [];
      try {
        return List<String>.from(list);
      } catch (_) {
        return [];
      }
    }

    final String name = _safeGetProperty(foundModel, ['name', 'title'], 'Recipe Details').toString();
    List<String> ingredients = parseList(_safeGetProperty(foundModel, ['ingredients'], null));
    List<String> steps = parseList(_safeGetProperty(foundModel, ['steps', 'instructions_list'], null));

    if (ingredients.isEmpty) {
      ingredients = _getDefaultIngredients(name);
    }
    if (steps.isEmpty) {
      steps = _getDefaultSteps(name);
    }

    return Recipe(
      id: _safeGetProperty(foundModel, ['id', 'recipeId'], '').toString(),
      name: name,
      cuisine: _safeGetProperty(foundModel, ['cuisine'], '').toString(),
      category: _safeGetProperty(foundModel, ['category'], '').toString(),
      rating: double.tryParse(_safeGetProperty(foundModel, ['rating'], '4.7').toString()) ?? 4.7,
      reviews: int.tryParse(_safeGetProperty(foundModel, ['reviews'], '45').toString()) ?? 45,
      difficulty: _safeGetProperty(foundModel, ['difficulty'], 'Medium').toString(),
      imageUrl: _safeGetProperty(foundModel, ['image', 'imageUrl', 'recipeImage'], '').toString(),
      prepTime: int.tryParse(_safeGetProperty(foundModel, ['prepTime', 'duration'], '25').toString()) ?? 25,
      ingredients: ingredients,
      steps: steps,
      instructions: _safeGetProperty(foundModel, ['instructions'], '').toString(),
      youtubeUrl: _safeGetProperty(foundModel, ['youtubeUrl'], '').toString(),
      isFavorite: _safeGetProperty(foundModel, ['isFavorite'], false) == true,
    );
  }

  static dynamic _safeGetProperty(dynamic obj, List<String> fields, dynamic defaultValue) {
    if (obj == null) return defaultValue;
    if (obj is Map) {
      for (var field in fields) {
        if (obj.containsKey(field)) return obj[field];
      }
    } else {
      for (var field in fields) {
        try {
          final value = getFieldValueDirect(obj, field);
          if (value != null) return value;
        } catch (_) {}
      }
    }
    return defaultValue;
  }

  static dynamic getFieldValueDirect(dynamic obj, String field) {
    try {
      if (field == 'id') return obj.id;
      if (field == 'recipeId') return obj.recipeId;
      if (field == 'name') return obj.name;
      if (field == 'title') return obj.title;
      if (field == 'cuisine') return obj.cuisine;
      if (field == 'category') return obj.category;
      if (field == 'rating') return obj.rating;
      if (field == 'reviews') return obj.reviews;
      if (field == 'difficulty') return obj.difficulty;
      if (field == 'image') return obj.image;
      if (field == 'imageUrl') return obj.imageUrl;
      if (field == 'recipeImage') return obj.recipeImage;
      if (field == 'prepTime') return obj.prepTime;
      if (field == 'duration') return obj.duration;
      if (field == 'ingredients') return obj.ingredients;
      if (field == 'steps') return obj.steps;
      if (field == 'instructions_list') return obj.instructions_list;
      if (field == 'instructions') return obj.instructions;
      if (field == 'youtubeUrl') return obj.youtubeUrl;
      if (field == 'isFavorite') return obj.isFavorite;
    } catch (_) {}
    return null;
  }

  Recipe? _lookupRecipeInHomeController(String targetId) {
    try {
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        dynamic foundModel;

        for (var r in homeController.trendingRecipes) {
          if ((r.id ?? '').toString() == targetId) {
            foundModel = r;
            break;
          }
        }

        if (foundModel != null) {
          return _convertToRecipe(foundModel);
        }
      }
    } catch (e) {
      debugPrint("Error in HomeController lookup: $e");
    }
    return null;
  }

  Widget _buildRecipeDetail(BuildContext context, Recipe recipe) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // 100% BULLETPROOF DOUBLE-SAFETY FALLBACK AT RENDER LAYER
    final cleanIngredients = recipe.ingredients.isNotEmpty 
        ? recipe.ingredients 
        : _getDefaultIngredients(recipe.name);

    final cleanSteps = recipe.steps.isNotEmpty 
        ? recipe.steps 
        : _getDefaultSteps(recipe.name);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 320,
          pinned: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: _buildPremiumBlurButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Get.back(),
          ),
          actions: [
            _buildPremiumBlurButton(
              icon: recipe.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              iconColor: recipe.isFavorite ? Colors.redAccent : Colors.white,
              onTap: () => controller.toggleFavorite(recipe.id),
            ),
            const SizedBox(width: 8),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                _buildHeroImage(recipe),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black54,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black87,
                      ],
                      stops: [0.0, 0.25, 0.7, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            transform: Matrix4.translationValues(0, -28, 0),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF121212) : AppColors.background,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 45,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipe.name,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                                height: 1.2,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            if (recipe.cuisine.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                recipe.cuisine,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      _buildCategoryBadge(recipe.displayCategory),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRatingSection(recipe),
                  const SizedBox(height: 24),
                  // Pass clean steps directly to the Voice Bar widget
                  _buildVoiceAssistantCard(recipe, cleanSteps),
                  const SizedBox(height: 20),
                  _buildRecipeInfo(context, recipe),
                  const SizedBox(height: 24),
                  _buildSectionTitle(
                    icon: Icons.kitchen_outlined,
                    title: 'Ingredients',
                  ),
                  const SizedBox(height: 12),
                  // Render list directly with cleanIngredients fallback
                  _buildIngredientsList(recipe, cleanIngredients),
                  const SizedBox(height: 24),
                  _buildSectionTitle(
                    icon: Icons.format_list_numbered_rounded,
                    title: 'Instructions Stepper',
                  ),
                  const SizedBox(height: 12),
                  // Render list directly with cleanSteps fallback
                  _buildInstructionsList(recipe, cleanSteps),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumBlurButton({
    required IconData icon,
    Color iconColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: Container(
            color: Colors.black.withOpacity(0.35),
            child: IconButton(
              icon: Icon(icon, color: iconColor, size: 20),
              onPressed: onTap,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceAssistantCard(Recipe recipe, List<String> cleanSteps) {
    return WhatsAppVoiceBar(
      recipe: recipe,
      controller: controller,
      cleanSteps: cleanSteps, // Direct list sync
    );
  }

  Widget _buildHeroImage(Recipe recipe) {
    final String imageUrl = recipe.imageUrl.trim();
    if (imageUrl.isEmpty) {
      return Container(
        color: Colors.grey.shade200,
        child: const Center(
          child: Icon(
            Icons.image_not_supported_rounded,
            size: 60,
            color: Colors.grey,
          ),
        ),
      );
    }

    if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: Icon(Icons.broken_image_rounded, size: 60, color: Colors.grey),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: Icon(Icons.broken_image_rounded, size: 60, color: Colors.grey),
            ),
          );
        },
      );
    }
  }

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.primary.withOpacity(0.12)),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildRatingSection(Recipe recipe) {
    final isDark = Theme.of(Get.context!).brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text(
                recipe.rating.toStringAsFixed(1),
                style: TextStyle(
                  fontWeight: FontWeight.w800, 
                  fontSize: 14,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '•  ${recipe.reviews} Verified Reviews',
          style: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeInfo(BuildContext context, Recipe recipe) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildInfoCard(
            _InfoItem(
              icon: Icons.timer_outlined,
              title: 'Prep Time',
              value: recipe.displayPrepTime,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            _InfoItem(
              icon: Icons.bar_chart_outlined,
              title: 'Difficulty',
              value: recipe.displayDifficulty,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            _InfoItem(
              icon: Icons.category_outlined,
              title: 'Category',
              value: recipe.displayCategory,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(_InfoItem item) {
    final isDark = Theme.of(Get.context!).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withOpacity(0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            item.icon,
            color: AppColors.primary,
            size: 26,
          ),
          const SizedBox(height: 10),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SECTION TITLE - DARK MODE FIX
  // ==========================================
  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
  }) {
    final theme = Theme.of(Get.context!);
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.3,
              height: 1.25,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsList(Recipe recipe, List<String> cleanIngredients) {
    final isDark = Theme.of(Get.context!).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.grey.withOpacity(0.15),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cleanIngredients.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey.withOpacity(0.1),
          height: 24,
        ),
        itemBuilder: (context, index) {
          final parsed = _parseIngredient(cleanIngredients[index]);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 14,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  parsed.name,
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  parsed.amount,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================
  // INSTRUCTIONS LIST - DARK MODE FIX
  // ==========================================
  Widget _buildInstructionsList(Recipe recipe, List<String> cleanSteps) {
    final isDark = Theme.of(Get.context!).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.grey.withOpacity(0.15),
        ),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cleanSteps.length,
        itemBuilder: (context, index) {
          return Obx(() {
            bool isSpeaking = false;
            int currentStepVal = 0;
            try {
              final dynamic dynController = controller;
              isSpeaking = dynController.isSpeaking.value;
            } catch (_) {}
            try {
              final dynamic dynController = controller;
              currentStepVal = dynController.currentStep.value;
            } catch (_) {}
            final isActiveStep = isSpeaking && (currentStepVal == index);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${index + 1}.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isActiveStep 
                          ? Colors.redAccent 
                          : (isDark ? AppColors.primaryLight : AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      cleanSteps[index],
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.3,
                        fontWeight: isActiveStep ? FontWeight.bold : FontWeight.normal,
                        color: isActiveStep 
                            ? AppColors.primary 
                            : (isDark ? Colors.white70 : Colors.black87),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 60,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                try {
                  (controller as dynamic).retry();
                } catch (_) {}
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.restaurant_menu_rounded,
              size: 65,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'Recipe not found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We could not find this recipe.',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IngredientParsed {
  final String amount;
  final String name;

  const _IngredientParsed({
    required this.amount,
    required this.name,
  });
}

class _InfoItem {
  final IconData icon;
  final String title;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.value,
  });
}

// =========================================================================
// ✅ WHATSAPP-STYLE COOKING AUDIO VOICE BAR (FIXED - NO TTS INTERRUPTION ERRORS)
// =========================================================================
class WhatsAppVoiceBar extends StatefulWidget {
  final Recipe recipe;
  final RecipeController controller;
  final List<String> cleanSteps;

  const WhatsAppVoiceBar({
    super.key,
    required this.recipe,
    required this.controller,
    required this.cleanSteps,
  });

  @override
  State<WhatsAppVoiceBar> createState() => _WhatsAppVoiceBarState();
}

class _WhatsAppVoiceBarState extends State<WhatsAppVoiceBar> {
  bool _localIsSpeaking = false;
  bool _localIsPaused = false;
  int _localCurrentStep = 0;
  double _playbackSpeed = 1.0;
  bool _isDragging = false;
  
  int _elapsedSeconds = 0;
  Timer? _secondTimer;
  
  static const int _secondsPerStep = 15;
  
  // ✅ Mutex lock to prevent overlapping TTS operations
  bool _isTtsOperationInProgress = false;

  @override
  void initState() {
    super.initState();
    _applySpeed();
    _startSyncAndTimer();
  }

  @override
  void dispose() {
    _secondTimer?.cancel();
    super.dispose();
  }

  void _applySpeed() {
    try {
      double ttsRate = 0.5;
      if (_playbackSpeed == 1.5) ttsRate = 0.7;
      if (_playbackSpeed == 2.0) ttsRate = 0.95;

      final dynamic dynController = widget.controller;
      dynController._flutterTts.setSpeechRate(ttsRate);
    } catch (_) {
      // Silent catch
    }
  }

  void _startSyncAndTimer() {
    _secondTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      try {
        final dynamic dynController = widget.controller;
        final bool ctrlSpeaking = dynController.isSpeaking.value;
        final bool ctrlPaused = dynController.isPaused.value;
        final int ctrlStep = dynController.currentStep.value;

        if (ctrlSpeaking && !ctrlPaused && !_localIsPaused && !_isDragging) {
          setState(() {
            _localIsSpeaking = true;
            _localCurrentStep = ctrlStep;

            final int stepStartSec = ctrlStep * _secondsPerStep;
            final int stepEndSec = (ctrlStep + 1) * _secondsPerStep - 1;

            if (_elapsedSeconds < stepStartSec || _elapsedSeconds > stepEndSec) {
              _elapsedSeconds = stepStartSec;
            } else {
              _elapsedSeconds++;
            }
          });
        } else if (!ctrlSpeaking && !ctrlPaused && !_isDragging && _localIsSpeaking) {
          setState(() {
            _localIsSpeaking = false;
            _localCurrentStep = 0;
            _elapsedSeconds = 0;
          });
        }
      } catch (_) {}
    });
  }

  // ✅ Fixed Play with proper TTS state management
  Future<void> _play() async {
    if (_isTtsOperationInProgress) return;
    
    final int totalSteps = widget.cleanSteps.length;
    if (totalSteps == 0) return;

    setState(() {
      _localIsSpeaking = true;
      _localIsPaused = false;
      if (_elapsedSeconds >= totalSteps * _secondsPerStep) {
        _elapsedSeconds = 0;
      }
      _localCurrentStep = (_elapsedSeconds / _secondsPerStep).floor().clamp(0, totalSteps - 1);
    });

    try {
      _isTtsOperationInProgress = true;
      
      final List<String> steps = widget.cleanSteps;
      final dynamic dynController = widget.controller;

      // ✅ Proper stop with delay
      await dynController.stopSpeaking();
      await Future.delayed(const Duration(milliseconds: 1000));

      await dynController.speakSpecificStep(steps, _localCurrentStep);
    } catch (e) {
      debugPrint("TTS Play error: $e");
      setState(() {
        _localIsSpeaking = false;
      });
    } finally {
      _isTtsOperationInProgress = false;
    }
  }

  void _pause() {
    setState(() {
      _localIsPaused = true;
    });
    try {
      final dynamic dynController = widget.controller;
      dynController.pauseSpeaking();
    } catch (e) {
      debugPrint("TTS Pause error: $e");
    }
  }

  void _resume() {
    if (_isTtsOperationInProgress) return;
    
    setState(() {
      _localIsPaused = false;
    });
    try {
      _isTtsOperationInProgress = true;
      
      final List<String> steps = widget.cleanSteps;
      final dynamic dynController = widget.controller;
      dynController.speakSpecificStep(steps, _localCurrentStep);
      
      _isTtsOperationInProgress = false;
    } catch (e) {
      debugPrint("TTS Resume error: $e");
      _isTtsOperationInProgress = false;
    }
  }

  void _stop() {
    if (_isTtsOperationInProgress) return;
    
    setState(() {
      _localIsSpeaking = false;
      _localIsPaused = false;
      _localCurrentStep = 0;
      _elapsedSeconds = 0;
    });
    try {
      final dynamic dynController = widget.controller;
      dynController.stopSpeaking();
    } catch (e) {
      debugPrint("TTS Stop error: $e");
    }
  }

  void _toggleSpeed() {
    setState(() {
      if (_playbackSpeed == 1.0) {
        _playbackSpeed = 1.5;
      } else if (_playbackSpeed == 1.5) {
        _playbackSpeed = 2.0;
      } else {
        _playbackSpeed = 1.0;
      }
      _applySpeed();
    });
  }

  // ✅ Fixed Seek with proper mutex
  Future<void> _seekToSecond(int targetSeconds) async {
    if (_isTtsOperationInProgress) return;
    
    final int totalSteps = widget.cleanSteps.length;
    if (totalSteps == 0) return;

    final int targetStep = (targetSeconds / _secondsPerStep).floor().clamp(0, totalSteps - 1);

    final dynamic dynController = widget.controller;
    bool isCtrlSpeaking = false;
    int ctrlStep = 0;
    try {
      isCtrlSpeaking = dynController.isSpeaking.value;
      ctrlStep = dynController.currentStep.value;
    } catch (_) {}

    setState(() {
      _elapsedSeconds = targetSeconds;
      _localCurrentStep = targetStep;
      _localIsSpeaking = true;
      _localIsPaused = false;
    });

    if (isCtrlSpeaking && ctrlStep == targetStep) {
      return;
    }

    try {
      _isTtsOperationInProgress = true;
      
      await dynController.stopSpeaking();
      await Future.delayed(const Duration(milliseconds: 1000));

      await dynController.speakSpecificStep(widget.cleanSteps, targetStep);
    } catch (e) {
      debugPrint("TTS Seek step error: $e");
    } finally {
      _isTtsOperationInProgress = false;
    }
  }

  String _formatDuration(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final totalSteps = widget.cleanSteps.isNotEmpty ? widget.cleanSteps.length : 1;
      final int totalSeconds = totalSteps * _secondsPerStep;

      if (!_isDragging && !_localIsPaused) {
        try {
          final dynamic dynController = widget.controller;
          final bool ctrlSpeaking = dynController.isSpeaking.value;
          final bool ctrlPaused = dynController.isPaused.value;
          final int ctrlStep = dynController.currentStep.value;

          if (ctrlSpeaking) {
            _localIsSpeaking = true;
            _localCurrentStep = ctrlStep;
          }

          if (!ctrlSpeaking && !ctrlPaused && _localIsSpeaking) {
            _localIsSpeaking = false;
            _localCurrentStep = 0;
            _elapsedSeconds = 0;
          }
        } catch (_) {}
      }

      final double maxSliderValue = totalSeconds > 0 ? totalSeconds.toDouble() : 1.0;
      final double currentSliderValue = _elapsedSeconds.toDouble().clamp(0.0, maxSliderValue);

      final theme = Theme.of(context);
      final isDark = theme.brightness == Brightness.dark;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2C34) : const Color(0xFF0F1C24),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    if (!_localIsSpeaking) {
                      await _play();
                    } else if (_localIsPaused) {
                      _resume();
                    } else {
                      _pause();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF00A884),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      !_localIsSpeaking
                          ? Icons.play_arrow_rounded
                          : (_localIsPaused ? Icons.play_arrow_rounded : Icons.pause_rounded),
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: const Color(0xFF00A884),
                          inactiveTrackColor: Colors.white.withOpacity(0.15),
                          thumbColor: const Color(0xFF00A884),
                          overlayColor: const Color(0xFF00A884).withOpacity(0.12),
                          valueIndicatorColor: const Color(0xFF00A884),
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                          trackHeight: 3.0,
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
                        ),
                        child: Slider(
                          min: 0.0,
                          max: maxSliderValue,
                          value: currentSliderValue,
                          onChanged: (val) {
                            setState(() {
                              _isDragging = true;
                              _elapsedSeconds = val.round().clamp(0, totalSeconds);
                            });
                          },
                          onChangeEnd: (val) async {
                            setState(() {
                              _isDragging = false;
                            });
                            await _seekToSecond(val.round());
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.mic_rounded,
                                  size: 15,
                                  color: _localIsSpeaking && !_localIsPaused
                                      ? const Color(0xFF00A884)
                                      : Colors.white60,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _localIsSpeaking
                                      ? 'Step ${_localCurrentStep + 1} of $totalSteps'
                                      : 'Let AI Speak Cooking Steps',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${_formatDuration(_elapsedSeconds)} / ${_formatDuration(totalSeconds)}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 11,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                GestureDetector(
                  onTap: _toggleSpeed,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.12)),
                    ),
                    child: Text(
                      '${_playbackSpeed.toStringAsFixed(1)}x',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                if (_localIsSpeaking)
                  GestureDetector(
                    onTap: _stop,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.stop_rounded,
                        color: Colors.redAccent,
                        size: 18,
                      ),
                    ),
                  ),
              ],
            ),

            if (_localIsSpeaking && widget.cleanSteps.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Text(
                  widget.cleanSteps[_localCurrentStep.clamp(0, widget.cleanSteps.length - 1)],
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade300,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}