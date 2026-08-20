import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/core/theme/app_text_styles.dart';
import 'package:recipe_app/core/utils/validators.dart';
import 'package:recipe_app/core/widgets/custom_buttons.dart';
import 'package:recipe_app/core/widgets/custom_text_field.dart';
import 'package:recipe_app/features/auth/views/widgets/auth_header.dart';

import '../controllers/auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({
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

    // Icons remain clearly visible in both modes.
    final iconColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.primary;

    return Scaffold(
      backgroundColor: backgroundColor,

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 30,
          ),

          child: Form(
            key: formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // =================================================
                // LOGO
                // =================================================

                Center(
                  child: Container(
                    width: 76,
                    height: 76,

                    decoration: BoxDecoration(
                      color: AppColors.primary,

                      borderRadius:
                          BorderRadius.circular(24),

                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? AppColors.primary
                                  .withOpacity(0.30)
                              : AppColors.shadow,
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),

                    child: const Icon(
                      Icons.restaurant_menu_rounded,
                      color: AppColors.textWhite,
                      size: 40,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // =================================================
                // AUTH HEADER
                // =================================================

                const AuthHeader(
                  title: 'Welcome Back!',
                  subtitle:
                      'Login to continue cooking delicious meals.',
                ),

                const SizedBox(height: 35),

                // =================================================
                // EMAIL LABEL
                // =================================================

                Text(
                  'Email',

                  style:
                      AppTextStyles.labelMedium.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                // =================================================
                // EMAIL FIELD
                // =================================================

                CustomTextField(
                  controller:
                      controller.loginEmailController,

                  hintText: 'Enter your email',

                  prefixIcon:
                      Icons.email_outlined,

                  keyboardType:
                      TextInputType.emailAddress,

                  validator:
                      AuthValidators.email,
                ),

                const SizedBox(height: 18),

                // =================================================
                // PASSWORD LABEL
                // =================================================

                Text(
                  'Password',

                  style:
                      AppTextStyles.labelMedium.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                // =================================================
                // PASSWORD FIELD
                // =================================================

                Obx(
                  () => CustomTextField(
                    controller:
                        controller.loginPasswordController,

                    hintText:
                        'Enter your password',

                    prefixIcon:
                        Icons.lock_outline_rounded,

                    obscureText:
                        !controller
                            .isPasswordVisible
                            .value,

                    suffixIcon:
                        IconButton(
                      onPressed:
                          controller
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
                            ? Icons
                                .visibility_outlined
                            : Icons
                                .visibility_off_outlined,

                        // Clear in light + dark
                        color: iconColor,

                        size: 21,
                      ),
                    ),

                    validator:
                        AuthValidators.password,
                  ),
                ),

                const SizedBox(height: 8),

                // =================================================
                // FORGOT PASSWORD
                // =================================================

                Align(
                  alignment:
                      Alignment.centerRight,

                  child: TextButton(
                    onPressed:
                        controller
                            .goToForgotPassword,

                    style:
                        TextButton.styleFrom(
                      foregroundColor:
                          AppColors.primary,

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 6,
                      ),

                      minimumSize: Size.zero,

                      tapTargetSize:
                          MaterialTapTargetSize
                              .shrinkWrap,
                    ),

                    child: Text(
                      'Forgot Password?',

                      style:
                          AppTextStyles.primaryText
                              .copyWith(
                        color:
                            AppColors.primary,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // =================================================
                // LOGIN BUTTON
                // =================================================

                Obx(
                  () => CustomButton(
                    text: 'Login',

                    height: 52,

                    width: double.infinity,

                    isLoading:
                        controller
                            .isLoading
                            .value,

                    onPressed: () {
                      if (controller
                          .isLoading
                          .value) {
                        return;
                      }

                      if (formKey
                          .currentState!
                          .validate()) {
                        controller.login();
                      }
                    },
                  ),
                ),

                const SizedBox(height: 25),

                // =================================================
                // SIGN UP
                // =================================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    Flexible(
                      child: Text(
                        "Don't have an account?",

                        style: AppTextStyles
                            .bodyMedium
                            .copyWith(
                          color: textSecondary,
                        ),

                        textAlign:
                            TextAlign.center,
                      ),
                    ),

                    TextButton(
                      onPressed:
                          controller.goToSignup,

                      style:
                          TextButton.styleFrom(
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
                        'Sign Up',

                        style: AppTextStyles
                            .primaryText
                            .copyWith(
                          color:
                              AppColors.primary,
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