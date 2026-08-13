import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/routes/app_routes.dart';
import 'package:recipe_app/features/home/controllers/home_controller.dart';
import 'package:recipe_app/features/home/views/widgets/home_header.dart';
import 'package:recipe_app/features/home/views/widgets/category_item.dart';
import 'package:recipe_app/features/home/views/widgets/home_searchbar.dart';
import 'package:recipe_app/features/home/views/widgets/recipe_horizontal_list.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () {
            // ==========================================
            // MAIN LOADING
            // ==========================================
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // ==========================================
            // MAIN ERROR
            // ==========================================
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

            // ==========================================
            // HOME CONTENT
            // ==========================================
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ======================================
                  // HEADER
                  // ======================================
                  const HomeHeader(),

                  const SizedBox(height: 20),

                  // ======================================
                  // SEARCH BAR
                  // ======================================
                  const HomeSearchBar(),

                  const SizedBox(height: 24),

                  // ======================================
                  // CATEGORIES TITLE
                  // ======================================
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ======================================
                  // CATEGORIES
                  // ======================================
                  SizedBox(
                    height: 90,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        CategoryItem(
                          title: 'Chicken',
                          icon: Icons.restaurant,
                          onTap: () {
                            controller.getRecipesByCategory(
                              'Chicken',
                            );
                          },
                        ),

                        CategoryItem(
                          title: 'Beef',
                          icon: Icons.lunch_dining,
                          onTap: () {
                            controller.getRecipesByCategory(
                              'Beef',
                            );
                          },
                        ),

                        CategoryItem(
                          title: 'Dessert',
                          icon: Icons.cake,
                          onTap: () {
                            controller.getRecipesByCategory(
                              'Dessert',
                            );
                          },
                        ),

                        CategoryItem(
                          title: 'Seafood',
                          icon: Icons.set_meal,
                          onTap: () {
                            controller.getRecipesByCategory(
                              'Seafood',
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ======================================
                  // CATEGORY RECIPES
                  // ======================================
                  Obx(
                    () {
                      // Category loading
                      if (controller.isCategoryLoading.value) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 30,
                          ),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      // Category error
                      if (controller
                          .categoryErrorMessage
                          .value
                          .isNotEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.08),
                            borderRadius:
                                BorderRadius.circular(12),
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
                                  controller
                                      .categoryErrorMessage
                                      .value = '';
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      }

                      // No category selected
                      if (controller.categoryRecipes.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      // Category recipes
                      return Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Category Recipes',
                            style: TextStyle(
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

                  // ======================================
                  // POPULAR RECIPES
                  // ======================================
                  const Text(
                    'Popular Recipes',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ======================================
                  // POPULAR RECIPE LIST
                  // ======================================
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