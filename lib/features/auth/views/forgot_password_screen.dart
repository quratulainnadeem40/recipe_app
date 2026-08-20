import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/core/theme/app_text_styles.dart';
import 'package:recipe_app/core/widgets/custom_buttons.dart';
import 'package:recipe_app/core/widgets/custom_text_field.dart';
import 'package:recipe_app/features/auth/views/widgets/auth_header.dart';

import '../controllers/auth_controller.dart';

class ForgotPasswordScreen extends GetView<AuthController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // =========================================================
    // THEME COLORS
    // =========================================================

    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.background;

    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final actionColor = isDark
        ? AppColors.primaryLight
        : AppColors.primary;

    return Scaffold(
      backgroundColor: backgroundColor,

      // =======================================================
      // APP BAR
      // =======================================================

      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,

        title: Text(
          'Forgot Password',
          style: AppTextStyles.headingMedium.copyWith(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // =======================================================
      // BODY
      // =======================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),

          child: Form(
            key: formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // =================================================
                // AUTH HEADER
                // =================================================

                const AuthHeader(
                  icon: Icons.lock_reset_rounded,
                  title: 'Reset Your Password',
                  subtitle:
                      'Enter your email and we will send you a password reset link.',
                ),

                const SizedBox(height: 35),

                // =================================================
                // EMAIL LABEL
                // =================================================

                Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    'Email',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // =================================================
                // EMAIL FIELD
                // =================================================

                CustomTextField(
                  controller: controller.forgotEmailController,
                  hintText: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,

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

                // =================================================
                // SEND RESET LINK
                // =================================================

                Obx(
                  () => CustomButton(
                    text: 'Send Reset Link',
                    width: double.infinity,
                    height: 52,
                    isLoading: controller.isLoading.value,

                    onPressed: () {
                      if (controller.isLoading.value) {
                        return;
                      }

                      if (formKey.currentState!.validate()) {
                        controller.resetPassword();
                      }
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // =================================================
                // BACK TO LOGIN
                // =================================================

                TextButton(
                  onPressed: controller.goToLogin,

                  style: TextButton.styleFrom(
                    foregroundColor: actionColor,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),

                    minimumSize: Size.zero,

                    tapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                  ),

                  child: Text(
                    'Back to Login',

                    style: AppTextStyles.primaryText.copyWith(
                      color: actionColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}