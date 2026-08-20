import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/profile_controller.dart';

class ChangePasswordScreen extends GetView<ProfileController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // =========================================================
    // THEME
    // =========================================================

    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    // =========================================================
    // COLORS
    // =========================================================

    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.background;

    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final primaryTextColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.border;

    final iconColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    // =========================================================
    // SCREEN
    // =========================================================

    return Scaffold(
      backgroundColor: backgroundColor,

      // =======================================================
      // APP BAR
      // =======================================================

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,

        backgroundColor: backgroundColor,

        surfaceTintColor: Colors.transparent,

        iconTheme: IconThemeData(
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.primary,
        ),

        title: Text(
          'Change Password',

          style: AppTextStyles.headingMedium.copyWith(
            color: primaryTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // =======================================================
      // BODY
      // =======================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Form(
            key: controller.changePasswordFormKey,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // =================================================
                // HEADER
                // =================================================

                Text(
                  'Update your password',

                  style: AppTextStyles.headingSmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Enter your current password and choose a new password.',

                  style: AppTextStyles.bodyMedium.copyWith(
                    color: secondaryTextColor,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 28),

                // =================================================
                // CURRENT PASSWORD
                // =================================================

                TextFormField(
                  controller:
                      controller.currentPasswordController,

                  obscureText: true,

                  textInputAction:
                      TextInputAction.next,

                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 14,
                  ),

                  cursorColor:
                      AppColors.primary,

                  decoration: InputDecoration(
                    labelText: 'Current Password',

                    labelStyle: TextStyle(
                      color: secondaryTextColor,
                    ),

                    floatingLabelStyle:
                        const TextStyle(
                      color: AppColors.primary,
                    ),

                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: iconColor,
                    ),

                    filled: true,
                    fillColor: surfaceColor,

                    contentPadding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),

                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: borderColor,
                      ),
                    ),

                    enabledBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: borderColor,
                      ),
                    ),

                    focusedBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide:
                          const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),

                    errorBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: AppColors.error,
                      ),
                    ),

                    focusedErrorBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: AppColors.error,
                        width: 1.5,
                      ),
                    ),

                    errorStyle: TextStyle(
                      color: AppColors.error,
                      fontSize: 11,
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter your current password';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // =================================================
                // NEW PASSWORD
                // =================================================

                TextFormField(
                  controller:
                      controller.newPasswordController,

                  obscureText: true,

                  textInputAction:
                      TextInputAction.next,

                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 14,
                  ),

                  cursorColor:
                      AppColors.primary,

                  decoration: InputDecoration(
                    labelText: 'New Password',

                    labelStyle: TextStyle(
                      color: secondaryTextColor,
                    ),

                    floatingLabelStyle:
                        const TextStyle(
                      color: AppColors.primary,
                    ),

                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: iconColor,
                    ),

                    filled: true,
                    fillColor: surfaceColor,

                    contentPadding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),

                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: borderColor,
                      ),
                    ),

                    enabledBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: borderColor,
                      ),
                    ),

                    focusedBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide:
                          const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),

                    errorBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: AppColors.error,
                      ),
                    ),

                    focusedErrorBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: AppColors.error,
                        width: 1.5,
                      ),
                    ),

                    errorStyle: TextStyle(
                      color: AppColors.error,
                      fontSize: 11,
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter a new password';
                    }

                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // =================================================
                // CONFIRM PASSWORD
                // =================================================

                TextFormField(
                  controller:
                      controller.confirmPasswordController,

                  obscureText: true,

                  textInputAction:
                      TextInputAction.done,

                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 14,
                  ),

                  cursorColor:
                      AppColors.primary,

                  decoration: InputDecoration(
                    labelText:
                        'Confirm New Password',

                    labelStyle: TextStyle(
                      color: secondaryTextColor,
                    ),

                    floatingLabelStyle:
                        const TextStyle(
                      color: AppColors.primary,
                    ),

                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: iconColor,
                    ),

                    filled: true,
                    fillColor: surfaceColor,

                    contentPadding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),

                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: borderColor,
                      ),
                    ),

                    enabledBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: borderColor,
                      ),
                    ),

                    focusedBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide:
                          const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),

                    errorBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: AppColors.error,
                      ),
                    ),

                    focusedErrorBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: AppColors.error,
                        width: 1.5,
                      ),
                    ),

                    errorStyle: TextStyle(
                      color: AppColors.error,
                      fontSize: 11,
                    ),
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please confirm your new password';
                    }

                    if (value !=
                        controller
                            .newPasswordController
                            .text) {
                      return 'Passwords do not match';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // =================================================
                // CHANGE PASSWORD BUTTON
                // =================================================

                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: Obx(
                    () => ElevatedButton(
                      onPressed:
                          controller
                                  .isChangingPassword
                                  .value
                              ? null
                              : controller
                                  .changePassword,

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.primary,

                        foregroundColor:
                            AppColors.textWhite,

                        disabledBackgroundColor:
                            AppColors.primary
                                .withValues(
                          alpha: 0.55,
                        ),

                        disabledForegroundColor:
                            AppColors.textWhite
                                .withValues(
                          alpha: 0.8,
                        ),

                        elevation: 0,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            28,
                          ),
                        ),
                      ),

                      child:
                          controller
                                  .isChangingPassword
                                  .value
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,

                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color:
                                        AppColors.textWhite,
                                  ),
                                )
                              : Text(
                                  'Change Password',

                                  style:
                                      AppTextStyles
                                          .button
                                          .copyWith(
                                    color:
                                        AppColors.textWhite,
                                    fontWeight:
                                        FontWeight.w700,
                                  ),
                                ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // =================================================
                // PASSWORD REQUIREMENT
                // =================================================

                Center(
                  child: Text(
                    'Password must contain at least 6 characters.',

                    style:
                        AppTextStyles.bodySmall.copyWith(
                      color: secondaryTextColor,
                      height: 1.4,
                    ),

                    textAlign:
                        TextAlign.center,
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