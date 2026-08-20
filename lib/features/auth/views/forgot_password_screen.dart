import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/core/widgets/custom_buttons.dart';
import 'package:recipe_app/core/widgets/custom_text_field.dart';
import 'package:recipe_app/features/auth/views/widgets/auth_header.dart';

import '../../../core/theme/app_text_styles.dart';
import '../controllers/auth_controller.dart';

class ForgotPasswordScreen extends GetView<AuthController> {
  const ForgotPasswordScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        title: const Text(
          'Forgot Password',
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Form(
            key: formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                // ==================================================
                // AUTH HEADER
                // ==================================================

                const AuthHeader(
                  icon: Icons.lock_reset,
                  title: 'Reset Your Password',
                  subtitle:
                      'Enter your email and we will send you a password reset link.',
                ),

                const SizedBox(height: 35),

                // ==================================================
                // EMAIL LABEL
                // ==================================================

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: AppTextStyles.labelMedium,
                  ),
                ),

                const SizedBox(height: 8),

                // ==================================================
                // EMAIL FIELD
                // ==================================================

                CustomTextField(
                  controller:
                      controller.forgotEmailController,

                  hintText: 'Enter your email',

                  prefixIcon:
                      Icons.email_outlined,

                  keyboardType:
                      TextInputType.emailAddress,

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter your email';
                    }

                    if (!GetUtils.isEmail(
                      value.trim(),
                    )) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 25),

                // ==================================================
                // SEND RESET LINK
                // ==================================================

                Obx(
                  () => CustomButton(
                    text: 'Send Reset Link',
                    width: double.infinity,
                    height: 52,
                    isLoading:
                        controller.isLoading.value,

                    onPressed: () {
                      if (formKey.currentState!
                          .validate()) {
                        controller.resetPassword();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}