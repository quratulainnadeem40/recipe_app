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
import 'package:recipe_app/features/navigation/controllers/navigation_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ============================================================
    // THEME COLORS
    // ============================================================

    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.background;

    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.border;

    final iconColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.primary;

    final shadowColor = isDark
        ? Colors.black.withOpacity(0.35)
        : AppColors.shadow;

    // ============================================================
    // CATEGORIES
    // ============================================================

    final categories = <Map<String, dynamic>>[
      {
        'title': 'Beef',
        'api': 'Beef',
        'icon': Icons.lunch_dining_rounded,
      },
      {
        'title': 'Breakfast',
        'api': 'Breakfast',
        'icon': Icons.free_breakfast_rounded,
      },
      {
        'title': 'Chicken',
        'api': 'Chicken',
        'icon': Icons.restaurant_rounded,
      },
      {
        'title': 'Dessert',
        'api': 'Dessert',
        'icon': Icons.cake_rounded,
      },
      {
        'title': 'Goat',
        'api': 'Goat',
        'icon': Icons.set_meal_rounded,
      },
      {
        'title': 'Lamb',
        'api': 'Lamb',
        'icon': Icons.dinner_dining_rounded,
      },
      {
        'title': 'Miscellaneous',
        'api': 'Miscellaneous',
        'icon': Icons.fastfood_rounded,
      },
      {
        'title': 'Pasta',
        'api': 'Pasta',
        'icon': Icons.ramen_dining_rounded,
      },
      {
        'title': 'Pork',
        'api': 'Pork',
        'icon': Icons.set_meal_rounded,
      },
      {
        'title': 'Seafood',
        'api': 'Seafood',
        'icon': Icons.sailing_rounded,
      },
      {
        'title': 'Side',
        'api': 'Side',
        'icon': Icons.rice_bowl_rounded,
      },
      {
        'title': 'Starter',
        'api': 'Starter',
        'icon': Icons.tapas_rounded,
      },
      {
        'title': 'Vegan',
        'api': 'Vegan',
        'icon': Icons.eco_rounded,
      },
      {
        'title': 'Vegetarian',
        'api': 'Vegetarian',
        'icon': Icons.local_florist_rounded,
      },
    ];

    // ============================================================
    // POPULAR SEARCHES
    // ============================================================

    const popularSearches = [
      'Chicken',
      'Biryani',
      'Pasta',
      'Cake',
      'Pizza',
      'Soup',
    ];

    // ============================================================
    // SCREEN
    // ============================================================

    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: Obx(
          () {
            // ======================================================
            // INITIAL LOADING
            // ======================================================

            if (controller.isLoading.value &&
                controller.recipes.isEmpty) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3,
                  backgroundColor:
                      isDark ? AppColors.darkSurface : null,
                ),
              );
            }

            // ======================================================
            // ERROR
            // ======================================================

            if (controller.errorMessage.value.isNotEmpty &&
                controller.recipes.isEmpty) {
              return _buildError(
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                shadowColor: shadowColor,
                isDark: isDark,
              );
            }

            // ======================================================
            // HOME CONTENT
            // ======================================================

            return RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: surfaceColor,
              onRefresh: controller.getRecipes,

              child: LayoutBuilder(
                builder: (
                  context,
                  constraints,
                ) {
                  final isDesktop =
                      constraints.maxWidth >= 900;

                  final horizontalPadding =
                      isDesktop ? 32.0 : 16.0;

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                      parent:
                          AlwaysScrollableScrollPhysics(),
                    ),

                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      12,
                      horizontalPadding,
                      110,
                    ),

                    child: Center(
                      child: ConstrainedBox(
                        constraints:
                            const BoxConstraints(
                          maxWidth: 1400,
                        ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            // =================================================
                            // HEADER
                            // =================================================

                            HomeHeader(
                              onNotificationTap: () {
                                Get.toNamed(
                                  AppRoutes.notifications,
                                );
                              },
                            ),

                            const SizedBox(height: 16),

                    

                            // =================================================
                            // EXPLORE BY CUISINE
                            // =================================================

                           _sectionHeader(
  'Explore by Cuisine',
  textPrimary,
  () {
    Get.find<NavigationController>().openExplore(
  type: 'allCountries',
);
  },
),

                            const SizedBox(height: 12),

                            _buildCountries(),

                            const SizedBox(height: 25),

                            // =================================================
                            // CATEGORIES
                            // =================================================

                            
                              _sectionHeader(
  'Categories',
  textPrimary,
  () {
    Get.find<NavigationController>().openExplore(
      type: 'allCategories',
    );
  },
),
                            const SizedBox(height: 12),

                            _buildCategories(
                              categories,
                            ),

                            const SizedBox(height: 25),

                            // =================================================
                            // POPULAR SEARCHES
                            // =================================================

                            Text(
                              'Popular Searches',
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: 17,
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 11),

                            _buildPopularSearches(
                              searches: popularSearches,
                              textPrimary: textPrimary,
                              borderColor: borderColor,
                              isDark: isDark,
                            ),

                            const SizedBox(height: 27),

                            // =================================================
                            // TRENDING RECIPES
                            // =================================================

                          _sectionHeader(
  'Trending Recipes 🔥',
  textPrimary,
  () {
    Get.find<NavigationController>().openExplore(
      type: 'trending',
    );
  },
),
                            const SizedBox(height: 12),

                            RecipeHorizontalList(
                              recipes:
                                  controller
                                      .trendingRecipes,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // ================================================================
  // COUNTRIES
  // ================================================================

  Widget _buildCountries() {
    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),

        itemCount:
            CountryData.countries.length,

        separatorBuilder: (_, __) {
          return const SizedBox(
            width: 12,
          );
        },

        itemBuilder: (
          context,
          index,
        ) {
          final country =
              CountryData.countries[index];

          return CountryItem(
            country: country,

            isSelected:
                controller.selectedCountry.value ==
                    country.area,

          onTap: () {
  controller.selectedCountry.value =
      country.area;

  Get.find<NavigationController>().openExplore(
    type: 'country',
    area: country.area,
  );
},
          );
        },
      ),
    );
  }

  // ================================================================
  // CATEGORIES
  // ================================================================

  Widget _buildCategories(
    List<Map<String, dynamic>> categories,
  ) {
    return SizedBox(
      height: 105,

      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),

        itemCount: categories.length,

        separatorBuilder: (_, __) {
          return const SizedBox(
            width: 10,
          );
        },

        itemBuilder: (
          context,
          index,
        ) {
          final item = categories[index];

          final title =
              item['title'] as String;

          final apiCategory =
              item['api'] as String;

          final icon =
              item['icon'] as IconData;

          return SizedBox(
            width: 108,

            child: CategoryItem(
              title: title,
              icon: icon,

            onTap: () {
  controller.selectedCategory.value =
      apiCategory;

  Get.find<NavigationController>().openExplore(
    type: 'category',
    category: apiCategory,
  );
},
            ),
          );
        },
      ),
    );
  }

  // ================================================================
  // POPULAR SEARCHES
  // ================================================================

  Widget _buildPopularSearches({
    required List<String> searches,
    required Color textPrimary,
    required Color borderColor,
    required bool isDark,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),

      child: Row(
        children: searches.map(
          (search) {
            return Padding(
              padding: const EdgeInsets.only(
                right: 8,
              ),

              child: ActionChip(
                label: Text(
                  search,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                backgroundColor: isDark
                    ? AppColors.darkSurface
                    : AppColors.chipBackground,

                side: BorderSide(
                  color: borderColor,
                  width: 1,
                ),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20),
                ),

                elevation: 0,
                pressElevation: 0,

              onPressed: () {
  Get.find<NavigationController>().openExplore(
    type: 'query',
    query: search,
  );
},
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  // ================================================================
  // SECTION HEADER
  // ================================================================

  Widget _sectionHeader(
    String title,
    Color textPrimary,
    VoidCallback onSeeAll,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,

            style: TextStyle(
              color: textPrimary,
              fontSize: 17,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ),

        const SizedBox(width: 8),

        InkWell(
          onTap: onSeeAll,

          borderRadius:
              BorderRadius.circular(8),

          child: const Padding(
            padding: EdgeInsets.all(5),

            child: Text(
              'See all',

              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================================================================
  // ERROR
  // ================================================================

  Widget _buildError({
    required Color textPrimary,
    required Color textSecondary,
    required Color surfaceColor,
    required Color borderColor,
    required Color shadowColor,
    required bool isDark,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),

        child: Container(
          width: double.infinity,

          constraints:
              const BoxConstraints(
            maxWidth: 450,
          ),

          padding:
              const EdgeInsets.all(24),

          decoration: BoxDecoration(
            color: surfaceColor,

            borderRadius:
                BorderRadius.circular(20),

            border: Border.all(
              color: borderColor,
            ),

            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 15,
                offset:
                    const Offset(0, 6),
              ),
            ],
          ),

          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              // ==================================================
              // ERROR ICON
              // ==================================================

              Container(
                padding:
                    const EdgeInsets.all(16),

                decoration:
                    BoxDecoration(
                  color: isDark
                      ? AppColors.primary
                          .withOpacity(0.18)
                      : AppColors.primaryLight,

                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons
                      .restaurant_menu_rounded,
                  color:
                      AppColors.primary,
                  size: 40,
                ),
              ),

              const SizedBox(height: 15),

              // ==================================================
              // ERROR TITLE
              // ==================================================

              Text(
                'Unable to load recipes',

                textAlign:
                    TextAlign.center,

                style: TextStyle(
                  color: textPrimary,
                  fontSize: 20,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const SizedBox(height: 8),

              // ==================================================
              // ERROR MESSAGE
              // ==================================================

              Text(
                controller
                    .errorMessage
                    .value,

                textAlign:
                    TextAlign.center,

                style: TextStyle(
                  color: textSecondary,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 18),

              // ==================================================
              // TRY AGAIN
              // ==================================================

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed:
                      controller.getRecipes,

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primary,

                    foregroundColor:
                        AppColors.textWhite,

                    elevation: 0,

                    padding:
                        const EdgeInsets
                            .symmetric(
                      vertical: 13,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(12),
                    ),
                  ),

                  child: const Text(
                    'Try Again',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}