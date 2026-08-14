import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final isDarkMode = false.obs;

  void toggleTheme(bool value) {
    isDarkMode.value = value;

    Get.changeThemeMode(
      value ? ThemeMode.dark : ThemeMode.light,
    );
  }

  void logout() {
    // Firebase logout will be added later.
    Get.offAllNamed('/login');
  }

  void deleteAccount() {
    // Firebase account deletion will be added later.
  }

  void openPrivacyPolicy() {
    // We'll add the Privacy Policy screen later.
  }

  void openTermsAndConditions() {
    // We'll add the Terms screen later.
  }
}