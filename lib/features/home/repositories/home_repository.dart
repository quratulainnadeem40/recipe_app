import 'package:recipe_app/core/data/pakistani_recipes_data.dart';
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
      final pakRecipes = PakistaniRecipesData.getRecipeModels();
      final data = await apiService.fetchTrending();
      final apiRecipes = _parseRecipes(data);
      
      return [
        if (pakRecipes.isNotEmpty) pakRecipes.first,
        ...apiRecipes,
      ];
    } catch (e) {
      return PakistaniRecipesData.getRecipeModels().take(5).toList();
    }
  }

  // ============================================================
  // ALL RECIPES (PARALLEL & RESILIENT)
  // ============================================================

  Future<List<RecipeModel>> getAllRecipes() async {
    final searches = [
      'chicken',
      'pasta',
      'salad',
      'beef',
      'soup',
      'rice',
      'seafood',
      'curry',
      'cake',
      'pie',
      'egg',
    ];

    List<RecipeModel> allRecipes = [
      ...PakistaniRecipesData.getRecipeModels(),
    ];

    try {
      final results = await Future.wait(
        searches.map((search) async {
          try {
            final data = await apiService.searchRecipes(
              Uri.encodeComponent(search),
            );
            return _parseRecipes(data);
          } catch (_) {
            return <RecipeModel>[];
          }
        }),
      );

      for (final list in results) {
        allRecipes.addAll(list);
      }

      // Deduplicate by ID
      final uniqueRecipes = <String, RecipeModel>{};
      for (final recipe in allRecipes) {
        if (recipe.id.isNotEmpty) {
          uniqueRecipes[recipe.id] = recipe;
        }
      }

      if (uniqueRecipes.isNotEmpty) {
        return uniqueRecipes.values.toList();
      }
    } catch (_) {}

    return PakistaniRecipesData.getRecipeModels();
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Future<List<RecipeModel>> searchRecipes(
    String query,
  ) async {
    final value = query.trim().toLowerCase();

    if (value.isEmpty) {
      return await getAllRecipes();
    }

    final List<RecipeModel> matched = [];

    // Check Pakistani Recipes locally
    final pakMatches = PakistaniRecipesData.getRecipeModels().where((r) {
      return r.name.toLowerCase().contains(value) ||
          r.category.toLowerCase().contains(value) ||
          r.area.toLowerCase().contains(value) ||
          r.shortInfo.toLowerCase().contains(value) ||
          (value.contains('pak') && r.area.toLowerCase() == 'pakistani');
    }).toList();

    matched.addAll(pakMatches);

    try {
      final data = await apiService.searchRecipes(
        Uri.encodeComponent(value),
      );

      final apiRecipes = _parseRecipes(data);
      for (final r in apiRecipes) {
        if (!matched.any((m) => m.id == r.id)) {
          matched.add(r);
        }
      }
    } catch (_) {}

    return matched;
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

    final List<RecipeModel> results = [];

    // Add matching Pakistani recipes for category
    final pakCategoryMatches = PakistaniRecipesData.getRecipeModels().where(
      (r) => r.category.toLowerCase() == value.toLowerCase(),
    ).toList();
    results.addAll(pakCategoryMatches);

    try {
      final data = await apiService.fetchByCategory(
        Uri.encodeComponent(value),
      );

      if (data['meals'] != null && data['meals'] is List) {
        final List meals = data['meals'];
        final apiRecipes = meals
            .whereType<Map<String, dynamic>>()
            .map(
              (json) => RecipeModel.fromJson(
                json,
                fallbackCategory: value,
              ),
            )
            .toList();

        for (final r in apiRecipes) {
          if (!results.any((m) => m.id == r.id)) {
            results.add(r);
          }
        }
      }
    } catch (_) {}

    return results;
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

    // Special check for Pakistani cuisine
    if (value.toLowerCase() == 'pakistani' ||
        value.toLowerCase() == 'pakistan') {
      return PakistaniRecipesData.getRecipeModels();
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
      return [];
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

    // Check Pakistani Recipes first
    final pakRecipe = PakistaniRecipesData.getRecipeModels().firstWhere(
      (r) => r.id == value,
      orElse: () => const RecipeModel(id: '', name: '', image: ''),
    );

    if (pakRecipe.id.isNotEmpty) {
      return pakRecipe;
    }

    try {
      final data = await apiService.fetchRecipeDetails(
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
      return null;
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