import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/utils/validators.dart';
import 'package:recipe_app/core/widgets/custom_buttons.dart';
import 'package:recipe_app/core/widgets/custom_text_field.dart';
import 'package:recipe_app/features/auth/views/widgets/auth_header.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/auth_controller.dart';

class SignupScreen extends GetView<AuthController> {
  const SignupScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Create Account',
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),

          child: Form(
            key: formKey,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // ==================================================
                // AUTH HEADER
                // ==================================================

                const AuthHeader(
                  title: 'Join Cookmate',
                  subtitle:
                      'Create your account and start cooking.',
                ),

                const SizedBox(height: 30),

                // ==================================================
                // NAME
                // ==================================================

                Text(
                  'Full Name',
                  style: AppTextStyles.labelMedium,
                ),

                const SizedBox(height: 8),

                CustomTextField(
                  controller:
                      controller.signupNameController,
                  hintText: 'Enter your name',
                  prefixIcon: Icons.person_outline,
                  validator: AuthValidators.name,
                ),

                const SizedBox(height: 18),

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
                      controller.signupEmailController,
                  hintText: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
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
                        controller.signupPasswordController,
                    hintText: 'Create password',
                    prefixIcon: Icons.lock_outline,
                    obscureText:
                        !controller
                            .isPasswordVisible
                            .value,
                    validator:
                        AuthValidators.password,
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
                  ),
                ),

                const SizedBox(height: 18),

                // ==================================================
                // CONFIRM PASSWORD
                // ==================================================

                Text(
                  'Confirm Password',
                  style:
                      AppTextStyles.labelMedium,
                ),

                const SizedBox(height: 8),

                Obx(
                  () => CustomTextField(
                    controller: controller
                        .signupConfirmPasswordController,
                    hintText:
                        'Confirm your password',
                    prefixIcon:
                        Icons.lock_outline,
                    obscureText:
                        !controller
                            .isConfirmPasswordVisible
                            .value,
                    validator: (value) {
                      return AuthValidators
                          .confirmPassword(
                        value,
                        controller
                            .signupPasswordController
                            .text,
                      );
                    },
                    suffixIcon: IconButton(
                      onPressed: controller
                          .toggleConfirmPasswordVisibility,
                      icon: Icon(
                        controller
                                .isConfirmPasswordVisible
                                .value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ==================================================
                // CREATE ACCOUNT BUTTON
                // ==================================================

                Obx(
                  () => CustomButton(
                    text: 'Create Account',
                    height: 52,
                    width: double.infinity,
                    isLoading:
                        controller.isLoading.value,
                    onPressed: () {
                      if (formKey.currentState!
                          .validate()) {
                        controller.signup();
                      }
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // LOGIN
                // ==================================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    const Text(
                      'Already have an account?',
                    ),

                    TextButton(
                      onPressed:
                          controller.goToLogin,
                      child: const Text(
                        'Login',
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