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

    final iconColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.primary;

    return Scaffold(
      backgroundColor: backgroundColor,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,

        title: Text(
          'Create Account',
          style: AppTextStyles.headingMedium.copyWith(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.asset("assets/images/logo.png",
                height: 100,
                width: 100,)
                ),
                SizedBox(height: 18,),
                // =================================================
                // AUTH HEADER
                // =================================================

                AuthHeader(
                  title: 'Join Cookmate',
                  subtitle:
                      'Create your account and start cooking.',
                ),

                const SizedBox(height: 20),

                // =================================================
                // FULL NAME
                // =================================================

                Text(
                  'Full Name',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height:16),

                CustomTextField(
                  controller:
                      controller.signupNameController,
                  hintText: 'Enter your name',
                  prefixIcon:
                      Icons.person_outline_rounded,
                  keyboardType: TextInputType.name,
                  validator: AuthValidators.name,
                ),

                const SizedBox(height: 16),

                // =================================================
                // EMAIL
                // =================================================

                Text(
                  'Email',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                CustomTextField(
                  controller:
                      controller.signupEmailController,
                  hintText: 'Enter your email',
                  prefixIcon:
                      Icons.email_outlined,
                  keyboardType:
                      TextInputType.emailAddress,
                  validator: AuthValidators.email,
                ),

                const SizedBox(height: 16),

                // =================================================
                // PASSWORD
                // =================================================

                Text(
                  'Password',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Obx(
                  () => CustomTextField(
                    controller:
                        controller.signupPasswordController,
                    hintText: 'Create password',
                    prefixIcon:
                        Icons.lock_outline_rounded,
                    obscureText: !controller
                        .isPasswordVisible
                        .value,
                    validator:
                        AuthValidators.password,
                    suffixIcon: IconButton(
                      onPressed: controller
                          .togglePasswordVisibility,
                      tooltip: controller
                              .isPasswordVisible
                              .value
                          ? 'Hide password'
                          : 'Show password',
                      icon: Icon(
                        controller
                                .isPasswordVisible
                                .value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: iconColor,
                        size: 21,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // =================================================
                // CONFIRM PASSWORD
                // =================================================

                Text(
                  'Confirm Password',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Obx(
                  () => CustomTextField(
                    controller: controller
                        .signupConfirmPasswordController,
                    hintText:
                        'Confirm your password',
                    prefixIcon:
                        Icons.lock_outline_rounded,
                    obscureText: !controller
                        .isConfirmPasswordVisible
                        .value,
                    validator: (value) {
                      return AuthValidators.confirmPassword(
                        value,
                        controller
                            .signupPasswordController
                            .text,
                      );
                    },
                    suffixIcon: IconButton(
                      onPressed: controller
                          .toggleConfirmPasswordVisibility,
                      tooltip: controller
                              .isConfirmPasswordVisible
                              .value
                          ? 'Hide password'
                          : 'Show password',
                      icon: Icon(
                        controller
                                .isConfirmPasswordVisible
                                .value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: iconColor,
                        size: 21,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 26),

                // =================================================
                // CREATE ACCOUNT BUTTON
                // =================================================

                Obx(
                  () => CustomButton(
                    text: 'Create Account',
                    height: 52,
                    width: double.infinity,
                    isLoading:
                        controller.isLoading.value,
                    onPressed: () {
                      if (controller.isLoading.value) {
                        return;
                      }

                      if (formKey.currentState!.validate()) {
                        controller.signup();
                      }
                    },
                  ),
                ),

                const SizedBox(height: 20),

// =================================================
// OR DIVIDER
// =================================================

Row(
  children: [
    Expanded(
      child: Divider(
        color: textSecondary.withOpacity(0.3),
        thickness: 1,
      ),
    ),

    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        'OR',
        style: AppTextStyles.bodySmall.copyWith(
          color: textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    Expanded(
      child: Divider(
        color: textSecondary.withOpacity(0.3),
        thickness: 1,
      ),
    ),
  ],
),

const SizedBox(height: 20),

// =================================================
// CONTINUE WITH GOOGLE
// =================================================

Obx(
  () => OutlinedButton(
    onPressed: controller.isLoading.value
        ? null
        : controller.signInWithGoogle,
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(
        double.infinity,
        52,
      ),
      side: BorderSide(
        color: textSecondary.withOpacity(0.35),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: isDark
          ? Colors.transparent
          : Colors.white,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/google_logo.png',
          height: 22,
          width: 22,
        ),

        const SizedBox(width: 12),

        Text(
          'Continue with Google',
          style: AppTextStyles.bodyMedium.copyWith(
            color: textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  ),
),

const SizedBox(height: 20),


                // =================================================
                // LOGIN
                // =================================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        'Already have an account?',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    TextButton(
                      onPressed: controller.goToLogin,
                      style: TextButton.styleFrom(
                        foregroundColor:
                            AppColors.primary,
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 6,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Login',
                        style: AppTextStyles.primaryText.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
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