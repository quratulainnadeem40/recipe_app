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

    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final textHint = isDark
        ? AppColors.darkTextHint
        : AppColors.textHint;

    final iconColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.primary;

    final borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.border;

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
            // Heading color
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
                // =================================================
                // AUTH HEADER
                // =================================================

                AuthHeader(
                  title: 'Join Cookmate',
                  subtitle:
                      'Create your account and start cooking.',
                ),

                const SizedBox(height: 30),

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

                const SizedBox(height: 8),

                CustomTextField(
                  controller:
                      controller.signupNameController,

                  hintText: 'Enter your name',

                  prefixIcon:
                      Icons.person_outline_rounded,

                  keyboardType: TextInputType.name,

                  validator: AuthValidators.name,
                ),

                const SizedBox(height: 18),

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

                const SizedBox(height: 8),

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

                const SizedBox(height: 18),

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

                const SizedBox(height: 8),

                Obx(
                  () => CustomTextField(
                    controller:
                        controller.signupPasswordController,

                    hintText: 'Create password',

                    prefixIcon:
                        Icons.lock_outline_rounded,

                    obscureText:
                        !controller
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
                            : Icons
                                .visibility_off_outlined,

                        // Clearly visible in both themes
                        color: iconColor,

                        size: 21,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

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
                            : Icons
                                .visibility_off_outlined,

                        color: iconColor,

                        size: 21,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

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

                      if (formKey.currentState!
                          .validate()) {
                        controller.signup();
                      }
                    },
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

                        style: AppTextStyles.bodyMedium
                            .copyWith(
                          color: textSecondary,
                        ),

                        textAlign: TextAlign.center,
                      ),
                    ),

                    TextButton(
                      onPressed:
                          controller.goToLogin,

                      style: TextButton.styleFrom(
                        foregroundColor:
                            AppColors.primary,

                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 6,
                        ),

                        minimumSize: Size.zero,

                        tapTargetSize:
                            MaterialTapTargetSize
                                .shrinkWrap,
                      ),

                      child: Text(
                        'Login',

                        style: AppTextStyles.primaryText
                            .copyWith(
                          color: AppColors.primary,
                          fontWeight:
                              FontWeight.w700,
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