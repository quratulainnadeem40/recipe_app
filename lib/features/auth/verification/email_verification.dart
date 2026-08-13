import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/auth_controller.dart';

class VerifyEmailScreen
    extends GetView<AuthController> {
  const VerifyEmailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.lightBackground,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Verify Email',
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              const Icon(
                Icons.mark_email_read_outlined,
                size: 90,
                color: AppColors.primary,
              ),

              const SizedBox(height: 30),

              Text(
                'Verify Your Email',
                textAlign:
                    TextAlign.center,
                style:
                    AppTextStyles.headingLarge
                        .copyWith(
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                'We have sent a verification link to your email address. Please open your email and click the verification link.',
                textAlign:
                    TextAlign.center,
                style:
                    AppTextStyles.bodyMedium
                        .copyWith(
                  color:
                      AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 35),

              // =================================================
              // CHECK VERIFICATION
              // =================================================

              SizedBox(
                width: double.infinity,
                height: 52,

                child: Obx(
                  () => ElevatedButton(
                    onPressed:
                        controller
                                .isLoading
                                .value
                            ? null
                            : controller
                                .checkVerification,

                    child: controller
                            .isLoading
                            .value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'I Have Verified My Email',
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // =================================================
              // RESEND
              // =================================================

              TextButton(
                onPressed:
                    controller
                            .isLoading
                            .value
                        ? null
                        : controller
                            .resendVerificationEmail,

                child: const Text(
                  'Resend Verification Email',
                ),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed:
                    controller.goToLogin,

                child: const Text(
                  'Back to Login',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}