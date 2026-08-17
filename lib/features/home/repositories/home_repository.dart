import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:recipe_app/core/constants/api_constants.dart';
import 'package:recipe_app/features/home/models/recipe_models.dart';

class HomeRepository {
  // =========================================================
  // NETWORK SETTINGS
  // =========================================================

  static const Duration _requestTimeout =
      Duration(seconds: 12);

  static const int _maxRetries = 3;

  // =========================================================
  // GET ALL RECIPES
  // =========================================================

  Future<List<RecipeModel>> getRecipes() async {
    final response = await _getWithRetry(
      Uri.parse(ApiConstants.allRecipes),
    );

    final data = _decodeResponse(response);

    final meals = data['meals'] as List?;

    if (meals == null || meals.isEmpty) {
      return [];
    }

    return meals
        .map(
          (item) => RecipeModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .where(
          (recipe) =>
              recipe.id.isNotEmpty &&
              recipe.name.isNotEmpty,
        )
        .toList();
  }

  // =========================================================
  // GET RECIPES BY CATEGORY
  // =========================================================

  Future<List<RecipeModel>> getRecipesByCategory(
    String category,
  ) async {
    final cleanCategory = category.trim();

    if (cleanCategory.isEmpty) {
      return [];
    }

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}/filter.php?c=${Uri.encodeComponent(cleanCategory)}',
    );

    final response = await _getWithRetry(uri);

    final data = _decodeResponse(response);

    final meals = data['meals'] as List?;

    if (meals == null || meals.isEmpty) {
      return [];
    }

    // -------------------------------------------------------
    // IMPORTANT:
    // filter.php already gives:
    // idMeal
    // strMeal
    // strMealThumb
    //
    // Do NOT call lookup.php for every recipe here.
    // Full details will be loaded when the user opens
    // the recipe detail screen.
    // -------------------------------------------------------

    return meals
        .map(
          (item) => RecipeModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .where(
          (recipe) =>
              recipe.id.isNotEmpty &&
              recipe.name.isNotEmpty,
        )
        .toList();
  }

  // =========================================================
  // GET RECIPES BY COUNTRY / AREA
  // =========================================================

