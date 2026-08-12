import 'package:get/get.dart';

class OnboardingController extends GetxController {
  // ==========================================
  // Onboarding 1 → Onboarding 2
  // ==========================================

  void nextPage() {
    Get.toNamed('/onboarding2');
  }

  // ==========================================
  // Skip → Home
  // ==========================================

  void skipOnboarding() {
    Get.offAllNamed('/home');
  }

  // ==========================================
  // Onboarding 2 → Home
  // ==========================================

  void finishOnboarding() {
    Get.offAllNamed('/home');
  }
}