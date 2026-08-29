import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selectedColor =
        isDark ? AppColors.surface : AppColors.primary;

    final unselectedColor = isDark
        ? AppColors.textSecondary
        : const Color(0xFFB58EAC);

   final backgroundColor =
    isDark ? AppColors.darkBackground : AppColors.surface;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onItemSelected,

      type: BottomNavigationBarType.fixed,

      backgroundColor: backgroundColor,

      selectedItemColor: selectedColor,

      unselectedItemColor: unselectedColor,

      selectedLabelStyle: TextStyle(
        color: selectedColor,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),

      unselectedLabelStyle: TextStyle(
        color: unselectedColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),

      elevation: 0,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home_rounded),
          label: 'Home',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          activeIcon: Icon(Icons.search_rounded),
          label: 'Search',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border_rounded),
          activeIcon: Icon(Icons.favorite_rounded),
          label: 'Favorites',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings_rounded),
          label: 'Settings',
        ),
      ],
    );
  }
}