import 'package:dio/dio.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://www.themealdb.com/api/json/v1/1/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
  }

  // ============================================================
  // GENERIC GET
  // ============================================================

  Future<dynamic> getData(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);

      return response.data ?? {};
    } on DioException catch (e) {
      throw Exception(
        _getErrorMessage(e),
      );
    } catch (e) {
      throw Exception(
        'Something went wrong: $e',
      );
    }
  }

  // ============================================================
  // TRENDING RECIPES
  // ============================================================

  Future<dynamic> fetchTrending() async {
    try {
      final response = await _dio.get(
        'filter.php',
        queryParameters: {
          'c': 'Chicken',
        },
      );

      return response.data ?? {
        'meals': null,
      };
    } on DioException catch (e) {
      throw Exception(
        _getErrorMessage(e),
      );
    } catch (e) {
      throw Exception(
        'Unable to load trending recipes.',
      );
    }
  }

  // ============================================================
  // SEARCH RECIPES
  // ============================================================

  Future<dynamic> searchRecipes(
    String query,
  ) async {
    final value = query.trim();

    if (value.isEmpty) {
      return {
        'meals': null,
      };
    }

    try {
      final response = await _dio.get(
        'search.php',
        queryParameters: {
          's': value,
        },
      );

      return response.data ?? {
        'meals': null,
      };
    } on DioException catch (e) {
      throw Exception(
        _getErrorMessage(e),
      );
    } catch (e) {
      throw Exception(
        'Unable to search recipes.',
      );
    }
  }

  // ============================================================
  // RECIPES BY CATEGORY
  // ============================================================

  Future<dynamic> fetchByCategory(
    String category,
  ) async {
    final value = category.trim();

    if (value.isEmpty) {
      return {
        'meals': null,
      };
    }

    try {
      final response = await _dio.get(
        'filter.php',
        queryParameters: {
          'c': value,
        },
      );

      return response.data ?? {
        'meals': null,
      };
    } on DioException catch (e) {
      throw Exception(
        _getErrorMessage(e),
      );
    } catch (e) {
      throw Exception(
        'Unable to load category recipes.',
      );
    }
  }

  // ============================================================
  // RECIPES BY COUNTRY / AREA
  // ============================================================

  Future<dynamic> fetchByCountry(
    String area,
  ) async {
    final value = area.trim();

    if (value.isEmpty) {
      return {
        'meals': null,
      };
    }

    try {
      final response = await _dio.get(
        'filter.php',
        queryParameters: {
          'a': value,
        },
      );

      return response.data ?? {
        'meals': null,
      };
    } on DioException catch (e) {
      throw Exception(
        _getErrorMessage(e),
      );
    } catch (e) {
      throw Exception(
        'Unable to load country recipes.',
      );
    }
  }

  // ============================================================
  // RECIPE DETAILS
  // ============================================================

  Future<dynamic> fetchRecipeDetails(
    String id,
  ) async {
    final value = id.trim();

    if (value.isEmpty) {
      return {
        'meals': null,
      };
    }

    try {
      final response = await _dio.get(
        'lookup.php',
        queryParameters: {
          'i': value,
        },
      );

      return response.data ?? {
        'meals': null,
      };
    } on DioException catch (e) {
      throw Exception(
        _getErrorMessage(e),
      );
    } catch (e) {
      throw Exception(
        'Unable to load recipe details.',
      );
    }
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  String _getErrorMessage(
    DioException error,
  ) {
    if (error.type ==
        DioExceptionType.connectionTimeout) {
      return 'Connection timed out. Please check your internet.';
    }

    if (error.type ==
        DioExceptionType.receiveTimeout) {
      return 'Server response timed out. Please try again.';
    }

    if (error.type ==
        DioExceptionType.sendTimeout) {
      return 'Request timed out. Please try again.';
    }

    if (error.type ==
        DioExceptionType.connectionError) {
      return 'No internet connection.';
    }

    if (error.response != null) {
      return 'Server error: ${error.response?.statusCode}.';
    }

    return 'Unable to connect to the recipe server.';
  }
}