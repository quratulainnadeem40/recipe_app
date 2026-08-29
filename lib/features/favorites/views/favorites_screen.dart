import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/routes/app_routes.dart';
import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/core/theme/app_text_styles.dart';
import 'package:recipe_app/features/favorites/controllers/favorites_controller.dart';
import 'package:recipe_app/features/favorites/views/widgets/favorite_recipe_card.dart';
import 'package:recipe_app/features/navigation/controllers/navigation_controller.dart';

class FavoritesScreen extends GetView<FavoritesController> {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor =
        isDark ? AppColors.darkBackground : AppColors.background;

    final primaryTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    final secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Saved Favorites',
          style: AppTextStyles.headingMedium.copyWith(
            color: primaryTextColor,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: primaryTextColor),
      ),
      body: SafeArea(
        child: Obx(() {
          // =====================================================
          // EMPTY FAVORITES
          // =====================================================
          if (controller.favorites.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon with background glow
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.favorite_border_rounded,
                          size: 54,
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'No Favorite Recipes Yet',
                      style: AppTextStyles.headingMedium.copyWith(
                        color: primaryTextColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 21,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Explore delicious dishes and tap the heart icon\nto save your favorites for quick cooking.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: secondaryTextColor,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 28),

                    // Explore Recipes CTA Button
                    ElevatedButton.icon(
                      onPressed: () {
                        if (Get.isRegistered<NavigationController>()) {
                          Get.find<NavigationController>().changePage(0);
                        } else {
                          Get.toNamed(AppRoutes.home);
                        }
                      },
                      icon: const Icon(
                        Icons.explore_rounded,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Explore Recipes',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: AppColors.primary.withValues(alpha: 0.4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // =====================================================
          // RESPONSIVE FAVORITES GRID
          // =====================================================
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount =
                  width < 720 ? 1 : (width < 1150 ? 2 : 3);

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: width < 600 ? 16 : 24,
                      vertical: 16,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 128,
                    ),
                    itemCount: controller.favorites.length,
                    itemBuilder: (context, index) {
                      final recipe = controller.favorites[index];


                      return FavoriteRecipeCard(
                        recipe: recipe,
                        onRemove: () {
                          controller.removeFavorite(recipe.id);
                        },
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.recipeDetails,
                            arguments: recipe.id,
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
