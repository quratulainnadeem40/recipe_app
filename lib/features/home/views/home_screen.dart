import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/routes/app_routes.dart';
import 'package:recipe_app/features/home/controllers/home_controller.dart';
import 'package:recipe_app/features/home/data/country_data.dart';
import 'package:recipe_app/features/home/views/widgets/category_item.dart';
import 'package:recipe_app/features/home/views/widgets/country_item.dart';
import 'package:recipe_app/features/home/views/widgets/home_header.dart';
import 'package:recipe_app/features/home/views/widgets/recipe_horizontal_list.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // =========================================================
    // CATEGORIES
    // No CategoryModel required
    // =========================================================

    final List<Map<String, dynamic>> categories = [
      {
        'title': 'Chicken',
        'icon': Icons.lunch_dining,
      },
      {
        'title': 'Beef',
        'icon': Icons.set_meal,
      },
      {
        'title': 'Dessert',
        'icon': Icons.cake,
      },
      {
        'title': 'Seafood',
        'icon': Icons.set_meal_outlined,
      },
      {
        'title': 'Vegetarian',
        'icon': Icons.eco,
      },
      {
        'title': 'Pasta',
        'icon': Icons.ramen_dining,
      },
      {
        'title': 'Breakfast',
        'icon': Icons.breakfast_dining,
      },
      {
        'title': 'Side',
        'icon': Icons.restaurant,
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Obx(
          () {
            // =====================================================
            // MAIN LOADING
            // =====================================================

            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // =====================================================
            // MAIN ERROR
            // =====================================================

            if (controller.errorMessage.value.isNotEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 50,
                        color: Colors.red,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        controller.errorMessage.value,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),

                      ElevatedButton(
                        onPressed: controller.getRecipes,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // =====================================================
            // HOME
            // =====================================================

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                110,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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

                  const SizedBox(height: 28),

                  // =================================================
                  // EXPLORE BY COUNTRY
                  // =================================================

                  const Text(
                    'Explore by Country',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Discover delicious recipes from around the world',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // =================================================
                  // COUNTRY LIST
                  // =================================================

                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: CountryData.countries.length,
                      separatorBuilder: (
                        context,
                        index,
                      ) {
                        return const SizedBox(width: 12);
                      },
                      itemBuilder: (
                        context,
                        index,
                      ) {
                        final country =
                            CountryData.countries[index];

                        return CountryItem(
                          country: country,
                          onTap: () {
                          Get.toNamed(
                            AppRoutes.search,
                            arguments: country.area
                          );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // =================================================
                  // EXPLORE BY CATEGORY
                  // =================================================

                  const Text(
                    'Explore by Category',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Find recipes by your favorite food category',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // =================================================
                  // CATEGORY HORIZONTAL LIST
                  // =================================================

                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: categories.length,
                      itemBuilder: (
                        context,
                        index,
                      ) {
                        final category = categories[index];

                        return CategoryItem(
                          title: category['title'],
                          icon: category['icon'],
                          onTap: () {
                            controller.getRecipesByCategory(
                              category['title'],
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // =================================================
                  // CATEGORY RECIPES
                  // =================================================

                  Obx(
                    () {
                      // ------------------------------------------------
                      // CATEGORY LOADING
                      // ------------------------------------------------

                      if (controller.isCategoryLoading.value) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 25,
                          ),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      // ------------------------------------------------
                      // CATEGORY ERROR
                      // ------------------------------------------------

                      if (controller
                          .categoryErrorMessage
                          .value
                          .isNotEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(16),
                            color: Colors.red.withOpacity(0.08),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 40,
                              ),

                              const SizedBox(height: 8),

                              Text(
                                controller
                                    .categoryErrorMessage
                                    .value,
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 12),

                              ElevatedButton(
                                onPressed: () {
                                  controller.categoryRecipes.clear();
                                  controller
                                      .categoryErrorMessage
                                      .value = '';
                                  controller
                                      .selectedCategory
                                      .value = '';
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      }

                      // ------------------------------------------------
                      // NO CATEGORY SELECTED
                      // ------------------------------------------------

                      if (controller.categoryRecipes.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      // ------------------------------------------------
                      // CATEGORY RECIPES
                      // ------------------------------------------------

                      return Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${controller.selectedCategory.value} Recipes',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          RecipeHorizontalList(
                            recipes:
                                controller.categoryRecipes,
                            onRecipeTap: (recipe) {
                              Get.toNamed(
                                AppRoutes.recipeDetails,
                                arguments: recipe.id,
                              );
                            },
                          ),

                          const SizedBox(height: 30),
                        ],
                      );
                    },
                  ),

                  // =================================================
                  // COUNTRY RECIPES
                  // =================================================

                  Obx(
                    () {
                      // Loading
                      if (controller.isCountryLoading.value) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 25,
                          ),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      // Error
                      if (controller
                          .countryErrorMessage
                          .value
                          .isNotEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(16),
                            color: Colors.red.withOpacity(0.08),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 40,
                              ),

                              const SizedBox(height: 8),

                              Text(
                                controller
                                    .countryErrorMessage
                                    .value,
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 12),

                              ElevatedButton(
                                onPressed:
                                    controller.clearCountryRecipes,
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      }

                      // No country selected
                      if (controller.countryRecipes.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      // Country recipes
                      return Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${controller.selectedCountry.value} Recipes',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          RecipeHorizontalList(
                            recipes:
                                controller.countryRecipes,
                            onRecipeTap: (recipe) {
                              Get.toNamed(
                                AppRoutes.recipeDetails,
                                arguments: recipe.id,
                              );
                            },
                          ),

                          const SizedBox(height: 30),
                        ],
                      );
                    },
                  ),

                  // =================================================
                  // POPULAR RECIPES
                  // =================================================

                  const Text(
                    'Popular Recipes',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Trending recipes you should try',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 14),

                  RecipeHorizontalList(
                    recipes: controller.recipes,
                    onRecipeTap: (recipe) {
                      Get.toNamed(
                        AppRoutes.recipeDetails,
                        arguments: recipe.id,
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // =================================================
                  // RECOMMENDED FOR YOU
                  // =================================================

                  const Text(
                    'Recommended For You',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Recipes selected for your taste',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 14),

                  RecipeHorizontalList(
                    recipes: controller.recipes,
                    onRecipeTap: (recipe) {
                      Get.toNamed(
                        AppRoutes.recipeDetails,
                        arguments: recipe.id,
                      );
                    },
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}