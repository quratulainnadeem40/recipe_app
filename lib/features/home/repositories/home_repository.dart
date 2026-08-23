import 'package:recipe_app/core/services/api_service.dart';
import 'package:recipe_app/features/home/models/recipe_models.dart';

class HomeRepository {
  final ApiService apiService;

  HomeRepository({
    required this.apiService,
  });

  // ============================================================
  // TRENDING / FEATURED
  // ============================================================

  Future<List<RecipeModel>> getTrendingRecipes() async {
    try {
      final data = await apiService.fetchTrending();

      return _parseRecipes(data);
    } catch (e) {
      throw Exception(
        'Failed to load trending recipes',
      );
    }
  }
    // ============================================================
  // ALL RECIPES
  // ============================================================

  
  // ============================================================
  // ALL RECIPES
  // ============================================================

  Future<List<RecipeModel>> getAllRecipes() async {
    try {
      // App start par different dishes load hongi
      final searches = [
        'biryani',
        'pasta',
        'salad',
        'chicken',
        'pizza',
      ];

      List<RecipeModel> allRecipes = [];

      for (final search in searches) {
        final data = await apiService.searchRecipes(
          Uri.encodeComponent(search),
        );

        final recipes = _parseRecipes(data);
        allRecipes.addAll(recipes);
      }

      // Duplicate recipes remove
      final uniqueRecipes = <String, RecipeModel>{};

      for (final recipe in allRecipes) {
        uniqueRecipes[recipe.id] = recipe;
      }

      return uniqueRecipes.values.toList();
    } catch (e) {
      throw Exception(
        'Failed to load all recipes',
      );
    }
  }
  // ============================================================
  // SEARCH
  // ============================================================

    // ============================================================
  // SEARCH
  // ============================================================

  Future<List<RecipeModel>> searchRecipes(
    String query,
  ) async {
    final value = query.trim();

    // Empty query ho to all recipes return karo
    if (value.isEmpty) {
      return await getAllRecipes();
    }

    try {
      final data = await apiService.searchRecipes(
        Uri.encodeComponent(value),
      );

      return _parseRecipes(data);
    } catch (e) {
      throw Exception(
        'Failed to search recipes',
      );
    }
  }

  // ============================================================
  // CATEGORY
  // ============================================================

  Future<List<RecipeModel>> getRecipesByCategory(
    String category,
  ) async {
    final value = category.trim();

    if (value.isEmpty) {
      return [];
    }

    try {
      final data = await apiService.fetchByCategory(
        Uri.encodeComponent(value),
      );

      if (data['meals'] == null) {
        return [];
      }

      final List meals = data['meals'];

      return meals
          .whereType<Map<String, dynamic>>()
          .map(
            (json) => RecipeModel.fromJson(
              json,
              fallbackCategory: value,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception(
        'Failed to load $value recipes',
      );
    }
  }

  // ============================================================
  // COUNTRY / AREA
  // ============================================================

  Future<List<RecipeModel>> getRecipesByCountry(
    String area,
  ) async {
    final value = area.trim();

    if (value.isEmpty) {
      return [];
    }

    try {
      final data = await apiService.fetchByCountry(
        Uri.encodeComponent(value),
      );

      if (data['meals'] == null) {
        return [];
      }

      final List meals = data['meals'];

      return meals
          .whereType<Map<String, dynamic>>()
          .map(
            (json) => RecipeModel.fromJson(
              json,
              fallbackArea: value,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception(
        'Failed to load $value recipes',
      );
    }
  }

  // ============================================================
  // RECIPE DETAILS
  // ============================================================

  Future<RecipeModel?> getRecipeDetails(
    String id,
  ) async {
    final value = id.trim();

    if (value.isEmpty) {
      return null;
    }

    try {
      final data =
          await apiService.fetchRecipeDetails(
        Uri.encodeComponent(value),
      );

      if (data['meals'] == null) {
        return null;
      }

      final List meals = data['meals'];

      if (meals.isEmpty) {
        return null;
      }

      final firstMeal = meals.first;

      if (firstMeal is! Map<String, dynamic>) {
        return null;
      }

      return RecipeModel.fromJson(
        firstMeal,
      );
    } catch (e) {
      throw Exception(
        'Failed to load recipe details',
      );
    }
  }

  // ============================================================
  // PRIVATE PARSER
  // ============================================================

  List<RecipeModel> _parseRecipes(
    dynamic data,
  ) {
    if (data is! Map<String, dynamic>) {
      return [];
    }

    final meals = data['meals'];

    if (meals == null || meals is! List) {
      return [];
    }

    return meals
        .whereType<Map<String, dynamic>>()
        .map(
          (json) => RecipeModel.fromJson(json),
        )
        .where(
          (recipe) =>
              recipe.id.isNotEmpty &&
              recipe.name.isNotEmpty,
        )
        .toList();
  }
}