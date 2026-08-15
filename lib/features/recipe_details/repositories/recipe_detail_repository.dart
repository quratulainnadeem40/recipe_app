import 'package:recipe_app/core/constants/api_constants.dart';
import 'package:recipe_app/core/services/api_service.dart';
import 'package:recipe_app/features/recipe_details/model/recipe_detail_model.dart';

class RecipeDetailsRepository {
  final ApiService apiService;

  RecipeDetailsRepository({
    required this.apiService,
  });

  Future<RecipeDetailsModel> getRecipeDetails(
    String id,
  ) async {
    final response = await apiService.get(
      ApiConstants.recipeDetails(id),
    );

    final meals = response['meals'] as List?;

    if (meals == null || meals.isEmpty) {
      throw Exception('Recipe not found');
    }

    return RecipeDetailsModel.fromJson(
      meals.first as Map<String, dynamic>,
    );
  }
}