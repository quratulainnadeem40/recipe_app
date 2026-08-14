
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/features/search/controllers/search_controller.dart'
    as search_controller;
import 'package:recipe_app/features/search/views/widgets/search_field.dart';
import 'package:recipe_app/features/search/views/widgets/search_recipe_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.find<search_controller.SearchController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Recipes'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // =====================================================
            // SEARCH FIELD
            // =====================================================

            const SearchField(),

            const SizedBox(height: 20),

            // =====================================================
            // SEARCH RESULTS
            // =====================================================

            Expanded(
              child: Obx(
                () {
                  // =================================================
                  // LOADING
                  // =================================================

                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // =================================================
                  // ERROR
                  // =================================================

                  if (controller.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 55,
                            color: Colors.red,
                          ),

                          const SizedBox(height: 12),

                          Text(
                            controller.errorMessage.value,
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 16),

                          ElevatedButton(
                            onPressed: () {
                              controller.searchRecipes(
                                controller.searchQuery.value,
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  // =================================================
                  // BEFORE SEARCH
                  // =================================================

                  if (controller.searchQuery.value.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 70,
                          ),

                          SizedBox(height: 16),

                          Text(
                            'Search for your favorite recipes',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            'Enter a recipe name to get started.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  // =================================================
                  // NO RESULTS
                  // =================================================

                  if (controller.searchResults.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant_menu,
                            size: 70,
                          ),

                          SizedBox(height: 16),

                          Text(
                            'No recipes found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            'Try searching for another recipe.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  // =================================================
                  // RESULTS
                  // =================================================

                  return GridView.builder(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                    ),

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),

                    itemCount:
                        controller.searchResults.length,

                    itemBuilder: (context, index) {
                      final recipe =
                          controller.searchResults[index];

                      return SearchRecipeCard(
                        recipe: recipe,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

