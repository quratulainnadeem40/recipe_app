import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/repositories/auth_repository.dart';
import 'package:recipe_app/features/profile/controllers/profile_controller.dart';
import 'package:get_storage/get_storage.dart';

class EditProfileController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final GetStorage _storage = GetStorage();

  // ==========================================
  // FORM
  // ==========================================

  final nameController = TextEditingController();

  final isLoading = false.obs;

  // ==========================================
  // INITIALIZE USER DATA
  // ==========================================

  @override
  void onInit() {
    super.onInit();

    final user = _authRepository.currentUser;

    nameController.text = user?.displayName ?? '';
  }

  // ==========================================
  // UPDATE PROFILE - ✅ UPDATED
  // ==========================================

  Future<void> updateProfile() async {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      Get.snackbar(
        'Name Required',
        'Please enter your name.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final user = _authRepository.currentUser;

      if (user == null) {
        throw Exception('No user is currently signed in.');
      }

      // ✅ صحیح method - uid دے رہے ہیں
      await _authRepository.updateUserProfile(
        uid: user.uid,
        name: name,
      );

      // Firebase کو update کریں
      await user.updateDisplayName(name);

      // ProfileController reload کریں
      final profileController = Get.find<ProfileController>();
      await profileController.loadUser();

      // Storage میں بھی update کریں
      await _storage.write('userName', name);

      Get.snackbar(
        'Profile Updated',
        'Your name has been updated successfully.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Update Failed',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}