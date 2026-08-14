class ApiConstants {
  static const String baseUrl =
      'https://www.themealdb.com/api/json/v1/1';

  // =========================================================
  // ALL RECIPES
  // =========================================================

  static const String allRecipes =
      '$baseUrl/search.php?s=';

  // =========================================================
  // CHICKEN RECIPES
  // =========================================================

  static const String chickenRecipes =
      '$baseUrl/filter.php?c=Chicken';

  // =========================================================
  // RECIPES BY COUNTRY / AREA
  // =========================================================

  static String recipesByCountry(String country) {
    return '$baseUrl/filter.php?a=${Uri.encodeComponent(country)}';
  }

  // =========================================================
  // RECIPE DETAILS
  // =========================================================

  static String recipeDetails(String id) {
    return '$baseUrl/lookup.php?i=$id';
  }
}