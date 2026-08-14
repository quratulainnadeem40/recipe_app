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

    return meals
        .map(
          (item) => RecipeModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
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

    return meals
        .map(
          (item) => RecipeModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
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

      final url =
          ApiConstants.recipesByCountry(country);

      print('========================================');
      print('🌍 Country: $country');
      print('🔗 API URL: $url');

      final response = await http.get(
        Uri.parse(url),
      );

      print(
        '📡 Area Status Code: ${response.statusCode}',
      );
      print(
        '📦 Area Response: ${response.body}',
      );
      print('========================================');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final meals = data['meals'] as List?;

        // -----------------------------------------------------
        // If area API returns recipes, use them
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
            '✅ Found ${recipes.length} recipes using area filter.',
          );

          return recipes;
        }
      }

      // -------------------------------------------------------
      // STEP 2:
      // Area filter returned nothing.
      // Use country-specific fallback searches.
      // -------------------------------------------------------

      print(
        '⚠️ No recipes found using area filter.',
      );

      print(
        '🔄 Starting fallback recipe search for $country...',
      );

      final fallbackRecipes =
          await _getFallbackCountryRecipes(
        country,
      );

      print(
        '✅ Fallback recipes found: ${fallbackRecipes.length}',
      );

      return fallbackRecipes;
    } catch (e) {
      print(
        '❌ Country recipe error: $e',
      );

      // -------------------------------------------------------
      // STEP 3:
      // Even if area request fails, try fallback search
      // -------------------------------------------------------

      final fallbackRecipes =
          await _getFallbackCountryRecipes(
        country,
      );

      return fallbackRecipes;
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

    // Used to prevent duplicate recipes
    final Set<String> recipeIds = {};

    // -------------------------------------------------------
    // Search each dish
    // -------------------------------------------------------

    for (final query in queries) {
      try {
        print(
          '🔎 Searching $country recipe: $query',
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
          final recipe =
              RecipeModel.fromJson(
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
          '⚠️ Failed searching "$query": $e',
        );

        // Continue with next search
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
      // OTHER COUNTRIES
      // =====================================================

      case 'italian':
        return [
          'Pizza',
          'Pasta',
          'Lasagne',
          'Risotto',
        ];

      case 'french':
        return [
          'Croissant',
          'French Onion Soup',
          'Ratatouille',
          'Crepes',
        ];

      case 'chinese':
        return [
          'Chow Mein',
          'Sweet and Sour Chicken',
          'Kung Pao Chicken',
          'Spring Rolls',
        ];

      case 'japanese':
        return [
          'Sushi',
          'Ramen',
          'Teriyaki',
          'Tempura',
        ];

      case 'mexican':
        return [
          'Tacos',
          'Burrito',
          'Enchiladas',
          'Guacamole',
        ];

      case 'thai':
        return [
          'Pad Thai',
          'Thai Green Curry',
          'Tom Yum',
          'Thai Soup',
        ];

      case 'turkish':
        return [
          'Kebab',
          'Doner',
          'Baklava',
          'Turkish Delight',
        ];

      case 'british':
        return [
          'Fish and Chips',
          'Shepherds Pie',
          'Yorkshire Pudding',
          'English Breakfast',
        ];

      case 'canadian':
        return [
          'Poutine',
          'Canadian Pancakes',
          'Butter Tarts',
        ];

      case 'greek':
        return [
          'Moussaka',
          'Greek Salad',
          'Souvlaki',
          'Tzatziki',
        ];

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

    return meals
        .map(
          (item) => RecipeModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
}