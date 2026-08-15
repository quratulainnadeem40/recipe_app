import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:recipe_app/core/constants/api_constants.dart';
import 'package:recipe_app/features/home/models/recipe_models.dart';

class HomeRepository {
  // =========================================================
  // GET ALL RECIPES
  // =========================================================

  Future<List<RecipeModel>> getRecipes() async {
    final response = await http.get(
      Uri.parse(
        ApiConstants.allRecipes,
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load recipes',
      );
    }

    final data = jsonDecode(response.body);

    final meals = data['meals'] as List?;

    if (meals == null) {
      return [];
    }

    final recipes = meals
        .map(
          (item) => RecipeModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();

    return _enrichRecipes(recipes);
  }

  // =========================================================
  // GET RECIPES BY CATEGORY
  // =========================================================

  Future<List<RecipeModel>> getRecipesByCategory(
    String category,
  ) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConstants.baseUrl}/filter.php?c=${Uri.encodeComponent(category)}',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load $category recipes',
      );
    }

    final data = jsonDecode(response.body);

    final meals = data['meals'] as List?;

    if (meals == null) {
      return [];
    }

    final recipes = meals
        .map(
          (item) => RecipeModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();

    // filter.php only gives basic information,
    // so get complete recipe details.
    return _enrichRecipes(recipes);
  }

  // =========================================================
  // GET RECIPES BY COUNTRY / AREA
  // =========================================================

  Future<List<RecipeModel>> getRecipesByCountry(
    String country,
  ) async {
    try {
      // -------------------------------------------------------
      // STEP 1:
      // Try TheMealDB AREA filter first
      // -------------------------------------------------------

      final url = ApiConstants.recipesByCountry(country);

      print('========================================');
      print('Country: $country');
      print('API URL: $url');

      final response = await http.get(
        Uri.parse(url),
      );

      print(
        'Area Status Code: ${response.statusCode}',
      );

      print(
        'Area Response: ${response.body}',
      );

      print('========================================');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final meals = data['meals'] as List?;

        // -----------------------------------------------------
        // If area API returns recipes
        // -----------------------------------------------------

        if (meals != null && meals.isNotEmpty) {
          final recipes = meals
              .map(
                (item) => RecipeModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList();

          print(
            'Found ${recipes.length} recipes using area filter.',
          );

          return _enrichRecipes(recipes);
        }
      }

      // -------------------------------------------------------
      // STEP 2:
      // Area filter returned nothing.
      // Use fallback searches.
      // -------------------------------------------------------

      print(
        'No recipes found using area filter.',
      );

      print(
        'Starting fallback recipe search for $country...',
      );

      final fallbackRecipes =
          await _getFallbackCountryRecipes(country);

      print(
        'Fallback recipes found: ${fallbackRecipes.length}',
      );

      return fallbackRecipes;
    } catch (e) {
      print(
        'Country recipe error: $e',
      );

      // -------------------------------------------------------
      // STEP 3:
      // Try fallback search
      // -------------------------------------------------------

      return _getFallbackCountryRecipes(country);
    }
  }

  // =========================================================
  // ENRICH RECIPES WITH COMPLETE DETAILS
  // =========================================================

  Future<List<RecipeModel>> _enrichRecipes(
    List<RecipeModel> recipes,
  ) async {
    if (recipes.isEmpty) {
      return [];
    }

    try {
      final detailedRecipes = await Future.wait(
        recipes.map(
          (recipe) => _getRecipeDetails(recipe),
        ),
      );

      return detailedRecipes;
    } catch (e) {
      print(
        'Recipe enrichment error: $e',
      );

      // If detail API fails, return original recipes.
      return recipes;
    }
  }

  // =========================================================
  // GET SINGLE RECIPE DETAILS
  // =========================================================

  Future<RecipeModel> _getRecipeDetails(
    RecipeModel recipe,
  ) async {
    try {
      if (recipe.id.isEmpty) {
        return recipe;
      }

      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}/lookup.php?i=${Uri.encodeComponent(recipe.id)}',
        ),
      );

      if (response.statusCode != 200) {
        return recipe;
      }

      final data = jsonDecode(response.body);

      final meals = data['meals'] as List?;

      if (meals == null || meals.isEmpty) {
        return recipe;
      }

      final meal =
          Map<String, dynamic>.from(meals.first);

      return RecipeModel.fromJson(meal);
    } catch (e) {
      print(
        'Failed to get details for ${recipe.name}: $e',
      );

      return recipe;
    }
  }

  // =========================================================
  // COUNTRY FALLBACK RECIPES
  // =========================================================

  Future<List<RecipeModel>> _getFallbackCountryRecipes(
    String country,
  ) async {
    final queries = _getCountrySearchQueries(
      country,
    );

    if (queries.isEmpty) {
      return [];
    }

    final List<RecipeModel> recipes = [];

    // Used to prevent duplicates.
    final Set<String> recipeIds = {};

    // -------------------------------------------------------
    // Search each dish
    // -------------------------------------------------------

    for (final query in queries) {
      try {
        print(
          'Searching $country recipe: $query',
        );

        final response = await http.get(
          Uri.parse(
            '${ApiConstants.baseUrl}/search.php?s=${Uri.encodeComponent(query)}',
          ),
        );

        if (response.statusCode != 200) {
          continue;
        }

        final data = jsonDecode(response.body);

        final meals = data['meals'] as List?;

        if (meals == null || meals.isEmpty) {
          continue;
        }

        for (final item in meals) {
          final recipe = RecipeModel.fromJson(
            Map<String, dynamic>.from(item),
          );

          // ---------------------------------------------------
          // Add only unique recipes
          // ---------------------------------------------------

          if (!recipeIds.contains(recipe.id)) {
            recipeIds.add(recipe.id);
            recipes.add(recipe);
          }
        }
      } catch (e) {
        print(
          'Failed searching "$query": $e',
        );

        continue;
      }
    }

    return recipes;
  }

  // =========================================================
  // COUNTRY SEARCH QUERIES
  // =========================================================

  List<String> _getCountrySearchQueries(
    String country,
  ) {
    switch (country.toLowerCase()) {
      // =====================================================
      // PAKISTANI
      // =====================================================

      case 'pakistani':
        return [
          'Biryani',
          'Chicken Karahi',
          'Nihari',
          'Haleem',
          'Keema',
          'Pulao',
          'Kebab',
          'Paratha',
        ];

      // =====================================================
      // INDIAN
      // =====================================================

      case 'indian':
        return [
          'Biryani',
          'Butter Chicken',
          'Tandoori Chicken',
          'Chicken Tikka',
          'Naan',
          'Samosa',
          'Curry',
          'Paneer',
        ];

      // =====================================================
      // AMERICAN
      // =====================================================

      case 'american':
        return [
          'Burger',
          'Pancakes',
          'Macaroni and Cheese',
          'Fried Chicken',
          'BBQ',
          'Apple Pie',
          'Brownies',
          'Cheesecake',
        ];

      // =====================================================
      // ITALIAN
      // =====================================================

      case 'italian':
        return [
          'Pizza',
          'Pasta',
          'Lasagne',
          'Risotto',
        ];

      // =====================================================
      // FRENCH
      // =====================================================

      case 'french':
        return [
          'Croissant',
          'French Onion Soup',
          'Ratatouille',
          'Crepes',
        ];

      // =====================================================
      // CHINESE
      // =====================================================

      case 'chinese':
        return [
          'Chow Mein',
          'Sweet and Sour Chicken',
          'Kung Pao Chicken',
          'Spring Rolls',
        ];

      // =====================================================
      // JAPANESE
      // =====================================================

      case 'japanese':
        return [
          'Sushi',
          'Ramen',
          'Teriyaki',
          'Tempura',
        ];

      // =====================================================
      // MEXICAN
      // =====================================================

      case 'mexican':
        return [
          'Tacos',
          'Burrito',
          'Enchiladas',
          'Guacamole',
        ];

      // =====================================================
      // THAI
      // =====================================================

      case 'thai':
        return [
          'Pad Thai',
          'Thai Green Curry',
          'Tom Yum',
          'Thai Soup',
        ];

      // =====================================================
      // TURKISH
      // =====================================================

      case 'turkish':
        return [
          'Kebab',
          'Doner',
          'Baklava',
          'Turkish Delight',
        ];

      // =====================================================
      // BRITISH
      // =====================================================

      case 'british':
        return [
          'Fish and Chips',
          'Shepherds Pie',
          'Yorkshire Pudding',
          'English Breakfast',
        ];

      // =====================================================
      // CANADIAN
      // =====================================================

      case 'canadian':
        return [
          'Poutine',
          'Canadian Pancakes',
          'Butter Tarts',
        ];

      // =====================================================
      // GREEK
      // =====================================================

      case 'greek':
        return [
          'Moussaka',
          'Greek Salad',
          'Souvlaki',
          'Tzatziki',
        ];

      // =====================================================
      // SPANISH
      // =====================================================

      case 'spanish':
        return [
          'Paella',
          'Tortilla',
          'Spanish Omelette',
        ];

      default:
        return [];
    }
  }

  // =========================================================
  // SEARCH RECIPES
  // =========================================================

  Future<List<RecipeModel>> searchRecipes(
    String query,
  ) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConstants.baseUrl}/search.php?s=${Uri.encodeComponent(query)}',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to search recipes',
      );
    }

    final data = jsonDecode(response.body);

    final meals = data['meals'] as List?;

    if (meals == null) {
      return [];
    }

    // search.php already provides complete details.
    return meals
        .map(
          (item) => RecipeModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
}