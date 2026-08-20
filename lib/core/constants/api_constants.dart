class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'https://www.themealdb.com/api/json/v1/1';

  static const String search =
      '$baseUrl/search.php?s=';

  static const String category =
      '$baseUrl/filter.php?c=';

  static const String area =
      '$baseUrl/filter.php?a=';

  static const String details =
      '$baseUrl/lookup.php?i=';

  static const String chicken =
      '$baseUrl/filter.php?c=Chicken';

  static const String areas =
      '$baseUrl/list.php?a=list';

  static const String categories =
      '$baseUrl/list.php?c=list';
}