  Future<List<RecipeModel>> getRecipesByCountry(
    String country,
  ) async {
    final cleanCountry = country.trim();

    if (cleanCountry.isEmpty) {
      return [];
    }

    try {
      // -----------------------------------------------------
      // STEP 1:
      // Try official AREA filter.
      // -----------------------------------------------------

      final url =
          ApiConstants.recipesByCountry(cleanCountry);

      final response = await _getWithRetry(
        Uri.parse(url),
      );

      final data = _decodeResponse(response);

      final meals = data['meals'] as List?;

      if (meals != null && meals.isNotEmpty) {
        return meals
            .map(
              (item) => RecipeModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .where(
              (recipe) =>
                  recipe.id.isNotEmpty &&
                  recipe.name.isNotEmpty,
            )
            .toList();
      }

      // -----------------------------------------------------
      // STEP 2:
      // Official area filter returned no recipes.
      // Use fallback search.
      // -----------------------------------------------------

      return _getFallbackCountryRecipes(
        cleanCountry,
      );
    } catch (_) {
      // -----------------------------------------------------
      // STEP 3:
      // If area API fails, try fallback.
      // -----------------------------------------------------

      try {
        return await _getFallbackCountryRecipes(
          cleanCountry,
        );
      } catch (_) {
        return [];
      }
    }
  }

  // =========================================================
  // GET SINGLE RECIPE DETAILS
  // =========================================================
  //
  // This method is intentionally kept separate.
  //
  // Home/category screens should NOT call this for every
  // recipe.
  //
  // Recipe Detail screen can use this method later.
  // =========================================================

  Future<RecipeModel?> getRecipeDetails(
    String recipeId,
  ) async {
    final cleanId = recipeId.trim();

    if (cleanId.isEmpty) {
      return null;
    }

    try {
      final response = await _getWithRetry(
        Uri.parse(
          '${ApiConstants.baseUrl}/lookup.php?i=${Uri.encodeComponent(cleanId)}',
        ),
      );

      final data = _decodeResponse(response);

      final meals = data['meals'] as List?;

      if (meals == null || meals.isEmpty) {
        return null;
      }

      return RecipeModel.fromJson(
        Map<String, dynamic>.from(meals.first),
      );
    } catch (_) {
      return null;
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

    final Set<String> recipeIds = {};

    for (final query in queries) {
      try {
        final response = await _getWithRetry(
          Uri.parse(
            '${ApiConstants.baseUrl}/search.php?s=${Uri.encodeComponent(query)}',
          ),
        );

        final data = _decodeResponse(response);

        final meals = data['meals'] as List?;

        if (meals == null || meals.isEmpty) {
          continue;
        }

        for (final item in meals) {
          final recipe = RecipeModel.fromJson(
            Map<String, dynamic>.from(item),
          );

          if (recipe.id.isEmpty ||
              recipe.name.isEmpty) {
            continue;
          }

          if (recipeIds.add(recipe.id)) {
            recipes.add(recipe);
          }
        }
      } catch (_) {
        // ---------------------------------------------------
        // One fallback query failing must NOT stop all
        // remaining queries.
        // ---------------------------------------------------

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
    final cleanQuery = query.trim();

    if (cleanQuery.isEmpty) {
      return [];
    }

    final response = await _getWithRetry(
      Uri.parse(
        '${ApiConstants.baseUrl}/search.php?s=${Uri.encodeComponent(cleanQuery)}',
      ),
    );

    final data = _decodeResponse(response);

    final meals = data['meals'] as List?;

    if (meals == null || meals.isEmpty) {
      return [];
    }

    return meals
        .map(
          (item) => RecipeModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .where(
          (recipe) =>
              recipe.id.isNotEmpty &&
              recipe.name.isNotEmpty,
        )
        .toList();
  }

  // =========================================================
  // HTTP GET WITH RETRY
  // =========================================================

  Future<http.Response> _getWithRetry(
    Uri uri,
  ) async {
    Object? lastError;

    for (int attempt = 1;
        attempt <= _maxRetries;
        attempt++) {
      try {
        final response = await http
            .get(uri)
            .timeout(_requestTimeout);

        // ---------------------------------------------------
        // SUCCESS
        // ---------------------------------------------------

        if (response.statusCode == 200) {
          return response;
        }

        // ---------------------------------------------------
        // RETRYABLE SERVER/RATE-LIMIT STATUS
        // ---------------------------------------------------

        if (_isRetryableStatus(response.statusCode) &&
            attempt < _maxRetries) {
          await _waitBeforeRetry(attempt);
          continue;
        }

        throw HttpException(
          'Request failed with status ${response.statusCode}',
        );
      } on TimeoutException catch (e) {
        lastError = e;

        if (attempt < _maxRetries) {
          await _waitBeforeRetry(attempt);
          continue;
        }
      } on SocketException catch (e) {
        lastError = e;

        if (attempt < _maxRetries) {
          await _waitBeforeRetry(attempt);
          continue;
        }
      } on http.ClientException catch (e) {
        lastError = e;

        if (attempt < _maxRetries) {
          await _waitBeforeRetry(attempt);
          continue;
        }
      } catch (e) {
        lastError = e;

        if (attempt < _maxRetries) {
          await _waitBeforeRetry(attempt);
          continue;
        }
      }
    }

    throw Exception(
      lastError?.toString() ??
          'Unable to connect to recipe service',
    );
  }

  // =========================================================
  // RETRYABLE STATUS CODES
  // =========================================================

  bool _isRetryableStatus(
    int statusCode,
  ) {
    return statusCode == 408 ||
        statusCode == 429 ||
        statusCode >= 500;
  }

  // =========================================================
  // RETRY DELAY
  // =========================================================

  Future<void> _waitBeforeRetry(
    int attempt,
  ) async {
    final seconds = attempt * 2;

    await Future.delayed(
      Duration(seconds: seconds),
    );
  }

  // =========================================================
  // JSON DECODER
  // =========================================================

  Map<String, dynamic> _decodeResponse(
    http.Response response,
  ) {
    if (response.statusCode != 200) {
      throw HttpException(
        'Server returned ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid recipe API response',
      );
    }

    return decoded;
  }
}