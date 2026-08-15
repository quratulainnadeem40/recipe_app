class ApiConstants {
  static const String baseUrl =
      'https://www.themealdb.com/api/json/v1/1';

  static const String chickenRecipes =
      '$baseUrl/filter.php?c=Chicken';

  static String recipeDetails(String id) {
    return '$baseUrl/lookup.php?i=$id';
  }
}