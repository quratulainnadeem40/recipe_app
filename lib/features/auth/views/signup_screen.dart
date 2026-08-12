import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

import '../controllers/auth_controller.dart';

class SignupScreen extends GetView<AuthController> {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,

      appBar: AppBar(
        backgroundColor:
            AppColors.lightBackground,

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

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Center(
                child: Text(
                  'Join Cookmate',
                  style:
                      AppTextStyles.headingLarge.copyWith(
                    color: AppColors.primary,
                    fontSize: 28,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  'Create your account and start cooking.',
                  textAlign: TextAlign.center,
                  style:
                      AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Name

              Text(
                'Full Name',
                style: AppTextStyles.labelMedium,
              ),

              const SizedBox(height: 8),

              TextField(
                controller:
                    controller.signupNameController,

                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                  prefixIcon:
                      Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 18),

              // Email

              Text(
                'Email',
                style: AppTextStyles.labelMedium,
              ),

              const SizedBox(height: 8),

              TextField(
                controller:
                    controller.signupEmailController,

                keyboardType:
                    TextInputType.emailAddress,

                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon:
                      Icon(Icons.email_outlined),
                ),
              ),

              const SizedBox(height: 18),

              // Password

              Text(
                'Password',
                style: AppTextStyles.labelMedium,
              ),

              const SizedBox(height: 8),

              Obx(
                () => TextField(
                  controller:
                      controller.signupPasswordController,

                  obscureText:
                      !controller.isPasswordVisible.value,

                  decoration: InputDecoration(
                    hintText: 'Create password',

                    prefixIcon:
                        const Icon(Icons.lock_outline),

                    suffixIcon: IconButton(
                      onPressed:
                          controller
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
              ),

              const SizedBox(height: 18),

              // Confirm Password

              Text(
                'Confirm Password',
                style: AppTextStyles.labelMedium,
              ),

              const SizedBox(height: 8),

              Obx(
                () => TextField(
                  controller:
                      controller
                          .signupConfirmPasswordController,

                  obscureText:
                      !controller
                          .isConfirmPasswordVisible
                          .value,

                  decoration: InputDecoration(
                    hintText:
                        'Confirm your password',

                    prefixIcon:
                        const Icon(Icons.lock_outline),

                    suffixIcon: IconButton(
                      onPressed:
                          controller
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
              ),

              const SizedBox(height: 30),

              // Signup Button

              SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton(
                  onPressed:
                      controller.signup,

                  child: const Text(
                    'Create Account',
                  ),
                ),
              ),

              const SizedBox(height: 20),

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
    );
  }
}