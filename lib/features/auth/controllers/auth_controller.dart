import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../model/user_model.dart';
import '../repositories/auth_repository.dart';

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
      );print('AUTH CURRENT USER AFTER LOGIN:');
print('UID: ${_authRepository.currentUser?.uid}');
print('EMAIL: ${_authRepository.currentUser?.email}');

      print('==============================');
      print('CONTROLLER RECEIVED USER');
      print('UID: ${user.uid}');
      print('NAME: ${user.name}');
      print('EMAIL: ${user.email}');
      print('==============================');

      // -------------------------------------------------------
      // LOGIN SUCCESS
      // -------------------------------------------------------

      print('Showing success message...');

      Get.snackbar(
        'Login Successful',
        'Welcome back, ${user.name.isEmpty ? 'User' : user.name}!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      print('Success message displayed.');

      // -------------------------------------------------------
      // HOME NAVIGATION
      // -------------------------------------------------------

      print('==============================');
      print('GOING TO HOME');
      print('ROUTE: ${AppRoutes.home}');
      print('==============================');

      Get.offAllNamed(
        AppRoutes.home,
      );

      print('HOME NAVIGATION CALLED');
      print('LOGIN FLOW COMPLETED');
      print('==============================');
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
      // CALL REPOSITORY
      // -------------------------------------------------------

      final UserModel user =
          await _authRepository.signUp(
        name: name,
        email: email,
        password: password,
      );

      print('==============================');
      print('SIGNUP USER RECEIVED');
      print('UID: ${user.uid}');
      print('NAME: ${user.name}');
      print('EMAIL: ${user.email}');
      print('==============================');

      // -------------------------------------------------------
      // SUCCESS
      // -------------------------------------------------------

      Get.snackbar(
        'Account Created',
        'Your account has been created successfully.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      print('Signup success message displayed.');

      // NO EMAIL VERIFICATION
      // Directly go to LOGIN

      print('Going to Login screen...');

      Get.offAllNamed(
        AppRoutes.login,
      );

      print('Signup navigation completed.');
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
  // DISPOSE CONTROLLERS
  // =========================================================

  
  }
