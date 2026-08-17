
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../controllers/navigation_controller.dart';

import '../../home/views/home_screen.dart';
import '../../search/views/search_screen.dart' hide SearchController;
import '../../favorites/views/favorites_screen.dart';
import '../../profile/views/profile_screen.dart';

class MainNavigation extends GetView<NavigationController> {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeScreen(),
       const SearchScreen  (),
      const FavoritesScreen(),
      const ProfileScreen(),
    ];

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: controller.currentIndex.value,
          onItemSelected: controller.changePage,
        ),
      ),
    );
  }
}

