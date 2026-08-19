import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/core/utils/validators.dart';
import 'package:recipe_app/core/widgets/custom_buttons.dart';
import 'package:recipe_app/core/widgets/custom_text_field.dart';
import 'package:recipe_app/features/auth/views/widgets/auth_header.dart';

import '../../../core/theme/app_text_styles.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 30,
          ),

          child: Form(
            key: formKey,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // ==================================================
                // LOGO
                // ==================================================

                Center(
                  child: Container(
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius:
                          BorderRadius.circular(24),
                    ),

                    child: const Icon(
                      Icons.restaurant_menu,
                      color: AppColors.surface,
                      size: 40,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ==================================================
                // AUTH HEADER
                // ==================================================

                const AuthHeader(
                  title: 'Welcome Back!',
                  subtitle:
                      'Login to continue cooking delicious meals.',
                ),

                const SizedBox(height: 35),

                // ==================================================
                // EMAIL
                // ==================================================

                Text(
                  'Email',
                  style: AppTextStyles.labelMedium,
                ),

                const SizedBox(height: 8),

                CustomTextField(
                  controller:
                      controller.loginEmailController,
                  hintText: 'Enter your email',
                  prefixIcon:
                      Icons.email_outlined,
                  keyboardType:
                      TextInputType.emailAddress,
                  validator: AuthValidators.email,
                ),

                const SizedBox(height: 18),

                // ==================================================
                // PASSWORD
                // ==================================================

                Text(
                  'Password',
                  style: AppTextStyles.labelMedium,
                ),

                const SizedBox(height: 8),

                Obx(
                  () => CustomTextField(
                    controller:
                        controller.loginPasswordController,
                    hintText:
                        'Enter your password',
                    prefixIcon:
                        Icons.lock_outline,
                    obscureText:
                        !controller
                            .isPasswordVisible
                            .value,

                    suffixIcon: IconButton(
                      onPressed: controller
                          .togglePasswordVisibility,

                      icon: Icon(
                        controller
                                .isPasswordVisible
                                .value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),

                    validator:
                        AuthValidators.password,
                  ),
                ),

                const SizedBox(height: 10),

                // ==================================================
                // FORGOT PASSWORD
                // ==================================================

                Align(
                  alignment:
                      Alignment.centerRight,

                  child: TextButton(
                    onPressed: controller
                        .goToForgotPassword,

                    child: const Text(
                      'Forgot Password?',
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // ==================================================
                // LOGIN BUTTON
                // ==================================================

                Obx(
                  () => CustomButton(
                    text: 'Login',
                    height: 52,
                    width: double.infinity,
                    isLoading:
                        controller.isLoading.value,

                    onPressed: () {
                      if (formKey.currentState!
                          .validate()) {
                        controller.login();
                      }
                    },
                  ),
                ),

                const SizedBox(height: 25),

                // ==================================================
                // SIGNUP
                // ==================================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    Text(
                      "Don't have an account?",
                      style:
                          AppTextStyles.bodyMedium,
                    ),

                    TextButton(
                      onPressed:
                          controller.goToSignup,

                      child: const Text(
                        'Sign Up',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}