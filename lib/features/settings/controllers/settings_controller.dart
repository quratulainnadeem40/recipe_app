import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:recipe_app/core/services/image_picker_service.dart';
import 'package:recipe_app/core/services/storage_service.dart';
import 'package:recipe_app/features/favorites/controllers/favorites_controller.dart';
import 'package:recipe_app/features/home/controllers/home_controller.dart';
import '../models/user_model.dart';

class SettingsController extends GetxController {
  final GetStorage _storage = GetStorage();

  // =========================================================
  // USER / CHEF NAME
  // =========================================================

  final user = Rxn<UserModel>();
  final RxString chefName = 'COOKmate Chef'.obs;

  // =========================================================
  // PROFILE IMAGE
  // =========================================================

  final Rxn<Uint8List> profileImageBytes = Rxn<Uint8List>();

  // =========================================================
  // PREFERENCES
  // =========================================================

  final isNotificationsEnabled = true.obs;
  final isDarkMode = false.obs;

  // =========================================================
  // INITIALIZATION
  // =========================================================

  @override
  void onInit() {
    super.onInit();

    loadUser();
    loadProfileImage();

    isNotificationsEnabled.value =
        _storage.read('notifications_enabled') ?? true;
  }

  // =========================================================
  // NOTIFICATIONS
  // =========================================================

  void toggleNotifications(bool value) {
    isNotificationsEnabled.value = value;
    _storage.write('notifications_enabled', value);
  }

  // =========================================================
  // LOAD USER / CHEF
  // =========================================================

  Future<void> loadUser() async {
    final String name = _storage.read<String>('userName') ?? 'COOKmate Chef';
    chefName.value = name;

    user.value = UserModel(
      uid: 'local_user',
      name: name,
      email: '',
    );
  }

  Future<void> updateChefName(String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;

    await _storage.write('userName', trimmed);
    chefName.value = trimmed;
    await loadUser();

    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().loadUserName();
    }
  }

  // =========================================================
  // PICK PROFILE IMAGE
  // =========================================================

  Future<void> pickProfileImage() async {
    final Uint8List? imageBytes = await ImagePickerService.pickFromGallery();

    if (imageBytes == null) {
      return;
    }

    profileImageBytes.value = imageBytes;
    await StorageService.saveProfileImage(imageBytes);
  }

  // =========================================================
  // LOAD PROFILE IMAGE
  // =========================================================

  void loadProfileImage() {
    final List<int>? savedBytes = StorageService.profileImageBytes;

    if (savedBytes == null || savedBytes.isEmpty) {
      return;
    }

    profileImageBytes.value = Uint8List.fromList(savedBytes);
  }

  // =========================================================
  // REMOVE PROFILE IMAGE
  // =========================================================

  Future<void> removeProfileImage() async {
    profileImageBytes.value = null;
    await StorageService.removeProfileImage();
  }

  // =========================================================
  // DARK MODE
  // =========================================================

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    Get.changeThemeMode(
      value ? ThemeMode.dark : ThemeMode.light,
    );
  }

  // =========================================================
  // CLEAR FAVORITES
  // =========================================================

  Future<void> clearFavorites() async {
    final shouldClear = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Clear Favorites'),
        content: const Text(
          'Are you sure you want to remove all saved favorite recipes?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (shouldClear != true) return;

    if (Get.isRegistered<FavoritesController>()) {
      Get.find<FavoritesController>().clearFavorites();
    }

    Get.snackbar(
      'Favorites Cleared',
      'All favorite recipes have been removed.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // =========================================================
  // RESET ALL LOCAL DATA
  // =========================================================

  Future<void> resetLocalData() async {
    final shouldReset = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Reset All Data'),
        content: const Text(
          'This will clear all saved recipes, custom chef name, profile picture, and restore default app settings. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Reset Everything',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (shouldReset != true) {
      return;
    }

    try {
      if (Get.isRegistered<FavoritesController>()) {
        Get.find<FavoritesController>().clearFavorites();
      }

      await removeProfileImage();
      await _storage.erase();
      await _storage.write('userName', 'COOKmate Chef');
      await loadUser();

      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().loadUserName();
      }

      Get.snackbar(
        'App Reset Complete',
        'All settings and saved data have been restored to defaults.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Reset Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
