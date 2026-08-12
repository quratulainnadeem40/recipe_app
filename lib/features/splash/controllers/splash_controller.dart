import 'dart:async';

import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();

    startSplash();
  }

  void startSplash() {

    Timer(
      const Duration(seconds: 2),

      () {
        Get.offNamed(
          AppRoutes.onboarding,
        );
      },
      
    );
  }
}