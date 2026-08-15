import 'dart:async';

import 'package:get/get.dart';

import 'package:recipe_app/features/home/models/recipe_models.dart';
import 'package:recipe_app/features/home/repositories/home_repository.dart';

class SearchController extends GetxController {
  final HomeRepository repository;

  SearchController({
    required this.repository,
  });

  // =========================================================
  // SEARCH RESULTS
  // =========================================================

  final RxList<RecipeModel> searchResults =
      <RecipeModel>[].obs;

  // =========================================================
  // SEARCH TEXT
  // =========================================================

  final RxString searchQuery = ''.obs;

  // =========================================================
  // LOADING
  // =========================================================

  final RxBool isLoading = false.obs;

  // =========================================================
  // ERROR
  // =========================================================

  final RxString errorMessage = ''.obs;

  // =========================================================
  // SEARCH
  // =========================================================

  Future<void> searchRecipes(String query) async {
    final trimmedQuery = query.trim();

    searchQuery.value = trimmedQuery;
    errorMessage.value = '';

    if (trimmedQuery.isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      isLoading.value = true;

      final result =
          await repository.searchRecipes(trimmedQuery);

      searchResults.assignAll(result);
    } catch (e) {
      searchResults.clear();
      errorMessage.value =
          'Failed to search recipes. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================
  // CLEAR SEARCH
  // =========================================================

  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
    errorMessage.value = '';
  }
}