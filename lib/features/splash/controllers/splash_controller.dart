import 'dart:async';

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/routes/app_routes.dart';

class SplashController extends GetxController {
  final progress = 0.0.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();

    startLoading();
  }

  void startLoading() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 50),
      (timer) {
        progress.value += 0.02;

        if (progress.value >= 1.0) {
          progress.value = 1.0;

          timer.cancel();

          // Loading complete
          checkUserSession();
        }
      },
    );
  }

  // ==========================================
  // CHECK USER SESSION
  // ==========================================

 void checkUserSession() {
  final User? user = FirebaseAuth.instance.currentUser;

  print('==============================');
  print('SPLASH SESSION CHECK');
  print('USER: ${user?.email}');
  print('UID: ${user?.uid}');
  print('==============================');

  if (user != null) {
    Get.offNamed(AppRoutes.home);
  } else {
    Get.offNamed(AppRoutes.onboarding);
  }
}
  @override
  void onClose() {
    _timer?.cancel();

    super.onClose();
  }
}