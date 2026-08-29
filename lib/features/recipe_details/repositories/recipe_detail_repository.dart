import 'package:recipe_app/core/data/pakistani_recipes_data.dart';
import 'package:recipe_app/core/services/api_service.dart';
import 'package:recipe_app/features/recipe_details/model/recipe_detail_model.dart';

class RecipeRepository {
  final ApiService apiService;

  RecipeRepository({
    required this.apiService,
  });

  // =========================================================
  // GET ALL RECIPES
  // =========================================================

  Future<List<Recipe>> getRecipes() async {
    final responseData =
        await apiService.getData('search.php?s=');

    if (responseData is! Map) {
      throw Exception('Invalid response format');
    }

    final meals = responseData['meals'];

    if (meals == null || meals is! List) {
      return <Recipe>[];
    }

    return meals
        .whereType<Map>()
        .map(
          (meal) => Recipe.fromJson(
            Map<String, dynamic>.from(meal),
          ),
        )
        .toList();
  }

  // =========================================================
  // GET RECIPE DETAILS
  // =========================================================

  Future<Recipe> getRecipeDetails(String id) async {
    final recipeId = id.trim();

    if (recipeId.isEmpty) {
      throw Exception('Recipe ID cannot be empty');
    }

    // Check Pakistani Recipes first
    final pakRecipe = PakistaniRecipesData.getRecipeDetailById(recipeId);
    if (pakRecipe != null) {
      return pakRecipe;
    }

    final responseData =
        await apiService.getData(
      'lookup.php?i=$recipeId',
    );

    if (responseData is! Map) {
      throw Exception('Invalid response format');
    }

    final meals = responseData['meals'];

    if (meals == null ||
        meals is! List ||
        meals.isEmpty) {
      throw Exception('Recipe not found');
    }

    final meal =
        Map<String, dynamic>.from(
      meals.first as Map,
    );

    return Recipe.fromJson(meal);
  }
}