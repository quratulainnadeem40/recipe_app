import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../models/onboarding_model.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();

  final RxInt currentPage = 0.obs;

  final List<OnboardingModel> onboardingPages = const [
    OnboardingModel(
      image: 'assets/images/image1.png',
      title: '',
      description:
          '',
    ),

    OnboardingModel(
      image: 'assets/images/image2.png',
      title: '',
      description:
          '',
    ),

    OnboardingModel(
      image: 'assets/images/image3.jpeg',
      title: '',
      description:
          '',
    ),
  ];

  void changePage(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      goToLogin();
    }
  }

  void skip() {
    goToLogin();
  }

  void goToLogin() {
    Get.offNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}