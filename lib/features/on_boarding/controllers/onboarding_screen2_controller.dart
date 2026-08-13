import 'package:get/get.dart';

class OnboardingScreen2Controller extends GetxController {
  // ==========================================
  // Skip Onboarding → Home
  // ==========================================

  void skipOnboarding() {
    Get.offAllNamed('/home');
  }

  // ==========================================
  // Get Started → Home
  // ==========================================

  void getStarted() {
    Get.offAllNamed('/home');
  }

  // ==========================================
  // Back → Onboarding 1
  // ==========================================

  void goBack() {
    Get.back();
  }
}