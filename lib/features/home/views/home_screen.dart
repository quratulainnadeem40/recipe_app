import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/routes/app_routes.dart';
import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/home/controllers/home_controller.dart';
import 'package:recipe_app/features/home/data/country_data.dart';
import 'package:recipe_app/features/home/views/widgets/category_item.dart';
import 'package:recipe_app/features/home/views/widgets/country_item.dart';
import 'package:recipe_app/features/home/views/widgets/home_header.dart';
import 'package:recipe_app/features/home/views/widgets/home_searchbar.dart';
import 'package:recipe_app/features/home/views/widgets/recipe_horizontal_list.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor =
        isDark ? AppColors.darkBackground : AppColors.background;
    final textPrimary =
        isDark ? AppColors.textWhite : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textHint : AppColors.textSecondary;

    final categories = <Map<String, dynamic>>[
      {'title': 'Breakfast', 'icon': Icons.free_breakfast_rounded},
      {'title': 'Main Course', 'icon': Icons.dinner_dining_rounded},
      {'title': 'Desserts', 'icon': Icons.cake_rounded},
      {'title': 'Snacks', 'icon': Icons.fastfood_rounded},
      {'title': 'Salads', 'icon': Icons.ramen_dining_rounded},
    ];

    final popularSearches = [
      'Chicken',
      'Biryani',
      'Pasta',
      'Cake',
      'Pizza',
      'Soup'
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return _buildError(
              context,
              textPrimary,
              textSecondary,
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: controller.getRecipes,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =====================================================
                  // 1. TOP HEADER (COOKmate Logo, Greeting, Notification)
                  // =====================================================
                  HomeHeader(
                    onNotificationTap: () {
                      Get.toNamed(AppRoutes.notifications);
                    },
                  ),

                  const SizedBox(height: 16),

                  // =====================================================
                  // 2. SEARCH BAR
                  // =====================================================
                  HomeSearchBar(
                    controller: controller.searchTextController,
                    onChanged: controller.onSearchTextChanged,
                    onSearchTap: () {
                      Get.toNamed(AppRoutes.search);
                    },
                  ),

                  const SizedBox(height: 24),

                  // =====================================================
                  // 3. EXPLORE BY CUISINE / COUNTRY
                  // =====================================================
                  _buildSectionHeader(
                    title: 'Explore by Cuisine',
                    textPrimary: textPrimary,
                    onSeeAll: () => Get.toNamed(AppRoutes.search),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    height: 85,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: CountryData.countries.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final country = CountryData.countries[index];
                        final isSelected =
                            controller.selectedCountry.value == country.area;

                        return CountryItem(
                          country: country,
                          isSelected: isSelected,
                          onTap: () {
                            controller.getRecipesByCountry(country.area);
                            Get.toNamed(
                              AppRoutes.search,
                              arguments: country.area,
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =====================================================
                  // 4. CATEGORIES
                  // =====================================================
                  _buildSectionHeader(
                    title: 'Categories',
                    textPrimary: textPrimary,
                    onSeeAll: () => Get.toNamed(AppRoutes.search),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: categories.map((category) {
                      return CategoryItem(
                        title: category['title'],
                        icon: category['icon'],
                        onTap: () {
                          controller.getRecipesByCategory(category['title']);
                          Get.toNamed(
                            AppRoutes.search,
                            arguments: {'category': category['title']},
                          );
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // =====================================================
                  // 5. POPULAR SEARCHES
                  // =====================================================
                  Text(
                    'Popular Searches',
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: popularSearches
                          .map((tag) => Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ActionChip(
                                  label: Text(
                                    tag,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  backgroundColor: AppColors.chipBackground,
                                  side: BorderSide.none,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  onPressed: () {
                                    Get.toNamed(
                                      AppRoutes.search,
                                      arguments: {'query': tag},
                                    );
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =====================================================
                  // 6. TRENDING RECIPES
                  // =====================================================
                  _buildSectionHeader(
                    title: 'Trending Recipes 🔥',
                    textPrimary: textPrimary,
                    onSeeAll: () => Get.toNamed(AppRoutes.search),
                  ),

                  const SizedBox(height: 12),

                  RecipeHorizontalList(
                    recipes: controller.recipes,
                    onRecipeTap: (recipe) {
                      Get.toNamed(
                        AppRoutes.recipeDetails,
                        arguments: recipe.id,
                      );
                    },
                  ),

                  // =====================================================
                  // 7. SELECTED CATEGORY RECIPES (CONDITIONAL)
                  // =====================================================
                  Obx(() {
                    if (controller.isCategoryLoading.value) {
                      return _buildLoading();
                    }

                    if (controller.categoryRecipes.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        _buildSectionHeader(
                          title: '${controller.selectedCategory.value} Recipes',
                          textPrimary: textPrimary,
                          onSeeAll: () {
                            Get.toNamed(
                              AppRoutes.search,
                              arguments: {
                                'category': controller.selectedCategory.value,
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        RecipeHorizontalList(
                          recipes: controller.categoryRecipes,
                          onRecipeTap: (recipe) {
                            Get.toNamed(
                              AppRoutes.recipeDetails,
                              arguments: recipe.id,
                            );
                          },
                        ),
                      ],
                    );
                  }),

                  // =====================================================
                  // 8. SELECTED COUNTRY RECIPES (CONDITIONAL)
                  // =====================================================
                  Obx(() {
                    if (controller.isCountryLoading.value) {
                      return _buildLoading();
                    }

                    if (controller.countryRecipes.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        _buildSectionHeader(
                          title: '${controller.selectedCountry.value} Recipes',
                          textPrimary: textPrimary,
                          onSeeAll: () {
                            Get.toNamed(
                              AppRoutes.search,
                              arguments: controller.selectedCountry.value,
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        RecipeHorizontalList(
                          recipes: controller.countryRecipes,
                          onRecipeTap: (recipe) {
                            Get.toNamed(
                              AppRoutes.recipeDetails,
                              arguments: recipe.id,
                            );
                          },
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // =============================================================
  // SECTION HEADER
  // =============================================================
  Widget _buildSectionHeader({
    required String title,
    required Color textPrimary,
    required VoidCallback onSeeAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.2,
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: const Text(
            'See all',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // =============================================================
  // LOADING
  // =============================================================
  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }

  // =============================================================
  // ERROR
  // =============================================================
  Widget _buildError(
    BuildContext context,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.restaurant_menu_rounded,
                size: 42,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Unable to load recipes',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textPrimary,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: controller.getRecipes,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}