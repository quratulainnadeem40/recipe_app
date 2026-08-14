import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../models/onboarding_model.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();

  final RxInt currentPage = 0.obs;

  final List<OnboardingModel> onboardingPages = const [
    OnboardingModel(
      image: 'assets/imagefolder/image1.png',
      title: 'Discover Delicious Recipes',
      description:
          'Explore delicious recipes and discover new meals to make every day.',
    ),

    OnboardingModel(
      image: 'assets/imagefolder/image2.png',
      title: 'Cook With Confidence',
      description:
          'Follow simple recipes with easy steps and create meals you will love.',
    ),

    OnboardingModel(
      image: 'assets/imagefolder/image3.png',
      title: 'Share Your Favorite Recipes',
      description:
          'Save your favorite recipes and share your cooking inspiration with others.',
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