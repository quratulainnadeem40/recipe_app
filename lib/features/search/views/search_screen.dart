import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/core/routes/app_routes.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/home/models/recipe_models.dart';
import 'package:recipe_app/features/home/repositories/home_repository.dart';
import 'package:recipe_app/features/search/controllers/search_controller.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  RecipeSearchController get controller {
    if (Get.isRegistered<RecipeSearchController>()) {
      return Get.find<RecipeSearchController>();
    } else {
      return Get.put(
        RecipeSearchController(repository: Get.find<HomeRepository>()),
      );
    }
  }

 @override
Widget build(BuildContext context) {
  

  final isDark =
      Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.background;

    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final primaryText = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    final secondaryText = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.border;

    final softPrimaryColor = isDark
        ? AppColors.primary.withValues(alpha: 0.14)
        : AppColors.primaryLight;

   return Scaffold(
    backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        title: Text(
          'Search Recipes',
          style: TextStyle(
            color: primaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: primaryText),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(20),
            //   child: SizedBox(
            //     width: double.infinity,
            //     height: 210,
            //     child: Image.asset(
            //       'assets/images/search_header.png',
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            const SizedBox(height: 16),

            TextField(
              controller: controller.searchTextController,
              onChanged: (value) {
                controller.searchRecipes(value);
              },
              style: TextStyle(color: primaryText),
              decoration: InputDecoration(
                hintText: 'Search for recipes...',
                hintStyle: TextStyle(color: secondaryText),
                prefixIcon: Icon(
                  Icons.search,
                  color: secondaryText,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.tune,
                    color: AppColors.primary,
                  ),
                  onPressed: () => _showFilterModal(context),
                ),
                filled: true,
                fillColor: surfaceColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Difficulty'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Cuisine'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Time'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Diet'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  );
                }

                final recipes = controller.filteredResults;

                if (recipes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 60,
                          color: secondaryText,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No recipes found',
                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: recipes.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return _buildRecipeCard(recipe);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    
   );
  }

  Widget _buildFilterChip(String label) {
    final isDark = Get.isDarkMode;

    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final secondaryText = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.border;

    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          _buildFilterSheet(label),
          isScrollControlled: true,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: secondaryText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              color: secondaryText,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard(RecipeModel recipe) {
    final isDark = Get.isDarkMode;

    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final primaryText = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    final secondaryText = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.border;

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.recipeDetails,
          arguments: recipe,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: recipe.image.isNotEmpty
                  ? Image.network(
                      recipe.image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              Container(
                        width: 100,
                        height: 100,
                        color: secondaryText.withOpacity(0.2),
                        child: Icon(
                          Icons.broken_image,
                          color: secondaryText,
                        ),
                      ),
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: secondaryText.withOpacity(0.2),
                      child: Icon(
                        Icons.image,
                        color: secondaryText,
                      ),
                    ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 4.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 14,
                          color: secondaryText,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          recipe.category.isNotEmpty
                              ? recipe.category
                              : 'General',
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryText,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: secondaryText,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          recipe.area.isNotEmpty
                              ? recipe.area
                              : 'Global',
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        recipe.category.isNotEmpty
                            ? recipe.category
                            : 'Healthy',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSheet(String filterType) {
    final isDark = Get.isDarkMode;

    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final primaryText = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    Widget optionsWidget = const SizedBox();

    if (filterType == 'Difficulty') {
      optionsWidget = _buildDifficultyOptions();
    }

    if (filterType == 'Cuisine') {
      optionsWidget = _buildCuisineOptions();
    }

    if (filterType == 'Time') {
      optionsWidget = _buildTimeOptions();
    }

    if (filterType == 'Diet') {
      optionsWidget = _buildDietOptions();
    }

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                filterType,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: primaryText,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: primaryText,
                ),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          optionsWidget,
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Get.back(),
              child: const Text(
                'Apply Filter',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyOptions() {
    return Wrap(
      spacing: 8,
      children: ['Easy', 'Medium', 'Hard'].map((difficulty) {
        return Obx(() {
          final selected =
              controller.activeFilters.contains(difficulty);

          return FilterChip(
            label: Text(difficulty),
            selected: selected,
            onSelected: (value) => value
                ? controller.addFilter(difficulty)
                : controller.removeFilter(difficulty),
            selectedColor:
                AppColors.primary.withOpacity(0.2),
            checkmarkColor: AppColors.primary,
          );
        });
      }).toList(),
    );
  }

  Widget _buildCuisineOptions() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: controller.areas.take(6).map((cuisine) {
        return Obx(() {
          final isSelected =
              controller.selectedCuisine.value == cuisine;

          return ChoiceChip(
            label: Text(cuisine),
            selected: isSelected,
            onSelected: (value) =>
                controller.selectedCuisine.value =
                    value ? cuisine : '',
            selectedColor:
                AppColors.primary.withOpacity(0.2),
          );
        });
      }).toList(),
    );
  }

  Widget _buildTimeOptions() {
    return Wrap(
      spacing: 8,
      children: [
        'Under 15 min',
        'Under 30 min',
        'Under 60 min'
      ].map((time) {
        return Obx(() {
          final isSelected =
              controller.activeFilters.contains(time);

          return FilterChip(
            label: Text(time),
            selected: isSelected,
            onSelected: (value) => value
                ? controller.addFilter(time)
                : controller.removeFilter(time),
            selectedColor:
                AppColors.primary.withOpacity(0.2),
          );
        });
      }).toList(),
    );
  }

  Widget _buildDietOptions() {
    return Wrap(
      spacing: 8,
      children: [
        'Vegetarian',
        'Vegan',
        'Healthy'
      ].map((diet) {
        return Obx(() {
          final isSelected =
              controller.activeFilters.contains(diet);

          return FilterChip(
            label: Text(diet),
            selected: isSelected,
            onSelected: (value) => value
                ? controller.addFilter(diet)
                : controller.removeFilter(diet),
            selectedColor:
                AppColors.primary.withOpacity(0.2),
          );
        });
      }).toList(),
    );
  }

  void _showFilterModal(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final primaryText = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Recipes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: primaryText,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: primaryText,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              Divider(
                color: isDark
                    ? AppColors.darkBorder
                    : AppColors.border,
              ),
              const SizedBox(height: 8),

              Text(
                'Difficulty',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 8),
              _buildDifficultyOptions(),

              const SizedBox(height: 16),

              Text(
                'Cuisine (Dynamic Areas)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 8),
              _buildCuisineOptions(),

              const SizedBox(height: 16),

              Text(
                'Prep Time',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 8),
              _buildTimeOptions(),

              const SizedBox(height: 16),

              Text(
                'Dietary Preferences',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 8),
              _buildDietOptions(),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        controller.clearAllFilters();
                        Get.back();
                      },
                      child: Text(
                        'Clear All',
                        style: TextStyle(
                          color: primaryText,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: () => Get.back(),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
                          ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}
  
}
