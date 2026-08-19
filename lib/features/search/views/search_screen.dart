import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/routes/app_routes.dart';
import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/home/models/recipe_models.dart';
import '../controllers/search_controller.dart' as search_controller;

class SearchScreen extends GetView<search_controller.SearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.background;

    final surfaceColor = isDark
        ? AppColors.surface
        : AppColors.surface;

    final textPrimary = isDark
        ? AppColors.textPrimary
        : AppColors.textPrimary;

    final textSecondary = isDark
        ? AppColors.textSecondary
        : AppColors.textSecondary;

    final dividerColor = isDark
        ? AppColors.border
        : AppColors.border;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =====================================================
                // HEADER
                // =====================================================
                _buildHeader(context, textPrimary),

                const SizedBox(height: 22),

                // =====================================================
                // SEARCH BAR
                // =====================================================
                _buildSearchBar(
                  context,
                  surfaceColor,
                  textPrimary,
                  textSecondary,
                  dividerColor,
                ),

                const SizedBox(height: 16),

                // =====================================================
                // FILTERS
                // =====================================================
                _buildFilterRow(
                  context,
                  surfaceColor,
                  textPrimary,
                  textSecondary,
                  dividerColor,
                ),

                const SizedBox(height: 14),

                // =====================================================
                // ACTIVE FILTER CHIPS
                // =====================================================
                if (controller.hasActiveFilters)
                  _buildActiveFilters(textPrimary, textSecondary),

                // =====================================================
                // RECENT SEARCHES
                // =====================================================
                if (controller.recentSearches.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: _buildRecentSearches(
                      surfaceColor,
                      textPrimary,
                      textSecondary,
                      dividerColor,
                    ),
                  ),

                const SizedBox(height: 22),

                // =====================================================
                // RESULTS
                // =====================================================
                _buildResults(
                  surfaceColor,
                  textPrimary,
                  textSecondary,
                  dividerColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // HEADER
  // =============================================================
  Widget _buildHeader(
    BuildContext context,
    Color textPrimary,
  ) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Get.back();
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textPrimary,
            size: 22,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Explore Recipes',
          style: TextStyle(
            color: textPrimary,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        const Icon(
          Icons.tune_rounded,
          color: AppColors.primary,
          size: 23,
        ),
      ],
    );
  }

  // =============================================================
  // SEARCH BAR
  // =============================================================
  Widget _buildSearchBar(
    BuildContext context,
    Color surfaceColor,
    Color textPrimary,
    Color textSecondary,
    Color dividerColor,
  ) {
    return Column(
      children: [
        Container(
          height: 58,
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: dividerColor),
          ),
          child: Row(
            children: [
              const SizedBox(width: 15),
              const Icon(
                Icons.search_rounded,
                color: AppColors.primary,
                size: 26,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller.searchTextController,
                  onChanged: controller.onSearchTextChanged,
                  onSubmitted: (value) {
                    controller.searchRecipes(value);
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  textInputAction: TextInputAction.search,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 15,
                  ),
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    hintText: 'Search recipes...',
                    hintStyle: TextStyle(
                      color: textSecondary,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              Obx(
                () {
                  if (controller.searchTextController.text.isEmpty) {
                    return const SizedBox(width: 8);
                  }

                  return IconButton(
                    onPressed: controller.clearSearch,
                    icon: Icon(
                      Icons.close_rounded,
                      color: textSecondary,
                    ),
                  );
                },
              ),
              Container(
                width: 43,
                height: 43,
                margin: const EdgeInsets.only(right: 7),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    controller.searchRecipes(
                      controller.searchTextController.text,
                    );
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  icon: const Icon(
                    Icons.search_rounded,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
              ),
            ],
          ),
        ),

        // =========================================================
        // LIVE SUGGESTIONS
        // =========================================================
        Obx(
          () {
            if (!controller.showSuggestions.value) {
              return const SizedBox.shrink();
            }

            return _buildSuggestions(
              surfaceColor,
              textPrimary,
              textSecondary,
              dividerColor,
            );
          },
        ),
      ],
    );
  }

  // =============================================================
  // LIVE SUGGESTIONS
  // =============================================================
  Widget _buildSuggestions(
    Color surfaceColor,
    Color textPrimary,
    Color textSecondary,
    Color dividerColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: dividerColor),
      ),
      child: Column(
        children: [
          if (controller.isSuggestionLoading.value)
            const Padding(
              padding: EdgeInsets.all(14),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            ),
          ...controller.suggestions.take(5).map(
            (recipe) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 3,
                ),
                leading: _buildRecipeImage(
                  recipe,
                  45,
                  dividerColor,
                  textSecondary,
                ),
                title: Text(
                  recipe.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  '${recipe.area} • ${recipe.category}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 12,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.primary,
                ),
                onTap: () {
                  controller.selectSuggestion(recipe);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // =============================================================
  // FILTER ROW
  // =============================================================
  Widget _buildFilterRow(
    BuildContext context,
    Color surfaceColor,
    Color textPrimary,
    Color textSecondary,
    Color dividerColor,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildFilterButton(
            label: 'Categories',
            icon: Icons.keyboard_arrow_down_rounded,
            surfaceColor: surfaceColor,
            textPrimary: textPrimary,
            dividerColor: dividerColor,
            onTap: () {
              _showCategorySheet(
                context,
                surfaceColor,
                textPrimary,
              );
            },
          ),
          const SizedBox(width: 8),
          _buildFilterButton(
            label: 'Cuisine',
            icon: Icons.keyboard_arrow_down_rounded,
            surfaceColor: surfaceColor,
            textPrimary: textPrimary,
            dividerColor: dividerColor,
            onTap: () {
              _showCuisineSheet(
                context,
                surfaceColor,
                textPrimary,
              );
            },
          ),
          const SizedBox(width: 8),
          _buildFilterButton(
            label: 'Time',
            icon: Icons.keyboard_arrow_down_rounded,
            surfaceColor: surfaceColor,
            textPrimary: textPrimary,
            dividerColor: dividerColor,
            onTap: () {
              Get.snackbar(
                'Time',
                'Time filter will be added next.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          const SizedBox(width: 8),
          _buildFilterButton(
            label: 'Diet',
            icon: Icons.keyboard_arrow_down_rounded,
            surfaceColor: surfaceColor,
            textPrimary: textPrimary,
            dividerColor: dividerColor,
            onTap: () {
              Get.snackbar(
                'Diet',
                'Diet filter will be added next.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
    );
  }

  // =============================================================
  // FILTER BUTTON
  // =============================================================
  Widget _buildFilterButton({
    required String label,
    required IconData icon,
    required Color surfaceColor,
    required Color textPrimary,
    required Color dividerColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: dividerColor),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              icon,
              color: textPrimary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // ACTIVE FILTERS
  // =============================================================
  Widget _buildActiveFilters(
    Color textPrimary,
    Color textSecondary,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (controller.selectedArea.value != null)
          _buildActiveChip(
            text:
                '${_countryEmoji(controller.selectedArea.value!)} ${controller.selectedArea.value!}',
            onRemove: controller.clearArea,
          ),
        if (controller.selectedCategory.value != null)
          _buildActiveChip(
            text: controller.selectedCategory.value!,
            onRemove: controller.clearCategory,
          ),
      ],
    );
  }

  // =============================================================
  // ACTIVE CHIP
  // =============================================================
  Widget _buildActiveChip({
    required String text,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              color: AppColors.primary,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // RECENT SEARCHES
  // =============================================================
  Widget _buildRecentSearches(
    Color surfaceColor,
    Color textPrimary,
    Color textSecondary,
    Color dividerColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recently Searched',
              style: TextStyle(
                color: textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: controller.clearRecentSearches,
              child: const Text(
                'Clear all',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: controller.recentSearches.take(5).map(
              (recipe) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () {
                      controller.selectRecipe(recipe);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: dividerColor),
                      ),
                      child: Text(
                        recipe.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }

  // =============================================================
  // RESULTS
  // =============================================================
  Widget _buildResults(
    Color surfaceColor,
    Color textPrimary,
    Color textSecondary,
    Color dividerColor,
  ) {
    if (controller.isLoading.value) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (controller.errorMessage.value.isNotEmpty) {
      return _buildError(
        textPrimary,
        textSecondary,
      );
    }

    final recipes = controller.filteredResults;

    if (recipes.isEmpty) {
      return _buildEmptyState(
        surfaceColor,
        textPrimary,
        textSecondary,
        dividerColor,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Results (${recipes.length})',
              style: TextStyle(
                color: textPrimary,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 13),
        ...recipes.map(
          (recipe) {
            return _buildRecipeCard(
              recipe,
              surfaceColor,
              textPrimary,
              textSecondary,
              dividerColor,
            );
          },
        ),
      ],
    );
  }

  // =============================================================
  // RECIPE CARD
  // =============================================================
  Widget _buildRecipeCard(
    RecipeModel recipe,
    Color surfaceColor,
    Color textPrimary,
    Color textSecondary,
    Color dividerColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: dividerColor),
      ),
      child: Row(
        children: [
          _buildRecipeImage(
            recipe,
            88,
            dividerColor,
            textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${recipe.area} • ${recipe.category}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '4.8',
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.timer_outlined,
                      color: textSecondary,
                      size: 15,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '30 min',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: () {
              // Favorite functionality can be connected later.
            },
            icon: Icon(
              Icons.favorite_border_rounded,
              color: textSecondary,
              size: 21,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // RECIPE IMAGE
  // =============================================================
  Widget _buildRecipeImage(
    RecipeModel recipe,
    double size,
    Color dividerColor,
    Color textSecondary,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        recipe.image,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            width: size,
            height: size,
            color: dividerColor,
            child: Icon(
              Icons.restaurant_rounded,
              color: textSecondary,
              size: 28,
            ),
          );
        },
      ),
    );
  }

  // =============================================================
  // EMPTY STATE
  // =============================================================
  Widget _buildEmptyState(
    Color surfaceColor,
    Color textPrimary,
    Color textSecondary,
    Color dividerColor,
  ) {
    final hasFilter = controller.hasActiveFilters;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 25),
      padding: const EdgeInsets.symmetric(
        vertical: 45,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: dividerColor),
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.explore_rounded,
              color: AppColors.primary,
              size: 36,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            hasFilter ? 'No recipes found' : 'Start exploring',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            hasFilter
                ? 'Try another country or category.'
                : 'Search for a recipe or select a filter.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // ERROR
  // =============================================================
  Widget _buildError(
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'Something went wrong',
            style: TextStyle(
              color: textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            controller.errorMessage.value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // CATEGORY BOTTOM SHEET
  // =============================================================
  void _showCategorySheet(
    BuildContext context,
    Color surfaceColor,
    Color textPrimary,
  ) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 25),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.categories.map(
                  (category) {
                    return ActionChip(
                      label: Text(category),
                      onPressed: () {
                        Get.back();
                        controller.setCategory(category);
                      },
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // CUISINE BOTTOM SHEET
  // =============================================================
  void _showCuisineSheet(
    BuildContext context,
    Color surfaceColor,
    Color textPrimary,
  ) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      'Cuisine',
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: Get.back,
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.areas.length,
                  itemBuilder: (context, index) {
                    final area = controller.areas[index];

                    return ListTile(
                      leading: Text(
                        _countryEmoji(area),
                        style: const TextStyle(fontSize: 22),
                      ),
                      title: Text(area),
                      trailing: controller.selectedArea.value == area
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                            )
                          : null,
                      onTap: () {
                        Get.back();
                        controller.setArea(area);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // COUNTRY EMOJI
  // =============================================================
  String _countryEmoji(String country) {
    switch (country.toLowerCase()) {
      case 'pakistani':
      case 'pakistan':
        return '🇵🇰';
      case 'indian':
      case 'india':
        return '🇮🇳';
      case 'italian':
      case 'italy':
        return '🇮🇹';
      case 'chinese':
      case 'china':
        return '🇨🇳';
      case 'mexican':
      case 'mexico':
        return '🇲🇽';
      case 'japanese':
      case 'japan':
        return '🇯🇵';
      case 'american':
        return '🇺🇸';
      case 'british':
        return '🇬🇧';
      case 'canadian':
        return '🇨🇦';
      case 'french':
      case 'france':
        return '🇫🇷';
      case 'greek':
      case 'greece':
        return '🇬🇷';
      case 'spanish':
      case 'spain':
        return '🇪🇸';
      case 'thai':
      case 'thailand':
        return '🇹🇭';
      case 'turkish':
      case 'turkey':
        return '🇹🇷';
      default:
        return '🌎';
    }
  }
}