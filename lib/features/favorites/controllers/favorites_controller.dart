import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recipe_app/features/favorites/models/favorite_recipe_model.dart';

class FavoritesController extends GetxController {
  final GetStorage _storage = GetStorage();
  static const String _favStorageKey = 'user_favorites';

  // Obx list matching FavoritesScreen
  var favorites = <FavoriteRecipeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  bool isFavorite(String recipeId) {
    return favorites.any((item) => item.id == recipeId);
  }

  void toggleFavorite(FavoriteRecipeModel recipe) {
    if (isFavorite(recipe.id)) {
      removeFavorite(recipe.id);
    } else {
      favorites.add(recipe);
      _saveToStorage();
    }
  }

  void removeFavorite(String recipeId) {
    favorites.removeWhere((item) => item.id == recipeId);
    _saveToStorage();
  }

  void _saveToStorage() {
    final List<Map<String, dynamic>> rawList =
        favorites.map((item) => item.toMap()).toList();
    _storage.write(_favStorageKey, rawList);
  }

  void loadFavorites() {
    final rawData = _storage.read<List>(_favStorageKey);
    if (rawData != null) {
      favorites.value = rawData
          .map((item) => FavoriteRecipeModel.fromMap(Map<String, dynamic>.from(item)))
          .toList();
    }
  }
}