import 'dart:async';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final progress = 0.0.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startLoading();
  }

  void startLoading() {
    const totalSteps = 100;
    int currentStep = 0;

    _timer = Timer.periodic(
      const Duration(milliseconds: 40),
      (timer) {
        currentStep++;

        progress.value = currentStep / totalSteps;

        if (currentStep >= totalSteps) {
          timer.cancel();

          // Navigate to next screen
          Get.offNamed('/home');
        }
      },
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}