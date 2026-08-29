import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:recipe_app/features/favorites/models/favorite_recipe_model.dart';

class FavoritesController extends GetxController {
  final GetStorage _storage = GetStorage();

  static const String _favStorageKey = 'user_favorites';

  final RxList<FavoriteRecipeModel> favorites =
      <FavoriteRecipeModel>[].obs;

  // =========================================================
  // INIT
  // =========================================================

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  // =========================================================
  // CHECK FAVORITE
  // =========================================================

  bool isFavorite(String recipeId) {
    final String cleanId = recipeId.trim();

    if (cleanId.isEmpty) {
      return false;
    }

    return favorites.any(
      (item) => item.id.trim() == cleanId,
    );
  }

  // =========================================================
  // TOGGLE FAVORITE
  // =========================================================

  void toggleFavorite(FavoriteRecipeModel recipe) {
    final String cleanId = recipe.id.trim();

    if (cleanId.isEmpty) {
      return;
    }

    final int existingIndex = favorites.indexWhere(
      (item) => item.id.trim() == cleanId,
    );

    // -------------------------------------------------------
    // REMOVE
    // -------------------------------------------------------
    if (existingIndex != -1) {
      favorites.removeAt(existingIndex);
      _saveToStorage();
      return;
    }

    // -------------------------------------------------------
    // ADD
    // -------------------------------------------------------
    final FavoriteRecipeModel cleanRecipe = FavoriteRecipeModel(
      id: cleanId,
      name: recipe.name.trim(),
      image: recipe.image.trim(),
    );

    favorites.add(cleanRecipe);
    _saveToStorage();
  }

  // =========================================================
  // ADD FAVORITE
  // =========================================================

  void addFavorite(FavoriteRecipeModel recipe) {
    final String cleanId = recipe.id.trim();

    if (cleanId.isEmpty) {
      return;
    }

    if (isFavorite(cleanId)) {
      return;
    }

    final FavoriteRecipeModel cleanRecipe = FavoriteRecipeModel(
      id: cleanId,
      name: recipe.name.trim(),
      image: recipe.image.trim(),
    );

    favorites.add(cleanRecipe);
    _saveToStorage();
  }

  // =========================================================
  // REMOVE FAVORITE
  // =========================================================

  void removeFavorite(String recipeId) {
    final String cleanId = recipeId.trim();

    if (cleanId.isEmpty) {
      return;
    }

    final int index = favorites.indexWhere(
      (item) => item.id.trim() == cleanId,
    );

    if (index == -1) {
      return;
    }

    favorites.removeAt(index);
    _saveToStorage();
  }

  // =========================================================
  // CLEAR ALL FAVORITES
  // =========================================================

  void clearFavorites() {
    if (favorites.isEmpty) {
      return;
    }

    favorites.clear();
    _saveToStorage();
  }

  // =========================================================
  // SAVE TO GET STORAGE
  // =========================================================

  void _saveToStorage() {
    try {
      final List<Map<String, dynamic>> rawList =
          favorites.map((item) => item.toMap()).toList();

      _storage.write(_favStorageKey, rawList);
    } catch (e) {
      Get.log('Error saving favorites: $e');
    }
  }

  // =========================================================
  // LOAD FROM GET STORAGE
  // =========================================================

  void loadFavorites() {
    try {
      final dynamic rawData = _storage.read(_favStorageKey);

      if (rawData == null || rawData is! List) {
        favorites.clear();
        return;
      }

      final List<FavoriteRecipeModel> loadedFavorites = [];

      for (final item in rawData) {
        try {
          if (item is Map) {
            final recipe = FavoriteRecipeModel.fromMap(
              Map<String, dynamic>.from(item),
            );

            if (recipe.id.trim().isEmpty) continue;

            final alreadyExists = loadedFavorites.any(
              (existing) => existing.id.trim() == recipe.id.trim(),
            );

            if (!alreadyExists) {
              loadedFavorites.add(recipe);
            }
          }
        } catch (e) {
          Get.log('Skipping invalid favorite item: $e');
        }
      }

      favorites.assignAll(loadedFavorites);
    } catch (e) {
      favorites.clear();
      Get.log('Error loading favorites: $e');
    }
  }

  // =========================================================
  // REFRESH FAVORITES
  // =========================================================

  void refreshFavorites() {
    loadFavorites();
  }

  // =========================================================
  // GET FAVORITE BY ID
  // =========================================================

  FavoriteRecipeModel? getFavoriteById(String recipeId) {
    final String cleanId = recipeId.trim();

    if (cleanId.isEmpty) {
      return null;
    }

    for (final item in favorites) {
      if (item.id.trim() == cleanId) {
        return item;
      }
    }

    return null;
  }
}