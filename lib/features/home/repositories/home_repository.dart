import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:recipe_app/features/home/models/recipe_models.dart';

class HomeRepository {
  final String baseUrl =
      'https://www.themealdb.com/api/json/v1/1';

  Future<List<RecipeModel>> getRecipes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/search.php?s='),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load recipes');
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

  Future<List<RecipeModel>> getRecipesByCategory(
    String category,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/filter.php?c=${Uri.encodeComponent(category)}',
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
}