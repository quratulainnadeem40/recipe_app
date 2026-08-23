import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:recipe_app/features/favorites/models/favorite_recipe_model.dart';
import 'package:recipe_app/features/notifications/controllers/notifications_controller.dart';

class FavoritesController extends GetxController {
  final GetStorage _storage = GetStorage();

  static const String _favStorageKey = 'user_favorites';

  final favorites = <FavoriteRecipeModel>[].obs;

  // Notification Controller
  NotificationController get notificationController =>
      Get.find<NotificationController>();

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  bool isFavorite(String recipeId) {
    return favorites.any(
      (item) => item.id == recipeId,
    );
  }

  // =========================================================
  // ADD / REMOVE FAVORITE
  // =========================================================

  void toggleFavorite(FavoriteRecipeModel recipe) {
    if (isFavorite(recipe.id)) {
      removeFavorite(recipe.id);

      // 💔 REMOVE NOTIFICATION
      notificationController.addNotification(
        title: 'Removed from Favorites 💔',
        message: '${recipe.name} removed from favorites.',
      );
    } else {
      favorites.add(recipe);
      _saveToStorage();

      // ❤️ ADD NOTIFICATION
      notificationController.addNotification(
        title: 'Added to Favorites ❤️',
        message: '${recipe.name} added to favorites.',
      );
    }
  }

  // =========================================================
  // REMOVE FAVORITE
  // =========================================================

  void removeFavorite(String recipeId) {
    final index = favorites.indexWhere(
      (item) => item.id == recipeId,
    );

    if (index == -1) {
      return;
    }

    final removedRecipe = favorites[index];

    favorites.removeAt(index);
    _saveToStorage();

    // 💔 NOTIFICATION
    notificationController.addNotification(
      title: 'Removed from Favorites 💔',
      message: '${removedRecipe.name} removed from favorites.',
    );
  }

  // =========================================================
  // SAVE
  // =========================================================

  void _saveToStorage() {
    final List<Map<String, dynamic>> rawList =
        favorites.map((item) => item.toMap()).toList();

    _storage.write(
      _favStorageKey,
      rawList,
    );
  }

  // =========================================================
  // LOAD
  // =========================================================

  void loadFavorites() {
    final rawData = _storage.read<List>(
      _favStorageKey,
    );

    if (rawData != null) {
      favorites.value = rawData
          .map(
            (item) => FavoriteRecipeModel.fromMap(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    }
  }
}