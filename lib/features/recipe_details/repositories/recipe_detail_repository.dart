import 'package:recipe_app/core/constants/api_constants.dart';
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

  Future<RecipeDetailsModel> getRecipeDetails(
    String id,
  ) async {
    final recipeId = id.trim();

    if (recipeId.isEmpty) {
      throw Exception(
        'Recipe ID is empty',
      );
    }

    // ---------------------------------------------------------
    // Call TheMealDB details endpoint
    // ---------------------------------------------------------

    final response = await apiService.get(
      ApiConstants.recipeDetails(recipeId),
    );

    // ---------------------------------------------------------
    // Validate response
    // ---------------------------------------------------------

    if (response is! Map<String, dynamic>) {
      throw Exception(
        'Invalid recipe response',
      );
    }

    final meals = response['meals'] as List?;

    if (meals == null || meals.isEmpty) {
      throw Exception(
        'Recipe not found',
      );
    }

    // ---------------------------------------------------------
    // Convert API meal to model
    // ---------------------------------------------------------

    final meal =
        Map<String, dynamic>.from(
      meals.first as Map,
    );

    return RecipeDetailsModel.fromJson(
      meal,
    );
  }
}