// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/app_text_styles.dart';

// import '../controllers/auth_controller.dart';

// class LoginScreen extends GetView<AuthController> {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.lightBackground,

//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 24,
//             vertical: 30,
//           ),

//           child: Column(
//             crossAxisAlignment:
//                 CrossAxisAlignment.start,

//             children: [
//               // Logo / Icon

//               Center(
//                 child: Container(
                 

//                   decoration: BoxDecoration(
//                     color: AppColors.primary,
//                     borderRadius:
//                         BorderRadius.circular(24),
//                   ),

//                   child: const Icon(
//                     Icons.restaurant_menu,
//                     color: AppColors.white,
//                     size: 40,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 30),

//               Center(
//                 child: Text(
//                   'Welcome Back!',
//                   style:
//                       AppTextStyles.headingLarge.copyWith(
//                     color: AppColors.primary,
//                     fontSize: 28,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 8),

//               Center(
//                 child: Text(
//                   'Login to continue cooking delicious meals.',
//                   textAlign: TextAlign.center,
//                   style:
//                       AppTextStyles.bodyMedium.copyWith(
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 35),

//               // Email

//               Text(
//                 'Email',
//                 style: AppTextStyles.labelMedium,
//               ),

//               const SizedBox(height: 8),

//               TextField(
//                 controller:
//                     controller.loginEmailController,

//                 keyboardType:
//                     TextInputType.emailAddress,

//                 decoration: const InputDecoration(
//                   hintText: 'Enter your email',
//                   prefixIcon: Icon(Icons.email_outlined),
//                 ),
//               ),

//               const SizedBox(height: 18),

//               // Password

//               Text(
//                 'Password',
//                 style: AppTextStyles.labelMedium,
//               ),

//               const SizedBox(height: 8),

//               Obx(
//                 () => TextField(
//                   controller:
//                       controller.loginPasswordController,

//                   obscureText:
//                       !controller.isPasswordVisible.value,

//                   decoration: InputDecoration(
//                     hintText: 'Enter your password',

//                     prefixIcon:
//                         const Icon(Icons.lock_outline),

//                     suffixIcon: IconButton(
//                       onPressed:
//                           controller
//                               .togglePasswordVisibility,

//                       icon: Icon(
//                         controller
//                                 .isPasswordVisible
//                                 .value
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 10),

//               Align(
//                 alignment: Alignment.centerRight,

//                 child: TextButton(
//                   onPressed:
//                       controller.goToForgotPassword,

//                   child: const Text(
//                     'Forgot Password?',
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 15),

//               // Login Button

//               SizedBox(
//                 width: double.infinity,
//                 height: 52,

//                 child: ElevatedButton(
//                   onPressed: controller.login,

//                   child: const Text(
//                     'Login',
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 25),

//               // Signup

//               Row(
//                 mainAxisAlignment:
//                     MainAxisAlignment.center,

//                 children: [
//                   Text(
//                     "Don't have an account?",
//                     style:
//                         AppTextStyles.bodyMedium,
//                   ),

//                   TextButton(
//                     onPressed:
//                         controller.goToSignup,

//                     child: const Text(
//                       'Sign Up',
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.lightBackground,

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 30,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              // ==================================================
              // LOGO
              // ==================================================

              Center(
                child: Container(
                  padding:
                      const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius:
                        BorderRadius.circular(24),
                  ),

                  child: const Icon(
                    Icons.restaurant_menu,
                    color: AppColors.white,
                    size: 40,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ==================================================
              // TITLE
              // ==================================================

              Center(
                child: Text(
                  'Welcome Back!',
                  style:
                      AppTextStyles.headingLarge
                          .copyWith(
                    color: AppColors.primary,
                    fontSize: 28,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  'Login to continue cooking delicious meals.',
                  textAlign:
                      TextAlign.center,
                  style:
                      AppTextStyles.bodyMedium
                          .copyWith(
                    color:
                        AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // ==================================================
              // EMAIL
              // ==================================================

              Text(
                'Email',
                style:
                    AppTextStyles.labelMedium,
              ),

              const SizedBox(height: 8),

              TextField(
                controller:
                    controller
                        .loginEmailController,

                keyboardType:
                    TextInputType.emailAddress,

                decoration:
                    const InputDecoration(
                  hintText:
                      'Enter your email',

                  prefixIcon:
                      Icon(
                    Icons.email_outlined,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ==================================================
              // PASSWORD
              // ==================================================

              Text(
                'Password',
                style:
                    AppTextStyles.labelMedium,
              ),

              const SizedBox(height: 8),

              Obx(
                () => TextField(
                  controller:
                      controller
                          .loginPasswordController,

                  obscureText:
                      !controller
                          .isPasswordVisible
                          .value,

                  decoration:
                      InputDecoration(
                    hintText:
                        'Enter your password',

                    prefixIcon:
                        const Icon(
                      Icons.lock_outline,
                    ),

                    suffixIcon:
                        IconButton(
                      onPressed:
                          controller
                              .togglePasswordVisibility,

                      icon: Icon(
                        controller
                                .isPasswordVisible
                                .value
                            ? Icons.visibility
                            : Icons
                                .visibility_off,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ==================================================
              // FORGOT PASSWORD
              // ==================================================

              Align(
                alignment:
                    Alignment.centerRight,

                child: TextButton(
                  onPressed:
                      controller
                          .goToForgotPassword,

                  child: const Text(
                    'Forgot Password?',
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // ==================================================
              // LOGIN BUTTON
              // ==================================================

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
                                .login,

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
                            'Login',
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // SIGNUP
              // ==================================================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  Text(
                    "Don't have an account?",
                    style:
                        AppTextStyles.bodyMedium,
                  ),

                  TextButton(
                    onPressed:
                        controller.goToSignup,

                    child: const Text(
                      'Sign Up',
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