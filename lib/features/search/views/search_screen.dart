import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/core/routes/app_routes.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/core/theme/app_text_styles.dart';
import 'package:recipe_app/features/favorites/controllers/favorites_controller.dart';
import 'package:recipe_app/features/favorites/models/favorite_recipe_model.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor =
        isDark ? AppColors.darkBackground : AppColors.background;

    final surfaceColor =
        isDark ? AppColors.darkSurface : AppColors.surface;

    final primaryText =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    final secondaryText =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final borderColor =
        isDark ? AppColors.darkBorder : AppColors.border;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'Search Recipes',
          style: AppTextStyles.headingMedium.copyWith(
            color: primaryText,
            fontWeight: FontWeight.w800,
          ),
        ),
        iconTheme: IconThemeData(color: primaryText),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // ===================================================
                  // SEARCH BAR
                  // ===================================================
                  Container(
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: controller.searchTextController,
                      onChanged: controller.searchRecipes,
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search for any dish, ingredient, or cuisine...',
                        hintStyle: TextStyle(
                          color: secondaryText.withValues(alpha: 0.7),
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        suffixIcon: IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.tune_rounded,
                              color: AppColors.primary,
                              size: 18,
                            ),
                          ),
                          onPressed: () => _showFilterModal(context),
                        ),
                        filled: false,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ===================================================
                  // FILTER CHIPS ROW
                  // ===================================================
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
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

                  // ===================================================
                  // RESULTS BODY
                  // ===================================================
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      }

                      final recipes = controller.filteredResults;

                      if (recipes.isEmpty) {
                        return Center(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.search_off_rounded,
                                    size: 46,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No Recipes Found',
                                  style: AppTextStyles.headingSmall.copyWith(
                                    color: primaryText,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Try searching for different keywords or clearing filters',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: secondaryText,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // ===============================================
                      // RESPONSIVE RECIPES GRID
                      // ===============================================
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final crossAxisCount = width < 720
                              ? 1
                              : width < 1150
                                  ? 2
                                  : width < 1500
                                      ? 3
                                      : 4;

                          return GridView.builder(
                            itemCount: recipes.length,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 24),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              mainAxisExtent: 114,
                            ),


                            itemBuilder: (context, index) {
                              final recipe = recipes[index];
                              return _buildRecipeCard(recipe);
                            },
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isDark = Get.isDarkMode;

    final surfaceColor =
        isDark ? AppColors.darkSurface : AppColors.surface;

    final secondaryText =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final borderColor =
        isDark ? AppColors.darkBorder : AppColors.border;

    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          _buildFilterSheet(label),
          isScrollControlled: true,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: secondaryText,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.primary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // RECIPE CARD WIDGET
  // ================================================================
  Widget _buildRecipeCard(RecipeModel recipe) {

    final isDark = Theme.of(Get.context!).brightness == Brightness.dark;
    final primaryText =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryText =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final surfaceColor =
        isDark ? AppColors.darkSurface : AppColors.surface;
    final borderColor =
        isDark ? AppColors.darkBorder : AppColors.border;

    final categoryText = recipe.category.isNotEmpty ? recipe.category : 'General';
    final areaText = recipe.area.isNotEmpty ? recipe.area : 'Global';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.toNamed(
            AppRoutes.recipeDetails,
            arguments: recipe.id,
          );
        },
        borderRadius: BorderRadius.circular(22),
        splashColor: AppColors.primary.withValues(alpha: 0.1),
        highlightColor: AppColors.primary.withValues(alpha: 0.05),
        child: Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: AppColors.primary.withValues(alpha: isDark ? 0.08 : 0.03),
                blurRadius: 18,
                offset: const Offset(0, 6),
                spreadRadius: -2,
              ),
            ],
          ),
          child: Row(
            children: [
              // Recipe Thumbnail with Star Rating Overlay
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(21),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      width: 118,
                      height: double.infinity,
                      child: recipe.image.isNotEmpty
                          ? Image.network(
                              recipe.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: AppColors.primaryLight,
                                child: const Center(
                                  child: Icon(
                                    Icons.restaurant_menu_rounded,
                                    color: AppColors.primary,
                                    size: 34,
                                  ),
                                ),
                              ),
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: AppColors.primaryLight,
                                  child: const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: AppColors.primary,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: AppColors.primaryLight,
                              child: const Center(
                                child: Icon(
                                  Icons.restaurant_menu_rounded,
                                  color: AppColors.primary,
                                  size: 34,
                                ),
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 11,
                              color: Colors.amber,
                            ),
                            SizedBox(width: 2),
                            Text(
                              '4.8',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14),

              // Recipe Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Category & Area Pill Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$categoryText • $areaText',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),

                      // Recipe Name
                      Text(
                        recipe.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: primaryText,
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 6),

                      // Duration & View Details
                      Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 13.5,
                            color: secondaryText,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '25m',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: secondaryText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.restaurant_menu_rounded,
                            size: 13.5,
                            color: secondaryText,
                          ),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              'View Recipe',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Favorite Action Button
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Obx(() {
                  final favCtrl = Get.isRegistered<FavoritesController>()
                      ? Get.find<FavoritesController>()
                      : Get.put(FavoritesController());

                  final isFav = favCtrl.isFavorite(recipe.id);

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        final favRecipe = FavoriteRecipeModel(
                          id: recipe.id,
                          name: recipe.name,
                          image: recipe.image,
                        );
                        favCtrl.toggleFavorite(favRecipe);
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isFav
                              ? Colors.red.withValues(alpha: 0.10)
                              : Colors.grey.withValues(alpha: 0.10),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFav
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFav ? Colors.redAccent : secondaryText,
                          size: 20,
                        ),
                      ),
                    ),
                  );
                }),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSheet(String filterType) {
    final isDark = Get.isDarkMode;

    final surfaceColor =
        isDark ? AppColors.darkSurface : AppColors.surface;

    final primaryText =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;


    Widget optionsWidget = const SizedBox();

    if (filterType == 'Difficulty') {
      optionsWidget = _buildDifficultyOptions();
    } else if (filterType == 'Cuisine') {
      optionsWidget = _buildCuisineOptions();
    } else if (filterType == 'Time') {
      optionsWidget = _buildTimeOptions();
    } else if (filterType == 'Diet') {
      optionsWidget = _buildDietOptions();
    }

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                filterType,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: primaryText,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
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
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Get.back(),
              child: const Text(
                'Apply Filter',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
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
            selectedColor: AppColors.primary.withValues(alpha: 0.2),
          );
        });
      }).toList(),
    );
  }

  Widget _buildCuisineOptions() {
    final cuisines = controller.areas;

    if (cuisines.isEmpty) {
      return const Text('Loading cuisines...');
    }

    return Obx(
      () => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: cuisines.map((cuisine) {
          final isSelected = controller.activeFilters.contains(cuisine);

          return FilterChip(
            label: Text(cuisine),
            selected: isSelected,
            onSelected: (value) => value
                ? controller.addFilter(cuisine)
                : controller.removeFilter(cuisine),
            selectedColor: AppColors.primary.withValues(alpha: 0.2),
          );
        }).toList(),
      ),
    );
  }


  Widget _buildTimeOptions() {
    return Wrap(
      spacing: 8,
      children: [
        'Under 15 mins',
        'Under 30 mins',
        'Under 45 mins',
        'Under 60 mins'
      ].map((time) {
        return Obx(() {
          final isSelected = controller.activeFilters.contains(time);

          return FilterChip(
            label: Text(time),
            selected: isSelected,
            onSelected: (value) => value
                ? controller.addFilter(time)
                : controller.removeFilter(time),
            selectedColor: AppColors.primary.withValues(alpha: 0.2),
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
          final isSelected = controller.activeFilters.contains(diet);

          return FilterChip(
            label: Text(diet),
            selected: isSelected,
            onSelected: (value) => value
                ? controller.addFilter(diet)
                : controller.removeFilter(diet),
            selectedColor: AppColors.primary.withValues(alpha: 0.2),
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
            top: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Recipes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: primaryText,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
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
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Get.back(),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
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
