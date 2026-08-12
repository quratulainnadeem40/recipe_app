import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';

class AuthController extends GetxController {
  // Login
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Signup
  final signupNameController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final signupConfirmPasswordController =
      TextEditingController();

  // Forgot Password
  final forgotEmailController = TextEditingController();

  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  final RxBool isLoading = false.obs;

  // ==============================
  // LOGIN
  // ==============================

  void login() {
    if (loginEmailController.text.isEmpty ||
        loginPasswordController.text.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter email and password.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    // Firebase authentication yahan baad mein add hogi.

    Get.offAllNamed(
      AppRoutes.home,
    );
  }

  // ==============================
  // SIGNUP
  // ==============================

  void signup() {
    if (signupNameController.text.isEmpty ||
        signupEmailController.text.isEmpty ||
        signupPasswordController.text.isEmpty ||
        signupConfirmPasswordController.text.isEmpty) {
      Get.snackbar(
        'Required',
        'Please fill all fields.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    if (signupPasswordController.text !=
        signupConfirmPasswordController.text) {
      Get.snackbar(
        'Password Error',
        'Passwords do not match.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    // Firebase signup baad mein add hoga.

    Get.offAllNamed(
      AppRoutes.home,
    );
  }

  // ==============================
  // FORGOT PASSWORD
  // ==============================

  void resetPassword() {
    if (forgotEmailController.text.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter your email.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    Get.snackbar(
      'Success',
      'Password reset link sent to your email.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ==============================
  // NAVIGATION
  // ==============================

  void goToSignup() {
    Get.toNamed(AppRoutes.signup);
  }

  void goToLogin() {
    Get.offNamed(AppRoutes.login);
  }

  void goToForgotPassword() {
    Get.toNamed(AppRoutes.forgotPassword);
  }

  // ==============================
  // PASSWORD VISIBILITY
  // ==============================

  void togglePasswordVisibility() {
    isPasswordVisible.value =
        !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value =
        !isConfirmPasswordVisible.value;
  }

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