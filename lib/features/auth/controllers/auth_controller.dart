import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../model/user_model.dart';
import '../repositories/auth_repository.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  // =========================================================
  // REPOSITORY
  // =========================================================

  final AuthRepository _authRepository = AuthRepository();

  // =========================================================
  // LOGIN CONTROLLERS
  // =========================================================

  final TextEditingController loginEmailController =
      TextEditingController();

  final TextEditingController loginPasswordController =
      TextEditingController();

  // =========================================================
  // SIGNUP CONTROLLERS
  // =========================================================

  final TextEditingController signupNameController =
      TextEditingController();

  final TextEditingController signupEmailController =
      TextEditingController();

  final TextEditingController signupPasswordController =
      TextEditingController();

  final TextEditingController signupConfirmPasswordController =
      TextEditingController();

  // =========================================================
  // FORGOT PASSWORD
  // =========================================================

  final TextEditingController forgotEmailController =
      TextEditingController();

  // =========================================================
  // OBSERVABLES
  // =========================================================

  final RxBool isPasswordVisible = false.obs;

  final RxBool isConfirmPasswordVisible = false.obs;

  final RxBool isLoading = false.obs;
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;

  // =========================================================
  // LOGIN
  // =========================================================

  Future<void> login() async {
    final String email =
        loginEmailController.text.trim();

    final String password =
        loginPasswordController.text;

    // ---------------------------------------------------------
    // VALIDATION
    // ---------------------------------------------------------

    if (email.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter your email.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter your password.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      print('==============================');
      print('LOGIN CONTROLLER');
      print('Email: $email');
      print('==============================');

      // -------------------------------------------------------
      // CALL REPOSITORY
      // -------------------------------------------------------

      final UserModel user =
          await _authRepository.login(
        email: email,
        password: password,
      );

      print('AUTH CURRENT USER AFTER LOGIN:');
      print(
        'UID: ${_authRepository.currentUser?.uid}',
      );
      print(
        'EMAIL: ${_authRepository.currentUser?.email}',
      );

      print('==============================');
      print('CONTROLLER RECEIVED USER');
      print('UID: ${user.uid}');
      print('NAME: ${user.name}');
      print('EMAIL: ${user.email}');
      print('==============================');

      // ✅ USERNAME SAVE کریں - LOGIN میں بھی
      userName.value = user.name.isEmpty ? 'User' : user.name;
      userEmail.value = user.email;

      final storage = GetStorage();
      await storage.write('userName', userName.value);
      await storage.write('userEmail', userEmail.value);
      await storage.write('isLoggedIn', true);

      // -------------------------------------------------------
      // LOGIN SUCCESS
      // -------------------------------------------------------

      Get.snackbar(
        'Login Successful',
        'Welcome back, ${user.name.isEmpty ? 'User' : user.name}!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      // -------------------------------------------------------
      // GO DIRECTLY TO HOME
      // -------------------------------------------------------

      Get.offAllNamed(
        AppRoutes.home,
      );

    } catch (e, stackTrace) {
      print('==============================');
      print('LOGIN CONTROLLER ERROR');
      print('ERROR: $e');
      print('STACK TRACE:');
      print(stackTrace);
      print('==============================');

      final String message =
          e.toString().replaceFirst(
                'Exception: ',
                '',
              );

      Get.snackbar(
        'Login Failed',
        message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 6),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================
  // SIGNUP
  // =========================================================

  Future<void> signup() async {
    final String name =
        signupNameController.text.trim();

    final String email =
        signupEmailController.text.trim();

    final String password =
        signupPasswordController.text;

    final String confirmPassword =
        signupConfirmPasswordController.text;

    // ---------------------------------------------------------
    // VALIDATION
    // ---------------------------------------------------------

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        'Required',
        'Please fill all fields.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        'Password Error',
        'Password must be at least 6 characters.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Password Error',
        'Passwords do not match.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    try {
      isLoading.value = true;

      print('==============================');
      print('SIGNUP CONTROLLER');
      print('Name: $name');
      print('Email: $email');
      print('==============================');

      // -------------------------------------------------------
      // ✅ CALL REPOSITORY - SIGNUP (نہ کہ LOGIN)
      // -------------------------------------------------------

      final UserModel user =
          await _authRepository.signup(
        name: name,
        email: email,
        password: password,
      );

      // ✅ USERNAME SAVE کریں
      userName.value = user.name.isEmpty ? 'User' : user.name;
      userEmail.value = user.email;

      final storage = GetStorage();

      await storage.write('userName', userName.value);
      await storage.write('userEmail', userEmail.value);
      await storage.write('isLoggedIn', true);

      print('==============================');
      print('SIGNUP USER RECEIVED');
      print('UID: ${user.uid}');
      print('NAME: ${user.name}');
      print('EMAIL: ${user.email}');
      print('Storage - Username: ${userName.value}');
      print('==============================');

      // -------------------------------------------------------
      // ACCOUNT CREATED SUCCESSFULLY
      // -------------------------------------------------------

      Get.snackbar(
        'Account Created',
        'Welcome to COOKmate, ${user.name.isEmpty ? 'User' : user.name}!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      // -------------------------------------------------------
      // CLEAR ALL FIELDS
      // -------------------------------------------------------

      signupNameController.clear();
      signupEmailController.clear();
      signupPasswordController.clear();
      signupConfirmPasswordController.clear();

      // -------------------------------------------------------
      // GO TO HOME
      // -------------------------------------------------------

      Get.offAllNamed(
        AppRoutes.home,
      );

    } catch (e, stackTrace) {
      print('==============================');
      print('SIGNUP CONTROLLER ERROR');
      print('ERROR: $e');
      print('STACK TRACE:');
      print(stackTrace);
      print('==============================');

      final String message =
          e.toString().replaceFirst(
                'Exception: ',
                '',
              );

      Get.snackbar(
        'Signup Failed',
        message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 7),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================
  // FORGOT PASSWORD
  // =========================================================

  Future<void> resetPassword() async {
    final String email =
        forgotEmailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter your email.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    try {
      isLoading.value = true;

      await _authRepository.resetPassword(
        email,
      );

      Get.snackbar(
        'Success',
        'Password reset link sent to your email.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      final String message =
          e.toString().replaceFirst(
                'Exception: ',
                '',
              );

      Get.snackbar(
        'Reset Failed',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  Future<void> logout() async {
    try {
      await _authRepository.logout();

      // ✅ Storage سے data clear کریں
      final storage = GetStorage();
      await storage.remove('userName');
      await storage.remove('userEmail');
      await storage.remove('isLoggedIn');

      userName.value = '';
      userEmail.value = '';

      Get.offAllNamed(
        AppRoutes.login,
      );

      Get.snackbar(
        'Logged Out',
        'You have been logged out successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      print('LOGOUT ERROR: $e');
      print(stackTrace);

      Get.snackbar(
        'Logout Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // =========================================================
  // NAVIGATION
  // =========================================================

  void goToSignup() {
    Get.toNamed(
      AppRoutes.signup,
    );
  }

  void goToLogin() {
    Get.offNamed(
      AppRoutes.login,
    );
  }

  void goToForgotPassword() {
    Get.toNamed(
      AppRoutes.forgotPassword,
    );
  }

  // =========================================================
  // PASSWORD VISIBILITY
  // =========================================================

  void togglePasswordVisibility() {
    isPasswordVisible.value =
        !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value =
        !isConfirmPasswordVisible.value;
  }

  // =========================================================
  // INIT - LOAD SAVED USER INFO
  // =========================================================

  @override
  void onInit() {
    super.onInit();

    final storage = GetStorage();

    final savedName = storage.read<String>('userName');
    final savedEmail = storage.read<String>('userEmail');

    if (savedName != null) {
      userName.value = savedName;
    }

    if (savedEmail != null) {
      userEmail.value = savedEmail;
    }

    print('==============================');
    print('AUTH CONTROLLER INIT');
    print('Saved Username: ${userName.value}');
    print('Saved Email: ${userEmail.value}');
    print('==============================');
  }

  // =========================================================
  // DISPOSE CONTROLLERS
  // =========================================================

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();

    signupNameController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    signupConfirmPasswordController.dispose();

    forgotEmailController.dispose();

    super.onClose();
  }
}