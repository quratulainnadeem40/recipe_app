import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:recipe_app/core/services/image_picker_service.dart';
import 'package:recipe_app/core/services/storage_service.dart';
import 'package:recipe_app/features/favorites/controllers/favorites_controller.dart';
import 'package:recipe_app/features/home/controllers/home_controller.dart';
import '../models/user_model.dart';

class ProfileController extends GetxController {
  final GetStorage _storage = GetStorage();

  // =========================================================
  // USER
  // =========================================================

  final user = Rxn<UserModel>();

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
  // LOAD USER
  // =========================================================

  Future<void> loadUser() async {
    final String name = _storage.read<String>('userName') ?? 'COOKmate Chef';
    final String email = _storage.read<String>('userEmail') ?? 'cookmate@app.com';

    user.value = UserModel(
      uid: 'local_user',
      name: name,
      email: email,
    );
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
  // RESET LOCAL DATA
  // =========================================================

  Future<void> resetLocalData() async {
    final shouldReset = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Reset App Data'),
        content: const Text(
          'Are you sure you want to clear your saved favorites and local settings?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Reset',
              style: TextStyle(color: Colors.red),
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
      await _storage.write('userName', 'COOKmate Chef');
      await loadUser();

      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().loadUserName();
      }

      Get.snackbar(
        'Data Reset',
        'Your local app data has been reset successfully.',
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