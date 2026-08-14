// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../core/routes/app_routes.dart';
// import '../repositories/auth_repository.dart';

// class AuthController extends GetxController {
//   // ==============================
//   // FIREBASE REPOSITORY
//   // ==============================

//   final AuthRepository _authRepository = AuthRepository();

//   // ==============================
//   // LOGIN CONTROLLERS
//   // ==============================

//   final loginEmailController = TextEditingController();

//   final loginPasswordController = TextEditingController();

//   // ==============================
//   // SIGNUP CONTROLLERS
//   // ==============================

//   final signupNameController = TextEditingController();

//   final signupEmailController = TextEditingController();

//   final signupPasswordController = TextEditingController();

//   final signupConfirmPasswordController =
//       TextEditingController();

//   // ==============================
//   // FORGOT PASSWORD CONTROLLER
//   // ==============================

//   final forgotEmailController = TextEditingController();

//   // ==============================
//   // OBSERVABLES
//   // ==============================

//   final RxBool isPasswordVisible = false.obs;

//   final RxBool isConfirmPasswordVisible = false.obs;

//   final RxBool isLoading = false.obs;

//   // =========================================================
//   // LOGIN
//   // =========================================================

//   Future<void> login() async {
//     // Validate email and password
//     if (loginEmailController.text.trim().isEmpty ||
//         loginPasswordController.text.isEmpty) {
//       Get.snackbar(
//         'Required',
//         'Please enter email and password.',
//         snackPosition: SnackPosition.BOTTOM,
//       );

//       return;
//     }

//     try {
//       // Start loading
//       isLoading.value = true;

//       // Login user
//       final user = await _authRepository.login(
//         email: loginEmailController.text.trim(),
//         password: loginPasswordController.text,
//       );

//       // Login successful
//       if (user != null) {
//         Get.snackbar(
//           'Login Successful',
//           'Welcome back, ${user.name}!',
//           snackPosition: SnackPosition.BOTTOM,
//         );

//         // Go to Home
//         Get.offAllNamed(
//           AppRoutes.home,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Login Failed',
//         e.toString().replaceFirst(
//               'Exception: ',
//               '',
//             ),
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       // Stop loading
//       isLoading.value = false;
//     }
//   }

//   // =========================================================
//   // SIGNUP
//   // =========================================================

//   Future<void> signup() async {
//     // ==============================
//     // CHECK EMPTY FIELDS
//     // ==============================

//     if (signupNameController.text.trim().isEmpty ||
//         signupEmailController.text.trim().isEmpty ||
//         signupPasswordController.text.isEmpty ||
//         signupConfirmPasswordController.text.isEmpty) {
//       Get.snackbar(
//         'Required',
//         'Please fill all fields.',
//         snackPosition: SnackPosition.BOTTOM,
//       );

//       return;
//     }

//     // ==============================
//     // CHECK PASSWORD LENGTH
//     // ==============================

//     if (signupPasswordController.text.length < 6) {
//       Get.snackbar(
//         'Password Error',
//         'Password must be at least 6 characters.',
//         snackPosition: SnackPosition.BOTTOM,
//       );

//       return;
//     }

//     // ==============================
//     // CHECK PASSWORD MATCH
//     // ==============================

//     if (signupPasswordController.text !=
//         signupConfirmPasswordController.text) {
//       Get.snackbar(
//         'Password Error',
//         'Passwords do not match.',
//         snackPosition: SnackPosition.BOTTOM,
//       );

//       return;
//     }

//     try {
//       // ==============================
//       // START LOADING
//       // ==============================

//       isLoading.value = true;

//       // ==============================
//       // CREATE ACCOUNT
//       // ==============================

//       final user = await _authRepository.signUp(
//         name: signupNameController.text.trim(),
//         email: signupEmailController.text.trim(),
//         password: signupPasswordController.text,
//       );

//       // ==============================
//       // SUCCESS
//       // ==============================

//       if (user != null) {
//         Get.snackbar(
//           'Account Created',
//           'Welcome to Cookmate, ${user.name}!',
//           snackPosition: SnackPosition.BOTTOM,
//         );

//         // Go to Home
//         Get.offAllNamed(
//           AppRoutes.home,
//         );
//       }
//     } catch (e) {
//       // ==============================
//       // ERROR
//       // ==============================

//       Get.snackbar(
//         'Signup Failed',
//         e.toString().replaceFirst(
//               'Exception: ',
//               '',
//             ),
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       // ==============================
//       // STOP LOADING
//       // ==============================

//       isLoading.value = false;
//     }
//   }

