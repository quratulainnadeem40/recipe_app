import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../notifications/controllers/notifications_controller.dart';
import '../models/favorite_recipe_model.dart';

class FavoritesController extends GetxController {
  final GetStorage _storage = GetStorage();

  static const String _favoritesKey = 'favorite_recipes';

  final RxList<FavoriteRecipeModel> favorites =
      <FavoriteRecipeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  // =========================================================
  // LOAD FAVORITES
  // =========================================================

  void loadFavorites() {
    final storedFavorites =
        _storage.read<List>(_favoritesKey);

    if (storedFavorites == null) {
      favorites.clear();
      return;
    }

    final loadedFavorites = storedFavorites
        .map(
          (item) => FavoriteRecipeModel.fromMap(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();

    favorites.assignAll(loadedFavorites);
  }

  // =========================================================
  // SAVE FAVORITES
  // =========================================================

  Future<void> saveFavorites() async {
    final data = favorites
        .map((recipe) => recipe.toMap())
        .toList();

    await _storage.write(
      _favoritesKey,
      data,
    );
  }

  // =========================================================
  // CHECK FAVORITE
  // =========================================================

  bool isFavorite(String recipeId) {
    return favorites.any(
      (recipe) => recipe.id == recipeId,
    );
  }

  // =========================================================
  // ADD FAVORITE
  // =========================================================

  Future<void> addFavorite(
    FavoriteRecipeModel recipe,
  ) async {
    if (isFavorite(recipe.id)) {
      return;
    }

    favorites.add(recipe);

    await saveFavorites();

    if (Get.isRegistered<NotificationController>()) {
      final notificationController =
          Get.find<NotificationController>();

      notificationController.addNotification(
        title: 'Recipe Added to Favorites',
        message:
            '${recipe.name} has been added to your favorites.',
      );
    }
  }

  // =========================================================
  // REMOVE FAVORITE
  // =========================================================

  Future<void> removeFavorite(
    String recipeId,
  ) async {
    favorites.removeWhere(
      (recipe) => recipe.id == recipeId,
    );

    await saveFavorites();
  }

  // =========================================================
  // TOGGLE FAVORITE
  // =========================================================

  Future<void> toggleFavorite(
    FavoriteRecipeModel recipe,
  ) async {
    if (isFavorite(recipe.id)) {
      await removeFavorite(recipe.id);
    } else {
      await addFavorite(recipe);
    }
  }
}