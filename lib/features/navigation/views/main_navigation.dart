// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../core/widgets/custom_bottom_nav_bar.dart';
// import '../../favorites/views/favorites_screen.dart';
// import '../../home/views/home_screen.dart';
// import '../../profile/views/profile_screen.dart';
// import '../../search/views/search_screen.dart' hide SearchController;
// import '../controllers/navigation_controller.dart';

// class MainNavigation extends GetView<NavigationController> {
//   const MainNavigation({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Scaffold(
//         body: IndexedStack(
//           index: controller.currentIndex.value,
//           children: const [
//             HomeScreen(),
//             SearchScreen(searchQuery: '',),
//             FavoritesScreen(),
//             ProfileScreen(),
//           ],
//         ),
//         bottomNavigationBar: CustomBottomNavBar(
//           currentIndex: controller.currentIndex.value,
//           onItemSelected: controller.changePage,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/core/widgets/custom_bottom_nav_bar.dart';

// Controllers and Screens Imports
import '../controllers/navigation_controller.dart';
import '../../home/views/home_screen.dart';
import '../../search/views/search_screen.dart'; // Adjust path according to your structure
import '../../favorites/views/favorites_screen.dart'; // Adjust path
import '../../profile/views/profile_screen.dart'; // Adjust path// Adjust path

class MainNavigation extends GetView<NavigationController> {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: const [
            HomeScreen(),
            SearchScreen(),
            FavoritesScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: controller.selectedIndex.value,
          onItemSelected: controller.changePage,
        ),
      ),
    );
  }
}