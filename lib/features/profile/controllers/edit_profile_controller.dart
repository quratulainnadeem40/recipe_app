import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/repositories/auth_repository.dart';
import 'package:recipe_app/features/profile/controllers/profile_controller.dart';

class EditProfileController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

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
  // UPDATE NAME
  // ==========================================

  Future<void> updateProfile() async {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      Get.snackbar('Name Required', 'Please enter your name.');
      return;
    }

    try {
      isLoading.value = true;

      final user = _authRepository.currentUser;

      if (user == null) {
        throw Exception('No user is currently signed in.');
      }

      // Update Firebase Authentication name
     await _authRepository.updateProfile(
  name: name,
);

final profileController = Get.find<ProfileController>();
await profileController.loadUser();

Get.back();

Get.snackbar(
  'Profile Updated',
  'Your name has been updated successfully.',
);

      Get.back();

      Get.snackbar(
        'Profile Updated',
        'Your name has been updated successfully.',
      );
    } catch (e) {
      Get.snackbar(
        'Update Failed',
        e.toString().replaceFirst('Exception: ', ''),
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
