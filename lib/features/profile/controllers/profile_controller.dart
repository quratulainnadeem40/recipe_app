import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../auth/repositories/auth_repository.dart';
import '../../auth/model/user_model.dart';

class ProfileController extends GetxController {
  
  final AuthRepository _authRepository = AuthRepository();
  final GetStorage _storage = GetStorage();

  // =========================================================
  // USER
  // =========================================================

  final user = Rxn<UserModel>();

  // =========================================================
  // THEME
  // =========================================================
  final isNotificationsEnabled = true.obs;
  final isDarkMode = false.obs;
  // =========================================================
  // CHANGE PASSWORD
  // =========================================================

  final GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();

  final TextEditingController currentPasswordController =
      TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final isChangingPassword = false.obs;

  // =========================================================
  // INITIALIZATION
  // =========================================================

 @override
void onInit() {
  super.onInit();

  loadUser();

  isNotificationsEnabled.value =
      _storage.read('notifications_enabled') ?? true;
}

void toggleNotifications(bool value) {
  isNotificationsEnabled.value = value;

  _storage.write(
    'notifications_enabled',
    value,
  );
}
  // =========================================================
  // LOAD CURRENT USER
  // =========================================================

  Future<void> loadUser() async {
    final currentUser = _authRepository.currentUser;

    if (currentUser == null) {
      return;
    }

    user.value = UserModel(
      uid: currentUser.uid,
      name: currentUser.displayName ?? 'COOKmate User',
      email: currentUser.email ?? '',
    );
  }

  // =========================================================
  // DARK MODE
  // =========================================================

  void toggleTheme(bool value) {
    isDarkMode.value = value;

    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  // =========================================================
  // CHANGE PASSWORD
  // =========================================================

  Future<void> changePassword() async {
    // Validate form
    if (!(changePasswordFormKey.currentState?.validate() ?? false)) {
      return;
    }

    final String currentPassword = currentPasswordController.text.trim();

    final String newPassword = newPasswordController.text.trim();

    final String confirmPassword = confirmPasswordController.text.trim();

    // Extra password confirmation check
    if (newPassword != confirmPassword) {
      Get.snackbar(
        'Password Error',
        'New password and confirm password do not match.',
      );
      return;
    }

    if (currentPassword == newPassword) {
      Get.snackbar(
        'Password Error',
        'New password must be different from your current password.',
      );
      return;
    }

    try {
      isChangingPassword.value = true;

      await _authRepository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      // Clear password fields after successful change
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      // Go back to Account Settings
      Get.back();

      Get.snackbar(
        'Password Changed',
        'Your password has been changed successfully.',
      );
    } catch (e) {
      Get.snackbar(
        'Password Change Failed',
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isChangingPassword.value = false;
    }
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  Future<void> logout() async {
    final shouldLogout = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout != true) {
      return;
    }

    try {
      await _authRepository.logout();

      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        'Logout Failed',
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  // =========================================================
  // DELETE ACCOUNT
  // =========================================================

  Future<void> deleteAccount() async {
    final shouldDelete = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) {
      return;
    }

    try {
      await _authRepository.deleteAccount();

      Get.offAllNamed('/login');

      Get.snackbar(
        'Account Deleted',
        'Your account has been deleted successfully.',
      );
    } catch (e) {
      Get.snackbar(
        'Delete Failed',
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  // =========================================================
  // PRIVACY POLICY
  // =========================================================

  void openPrivacyPolicy() {
    // Privacy Policy screen will be added later.
  }

  // =========================================================
  // TERMS & CONDITIONS
  // =========================================================

  void openTermsAndConditions() {
    // Terms screen will be added later.
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}
