import 'package:get/get.dart';

class NavigationController extends GetxController {
  final selectedIndex = 0.obs;

  // Explore/Search navigation information
  final exploreType = ''.obs;
  final exploreArea = ''.obs;
  final exploreCategory = ''.obs;
  final exploreQuery = ''.obs;

  // Normal bottom navigation
  void changePage(int index) {
    selectedIndex.value = index;
  }

  // Open Explore tab with specific content
  void openExplore({
    String type = '',
    String area = '',
    String category = '',
    String query = '',
  }) {
    exploreType.value = type;
    exploreArea.value = area;
    exploreCategory.value = category;
    exploreQuery.value = query;

    // Explore is index 1
    selectedIndex.value = 1;
  }
}