//   // =========================================================
//   // FORGOT PASSWORD
//   // =========================================================

//   Future<void> resetPassword() async {
//     // Check email
//     if (forgotEmailController.text.trim().isEmpty) {
//       Get.snackbar(
//         'Required',
//         'Please enter your email.',
//         snackPosition: SnackPosition.BOTTOM,
//       );

//       return;
//     }

//     try {
//       // Start loading
//       isLoading.value = true;

//       // Send reset email
//       await _authRepository.resetPassword(
//         forgotEmailController.text.trim(),
//       );

//       // Success
//       Get.snackbar(
//         'Success',
//         'Password reset link sent to your email.',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Reset Failed',
//         e.toString().replaceFirst(
//               'Exception: ',
//               '',
//             ),
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       // Stop loading
//       isLoading.value = false;
//     }
//   }

//   // =========================================================
//   // LOGOUT
//   // =========================================================

//   Future<void> logout() async {
//     try {
//       // Firebase logout
//       await _authRepository.logout();

//       // Go to login
//       Get.offAllNamed(
//         AppRoutes.login,
//       );

//       // Message
//       Get.snackbar(
//         'Logged Out',
//         'You have been logged out successfully.',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Logout Failed',
//         e.toString().replaceFirst(
//               'Exception: ',
//               '',
//             ),
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }

//   // =========================================================
//   // NAVIGATION
//   // =========================================================

//   void goToSignup() {
//     Get.toNamed(
//       AppRoutes.signup,
//     );
//   }

//   void goToLogin() {
//     Get.offNamed(
//       AppRoutes.login,
//     );
//   }

//   void goToForgotPassword() {
//     Get.toNamed(
//       AppRoutes.forgotPassword,
//     );
//   }

//   // =========================================================
//   // PASSWORD VISIBILITY
//   // =========================================================

//   void togglePasswordVisibility() {
//     isPasswordVisible.value =
//         !isPasswordVisible.value;
//   }

//   // =========================================================
//   // CONFIRM PASSWORD VISIBILITY
//   // =========================================================

//   void toggleConfirmPasswordVisibility() {
//     isConfirmPasswordVisible.value =
//         !isConfirmPasswordVisible.value;
//   }

//   // =========================================================
//   // DISPOSE CONTROLLERS
//   // =========================================================

//   @override
//   void onClose() {
//     // Login
//     loginEmailController.dispose();
//     loginPasswordController.dispose();

//     // Signup
//     signupNameController.dispose();
//     signupEmailController.dispose();
//     signupPasswordController.dispose();
//     signupConfirmPasswordController.dispose();

//     // Forgot password
//     forgotEmailController.dispose();

//     super.onClose();
//   }
// } 
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../repositories/auth_repository.dart';

class AuthController extends GetxController {
  // ============================================================
  // REPOSITORY
  // ============================================================

  final AuthRepository _authRepository =
      AuthRepository();

  // ============================================================
  // LOGIN
  // ============================================================

  final TextEditingController loginEmailController =
      TextEditingController();

  final TextEditingController loginPasswordController =
      TextEditingController();

  // ============================================================
  // SIGNUP
  // ============================================================

  final TextEditingController signupNameController =
      TextEditingController();

  final TextEditingController signupEmailController =
      TextEditingController();

  final TextEditingController signupPasswordController =
      TextEditingController();

  final TextEditingController
      signupConfirmPasswordController =
      TextEditingController();

  // ============================================================
  // FORGOT PASSWORD
  // ============================================================

  final TextEditingController forgotEmailController =
      TextEditingController();

  // ============================================================
  // OBSERVABLES
  // ============================================================

  final RxBool isPasswordVisible =
      false.obs;

  final RxBool isConfirmPasswordVisible =
      false.obs;

  final RxBool isLoading =
      false.obs;

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> login() async {
    final String email =
        loginEmailController.text.trim();

    final String password =
        loginPasswordController.text;

    if (email.isEmpty ||
        password.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter email and password.',
        snackPosition:
            SnackPosition.BOTTOM,
      );

      return;
    }

