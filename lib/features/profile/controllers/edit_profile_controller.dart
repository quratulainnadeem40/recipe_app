import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recipe_app/features/home/controllers/home_controller.dart';
import 'package:recipe_app/features/profile/controllers/profile_controller.dart';

class EditProfileController extends GetxController {
  final GetStorage _storage = GetStorage();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    final String savedName = _storage.read<String>('userName') ?? 'COOKmate Chef';
    final String savedEmail = _storage.read<String>('userEmail') ?? 'cookmate@app.com';

    nameController.text = savedName;
    emailController.text = savedEmail;
  }

  Future<void> updateProfile() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();

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

      await _storage.write('userName', name);
      if (email.isNotEmpty) {
        await _storage.write('userEmail', email);
      }

      // Sync ProfileController
      if (Get.isRegistered<ProfileController>()) {
        final profileController = Get.find<ProfileController>();
        await profileController.loadUser();
      }

      // Sync HomeController
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().loadUserName();
      }

      Get.snackbar(
        'Profile Updated',
        'Your profile has been updated successfully.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Update Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}