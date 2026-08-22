import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:recipe_app/core/services/image_picker_service.dart';
import 'package:recipe_app/core/services/storage_service.dart';

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
  // PROFILE IMAGE
  // =========================================================

  final Rxn<Uint8List> profileImageBytes =
      Rxn<Uint8List>();

  // =========================================================
  // THEME
  // =========================================================

  final isNotificationsEnabled = true.obs;
  final isDarkMode = false.obs;

  // =========================================================
  // CHANGE PASSWORD
  // =========================================================

  final GlobalKey<FormState> changePasswordFormKey =
      GlobalKey<FormState>();

  final TextEditingController currentPasswordController =
      TextEditingController();

  final TextEditingController newPasswordController =
      TextEditingController();

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
    loadProfileImage();

    isNotificationsEnabled.value =
        _storage.read('notifications_enabled') ?? true;
  }

  // =========================================================
  // NOTIFICATIONS
  // =========================================================

  void toggleNotifications(bool value) {
    isNotificationsEnabled.value = value;

    _storage.write(
      'notifications_enabled',
      value,
    );
  }

  // =========================================================
  // LOAD USER
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
  // PICK PROFILE IMAGE
  // =========================================================

  Future<void> pickProfileImage() async {
    final Uint8List? imageBytes =
        await ImagePickerService.pickFromGallery();

    if (imageBytes == null) {
      return;
    }

    profileImageBytes.value = imageBytes;

    await StorageService.saveProfileImage(
      imageBytes,
    );
  }

  // =========================================================
  // LOAD PROFILE IMAGE
  // =========================================================

  void loadProfileImage() {
    final List<int>? savedBytes =
        StorageService.profileImageBytes;

    if (savedBytes == null || savedBytes.isEmpty) {
      return;
    }

    profileImageBytes.value =
        Uint8List.fromList(savedBytes);
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
  // CHANGE PASSWORD - ✅ UPDATED
  // =========================================================

  Future<void> changePassword() async {
    if (!(changePasswordFormKey.currentState?.validate() ??
        false)) {
      return;
    }

    final String currentPassword =
        currentPasswordController.text.trim();

    final String newPassword =
        newPasswordController.text.trim();

    final String confirmPassword =
        confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      Get.snackbar(
        'Password Error',
        'New password and confirm password do not match.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (currentPassword == newPassword) {
      Get.snackbar(
        'Password Error',
        'New password must be different from your current password.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isChangingPassword.value = true;

      // ✅ Firebase میں براہ راست password تبدیل کریں
      final firebaseUser = _authRepository.currentUser;

      if (firebaseUser == null) {
        throw Exception('User not authenticated');
      }

      // پہلے موجودہ password سے دوبارہ authenticate کریں
      final credential = EmailAuthProvider.credential(
        email: firebaseUser.email!,
        password: currentPassword,
      );

      await firebaseUser.reauthenticateWithCredential(credential);

      // اب نیا password set کریں
      await firebaseUser.updatePassword(newPassword);

      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      Get.back();

      Get.snackbar(
        'Password Changed',
        'Your password has been changed successfully.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Password Change Failed',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
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
        content: const Text(
          'Are you sure you want to logout?',
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
        e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // =========================================================
  // DELETE ACCOUNT - ✅ UPDATED
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
      final uid = _authRepository.currentUser?.uid;

      if (uid == null) {
        throw Exception('User not authenticated');
      }

      // ✅ uid parameter دے رہے ہیں
      await _authRepository.deleteAccount(uid);

      await StorageService.clearUserData();

      // Storage سے user data بھی clear کریں
      final storage = GetStorage();
      await storage.remove('userName');
      await storage.remove('userEmail');
      await storage.remove('isLoggedIn');

      Get.offAllNamed('/login');

      Get.snackbar(
        'Account Deleted',
        'Your account has been deleted successfully.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Delete Failed',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    }
  }

  // =========================================================
  // PRIVACY POLICY
  // =========================================================

  void openPrivacyPolicy() {
    // Privacy policy کھولنے کے لیے logic
  }

  // =========================================================
  // TERMS & CONDITIONS
  // =========================================================

  void openTermsAndConditions() {
    // Terms & conditions کھولنے کے لیے logic
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