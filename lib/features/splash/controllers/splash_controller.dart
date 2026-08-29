import 'dart:async';
import 'package:get/get.dart';
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

          // Navigate directly to Home
          Get.offNamed(AppRoutes.home);
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