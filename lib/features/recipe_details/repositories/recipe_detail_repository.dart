import 'package:recipe_app/core/services/api_service.dart';
import 'package:recipe_app/features/recipe_details/model/recipe_detail_model.dart';

class RecipeDetailsRepository {
  final ApiService apiService;

  RecipeDetailsRepository({
    required this.apiService,
  });

  // =========================================================
  // GET RECIPE DETAILS
  // =========================================================

  Future<RecipeDetailsModel> getRecipeDetails(String id) async {
    final recipeId = id.trim();

    if (recipeId.isEmpty) {
      throw Exception('Recipe ID cannot be empty');
    }

    final responseData = await apiService.getData('lookup.php?i=$recipeId');

    if (responseData is! Map) {
      throw Exception('Invalid response format');
    }

    final meals = responseData['meals'];

    if (meals == null || meals is! List || meals.isEmpty) {
      throw Exception('Recipe not found');
    }

    final meal = Map<String, dynamic>.from(meals.first as Map);

    return RecipeDetailsModel.fromJson(meal);
  }
}