    try {
      isLoading.value = true;

      final user =
          await _authRepository.login(
        email: email,
        password: password,
      );

      if (user == null) {
        Get.snackbar(
          'Login Failed',
          'User information could not be loaded.',
          snackPosition:
              SnackPosition.BOTTOM,
        );

        return;
      }

      Get.snackbar(
        'Login Successful',
        user.name.isEmpty
            ? 'Welcome back!'
            : 'Welcome back, ${user.name}!',
        snackPosition:
            SnackPosition.BOTTOM,
        duration:
            const Duration(seconds: 3),
      );

      // Go to Home
      Get.offAllNamed(
        AppRoutes.home,
      );
    } catch (e) {
      final String message =
          e.toString().replaceFirst(
                'Exception: ',
                '',
              );

      Get.snackbar(
        'Login Failed',
        message,
        snackPosition:
            SnackPosition.BOTTOM,
        duration:
            const Duration(seconds: 7),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // SIGN UP
  // ============================================================

  Future<void> signup() async {
    final String name =
        signupNameController.text.trim();

    final String email =
        signupEmailController.text.trim();

    final String password =
        signupPasswordController.text;

    final String confirmPassword =
        signupConfirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        'Required',
        'Please fill all fields.',
        snackPosition:
            SnackPosition.BOTTOM,
      );

      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        'Password Error',
        'Password must be at least 6 characters.',
        snackPosition:
            SnackPosition.BOTTOM,
      );

      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Password Error',
        'Passwords do not match.',
        snackPosition:
            SnackPosition.BOTTOM,
      );

      return;
    }

    try {
      isLoading.value = true;

      final user =
          await _authRepository.signUp(
        name: name,
        email: email,
        password: password,
      );

      if (user != null) {
        Get.snackbar(
          'Account Created',
          'Verification email sent to ${user.email}',
          snackPosition:
              SnackPosition.BOTTOM,
          duration:
              const Duration(seconds: 5),
        );

        // IMPORTANT:
        // Do NOT go to Home.
        // Go to verification screen.
        Get.toNamed(
          AppRoutes.verifyEmail,
        );
      }
    } catch (e) {
      final String message =
          e.toString().replaceFirst(
                'Exception: ',
                '',
              );

      Get.snackbar(
        'Signup Failed',
        message,
        snackPosition:
            SnackPosition.BOTTOM,
        duration:
            const Duration(seconds: 7),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // RESEND VERIFICATION EMAIL
  // ============================================================

  Future<void> resendVerificationEmail() async {
    try {
      isLoading.value = true;

      await _authRepository
          .sendVerificationEmail();

      Get.snackbar(
        'Verification Email Sent',
        'A new verification link has been sent to your email.',
        snackPosition:
            SnackPosition.BOTTOM,
        duration:
            const Duration(seconds: 5),
      );
    } catch (e) {
      final String message =
          e.toString().replaceFirst(
                'Exception: ',
                '',
              );

      Get.snackbar(
        'Verification Failed',
        message,
        snackPosition:
            SnackPosition.BOTTOM,
        duration:
            const Duration(seconds: 7),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // CHECK VERIFICATION
  // ============================================================

  Future<void> checkVerification() async {
    try {
      isLoading.value = true;

      final bool verified =
          await _authRepository
              .checkEmailVerified();

      if (verified) {
        Get.snackbar(
          'Email Verified',
          'Your email has been verified successfully. You can now login.',
          snackPosition:
              SnackPosition.BOTTOM,
          duration:
              const Duration(seconds: 5),
        );

        // Sign out after verification.
        // User will login normally.
        await _authRepository.logout();

        Get.offAllNamed(
          AppRoutes.login,
        );
      } else {
        Get.snackbar(
          'Not Verified Yet',
          'Please open the verification email and click the verification link.',
          snackPosition:
              SnackPosition.BOTTOM,
          duration:
              const Duration(seconds: 6),
        );
      }
    } catch (e) {
      final String message =
          e.toString().replaceFirst(
                'Exception: ',
                '',
              );

      Get.snackbar(
        'Verification Check Failed',
        message,
        snackPosition:
            SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // RESET PASSWORD
  // ============================================================

  Future<void> resetPassword() async {
    final String email =
        forgotEmailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        'Required',
        'Please enter your email.',
        snackPosition:
            SnackPosition.BOTTOM,
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
        snackPosition:
            SnackPosition.BOTTOM,
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
        snackPosition:
            SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    try {
      await _authRepository.logout();

      Get.offAllNamed(
        AppRoutes.login,
      );

      Get.snackbar(
        'Logged Out',
        'You have been logged out successfully.',
        snackPosition:
            SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Logout Failed',
        e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
        snackPosition:
            SnackPosition.BOTTOM,
      );
    }
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

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

  // ============================================================
  // PASSWORD VISIBILITY
  // ============================================================

  void togglePasswordVisibility() {
    isPasswordVisible.value =
        !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value =
        !isConfirmPasswordVisible.value;
  }

  // ============================================================
  // DISPOSE
  // ============================================================

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