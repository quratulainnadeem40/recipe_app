
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/profile_controller.dart';

class ChangePasswordScreen extends GetView<ProfileController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Change Password',
          style: AppTextStyles.headingMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: controller.changePasswordFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =====================================================
                // HEADER
                // =====================================================

                Text(
                  'Update your password',
                  style: AppTextStyles.headingSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Enter your current password and choose a new password.',
                  style: AppTextStyles.bodyMedium,
                ),

                const SizedBox(height: 28),

                // =====================================================
                // CURRENT PASSWORD
                // =====================================================

                TextFormField(
                  controller: controller.currentPasswordController,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Current Password',
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your current password';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // =====================================================
                // NEW PASSWORD
                // =====================================================

                TextFormField(
                  controller: controller.newPasswordController,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a new password';
                    }

                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // =====================================================
                // CONFIRM PASSWORD
                // =====================================================

                TextFormField(
                  controller: controller.confirmPasswordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Confirm New Password',
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please confirm your new password';
                    }

                    if (value !=
                        controller.newPasswordController.text) {
                      return 'Passwords do not match';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // =====================================================
                // CHANGE PASSWORD BUTTON
                // =====================================================

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed:
                          controller.isChangingPassword.value
                              ? null
                              : controller.changePassword,
                      child:
                          controller.isChangingPassword.value
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Change Password',
                                ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // =====================================================
                // PASSWORD REQUIREMENT
                // =====================================================

                Center(
                  child: Text(
                    'Password must contain at least 6 characters.',
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
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