
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

            const SizedBox(height: 12),

            // =====================================================
            // FILTERS
            // =====================================================

            Obx(
              () {
                return Row(
                  children: [
                    // -------------------------------------------------
                    // CATEGORY FILTER
                    // -------------------------------------------------

                    Expanded(
                      child: _FilterDropdown(
                        value: controller.selectedCategory.value,
                        hint: 'Category',
                        icon: Icons.category_outlined,
                        items: controller.categories,
                        onChanged: (value) {
                          controller.setCategory(value);
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    // -------------------------------------------------
                    // AREA FILTER
                    // -------------------------------------------------

                    Expanded(
                      child: _FilterDropdown(
                        value: controller.selectedArea.value,
                        hint: 'Area',
                        icon: Icons.public,
                        items: controller.areas,
                        onChanged: (value) {
                          controller.setArea(value);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 10),

            // =====================================================
            // CLEAR FILTERS
            // =====================================================

            Obx(
              () {
                final hasFilters =
                    controller.selectedCategory.value != null ||
                    controller.selectedArea.value != null;

                if (!hasFilters) {
                  return const SizedBox.shrink();
                }

                return Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: controller.clearFilters,
                    icon: const Icon(
                      Icons.filter_alt_off_outlined,
                      size: 18,
                    ),
                    label: const Text('Clear Filters'),
                  ),
                );
              },
            ),

            const SizedBox(height: 4),

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
                            Icons.search_rounded,
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

                  if (controller.filteredResults.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant_menu_rounded,
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
                            'Try another recipe, category, or area.',
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
                      top: 8,
                      bottom: 20,
                    ),
                    physics: const BouncingScrollPhysics(),

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,

                      // Slightly taller card so the recipe
                      // information has enough space.
                      childAspectRatio: 0.78,
                    ),

                    itemCount:
                        controller.filteredResults.length,

                    itemBuilder: (context, index) {
                      final recipe =
                          controller.filteredResults[index];

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

// ===================================================================
// FILTER DROPDOWN
// ===================================================================

class _FilterDropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final IconData icon;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown({
    required this.value,
    required this.hint,
    required this.icon,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,

      isExpanded: true,

      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        size: 20,
      ),

      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          size: 19,
        ),
        hintText: hint,
        filled: true,
        fillColor: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),

      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('All'),
        ),

        ...items.map(
          (item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
        ),
      ],

      onChanged: onChanged,
    );
  }
}

