
class AppConstants {
  AppConstants._();

  static const String appName = 'COOKmate';
  static const String appVersion = '1.0.0';
  static const String supportEmail = 'innovexa.technologies01@gmail.com';
}

class ApiConstants {
  static const String baseUrl =
      'https://www.themealdb.com/api/json/v1/1';

  // =========================================================
  // CHICKEN RECIPES
  // =========================================================

  static const String chickenRecipes =
      '$baseUrl/filter.php?c=Chicken';

  // =========================================================
  // RECIPES BY COUNTRY
  // =========================================================

  static String recipesByCountry(String country) {
    return '$baseUrl/filter.php?a=$country';
  }

  // =========================================================
  // RECIPE DETAILS
  // =========================================================

  static String recipeDetails(String id) {
    return '$baseUrl/lookup.php?i=$id';
  }
}