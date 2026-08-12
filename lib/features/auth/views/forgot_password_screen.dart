import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

import '../controllers/auth_controller.dart';

class ForgotPasswordScreen
    extends GetView<AuthController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.lightBackground,

      appBar: AppBar(
        title: const Text(
          'Forgot Password',
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            children: [
              const SizedBox(height: 40),

              Icon(
                Icons.lock_reset,
                size: 80,
                color: AppColors.primary,
              ),

              const SizedBox(height: 25),

              Text(
                'Reset Your Password',
                style:
                    AppTextStyles.headingLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Enter your email and we will send you a password reset link.',
                textAlign: TextAlign.center,
                style:
                    AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 35),

              TextField(
                controller:
                    controller.forgotEmailController,

                keyboardType:
                    TextInputType.emailAddress,

                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon:
                      Icon(Icons.email_outlined),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton(
                  onPressed:
                      controller.resetPassword,

                  child: const Text(
                    'Send Reset Link',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}