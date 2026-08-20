import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/home/models/recipe_models.dart';
import 'package:recipe_app/features/search/controllers/search_controller.dart';

class SearchScreen extends GetView<SearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // =========================================================
    // THEME COLORS
    // =========================================================

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

    // Marron / Royal Plum brand color
    final brandColor = AppColors.primary;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: _buildAppBar(
        primaryText,
        brandColor,
      ),

      body: SafeArea(
        child: Obx(
          () {
            final showSuggestions =
                controller.showSuggestions.value;

            return Column(
              children: [
                const SizedBox(height: 10),

                // =====================================================
                // SEARCH BAR
                // =====================================================

                _buildSearchBar(
                  context,
                  surfaceColor,
                  primaryText,
                  secondaryText,
                  borderColor,
                  brandColor,
                ),

                // =====================================================
                // SUGGESTIONS
                // =====================================================

                if (showSuggestions)
                  _buildSuggestions(
                    context,
                    primaryText,
                    secondaryText,
                    borderColor,
                    brandColor,
                  ),

                // =====================================================
                // FILTERS
                // =====================================================

                if (!showSuggestions)
                  _buildFilterSection(
                    context,
                    primaryText,
                    secondaryText,
                    borderColor,
                    brandColor,
                  ),

                const SizedBox(height: 8),

                // =====================================================
                // CURRENT TITLE
                // =====================================================

                if (!showSuggestions)
                  _buildCurrentTitle(
                    primaryText,
                    secondaryText,
                  ),

                const SizedBox(height: 6),

                // =====================================================
                // RESULTS
                // =====================================================

                Expanded(
                  child: _buildResults(
                    context,
                    primaryText,
                    secondaryText,
                    borderColor,
                    brandColor,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ================================================================
  // APP BAR
  // ================================================================

  PreferredSizeWidget _buildAppBar(
    Color primaryText,
    Color brandColor,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      surfaceTintColor: Colors.transparent,

      leading: IconButton(
        onPressed: Get.back,
        tooltip: 'Back',
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: primaryText,
          size: 20,
        ),
      ),

      title: Text(
        'Search Recipes',
        style: TextStyle(
          color: primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),

      centerTitle: false,
    );
  }

  // ================================================================
  // SEARCH BAR
  // ================================================================

  Widget _buildSearchBar(
    BuildContext context,
    Color surfaceColor,
    Color primaryText,
    Color secondaryText,
    Color borderColor,
    Color brandColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: TextField(
        controller: controller.searchTextController,

        onChanged: controller.onSearchTextChanged,

        onSubmitted: controller.searchRecipes,

        textInputAction: TextInputAction.search,

        style: TextStyle(
          color: primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),

        decoration: InputDecoration(
          hintText: _getSearchHint(),

          hintStyle: TextStyle(
            color: secondaryText.withValues(alpha: 0.65),
            fontSize: 14,
          ),

          // MARRON SEARCH ICON
          prefixIcon: Icon(
            Icons.search_rounded,
            color: brandColor,
            size: 22,
          ),

          suffixIcon: Obx(
            () {
              if (controller.searchQuery.value.isEmpty) {
                return const SizedBox.shrink();
              }

              return IconButton(
                tooltip: 'Clear',
                onPressed: controller.clearSearch,
                icon: Icon(
                  Icons.close_rounded,
                  color: secondaryText,
                  size: 21,
                ),
              );
            },
          ),

          filled: true,
          fillColor: surfaceColor,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: BorderSide(
              color: borderColor,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: BorderSide(
              color: borderColor,
            ),
          ),

          // MARRON FOCUS BORDER
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: BorderSide(
              color: brandColor,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // SEARCH HINT
  // ================================================================

  String _getSearchHint() {
    if (controller.selectedArea.value != null) {
      return 'Search ${controller.selectedArea.value} recipes...';
    }

    if (controller.selectedCategory.value != null) {
      return 'Search ${controller.selectedCategory.value} recipes...';
    }

    return 'Search recipes...';
  }

  // ================================================================
  // LIVE SUGGESTIONS
  // ================================================================

  Widget _buildSuggestions(
    BuildContext context,
    Color primaryText,
    Color secondaryText,
    Color borderColor,
    Color brandColor,
  ) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final suggestions = controller.suggestions;

    final suggestionBackground =
        isDark ? AppColors.darkSurface : AppColors.surface;

    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.35)
        : AppColors.shadow;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        0,
      ),

      constraints: const BoxConstraints(
        maxHeight: 310,
      ),

      decoration: BoxDecoration(
        color: suggestionBackground,

        borderRadius: BorderRadius.circular(17),

        border: Border.all(
          color: borderColor,
        ),

        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: controller.isSuggestionLoading.value
          ? Padding(
              padding: const EdgeInsets.all(24),

              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: brandColor,
                ),
              ),
            )
          : suggestions.isEmpty
              ? _buildNoSuggestions(
                  primaryText,
                  secondaryText,
                )
              : ListView.separated(
                  shrinkWrap: true,

                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),

                  itemCount: suggestions.length,

                  separatorBuilder: (_, __) {
                    return Divider(
                      height: 1,
                      indent: 68,
                      endIndent: 16,
                      color: borderColor,
                    );
                  },

                  itemBuilder: (context, index) {
                    final recipe = suggestions[index];

                    return _buildSuggestionTile(
                      context,
                      recipe,
                      primaryText,
                      secondaryText,
                      brandColor,
                    );
                  },
                ),
    );
  }

  // ================================================================
  // SUGGESTION TILE
  // ================================================================

  Widget _buildSuggestionTile(
    BuildContext context,
    RecipeModel recipe,
    Color primaryText,
    Color secondaryText,
    Color brandColor,
  ) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final imageFallbackColor = isDark
        ? AppColors.darkBackground
        : AppColors.primaryLight;

    return InkWell(
      onTap: () {
        controller.selectSuggestion(recipe);
      },

      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 9,
        ),

        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),

              child: Image.network(
                recipe.image,

                width: 48,
                height: 48,

                fit: BoxFit.cover,

                errorBuilder: (_, __, ___) {
                  return Container(
                    width: 48,
                    height: 48,

                    color: imageFallbackColor,

                    child: Icon(
                      Icons.restaurant_rounded,
                      color: brandColor,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    recipe.name,

                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      color: primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  if (recipe.area.isNotEmpty) ...[
                    const SizedBox(height: 4),

                    Text(
                      recipe.area,

                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              color: secondaryText.withValues(alpha: 0.5),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // NO SUGGESTIONS
  // ================================================================

  Widget _buildNoSuggestions(
    Color primaryText,
    Color secondaryText,
  ) {
    return Padding(
      padding: const EdgeInsets.all(22),

      child: Row(
        children: [
          Icon(
            Icons.search_off_rounded,
            color: secondaryText.withValues(alpha: 0.6),
          ),

          const SizedBox(width: 12),

          Text(
            'No matching recipes',

            style: TextStyle(
              color: primaryText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // FILTER SECTION
  // ================================================================

  Widget _buildFilterSection(
    BuildContext context,
    Color primaryText,
    Color secondaryText,
    Color borderColor,
    Color brandColor,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        2,
      ),

      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Filters',

                style: TextStyle(
                  color: primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const Spacer(),

              if (controller.hasActiveFilters)
                GestureDetector(
                  onTap: () {
                    controller.clearArea();
                    controller.clearCategory();
                  },

                  child: Text(
                    'Clear all',

                    style: TextStyle(
                      color: brandColor,
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
              children: [
                _filterButton(
                  context,
                  icon: Icons.restaurant_menu_rounded,
                  title: 'Category',
                  value:
                      controller.selectedCategory.value,
                  onTap: _showCategorySheet,
                  brandColor: brandColor,
                ),

                const SizedBox(width: 8),

                _filterButton(
                  context,
                  icon: Icons.public_rounded,
                  title: 'Cuisine',
                  value: controller.selectedArea.value,
                  onTap: _showAreaSheet,
                  brandColor: brandColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // FILTER BUTTON
  // ================================================================

  Widget _filterButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String? value,
    required VoidCallback onTap,
    required Color brandColor,
  }) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final isSelected =
        value != null && value.trim().isNotEmpty;

    final unselectedBackground =
        isDark ? AppColors.darkSurface : AppColors.surface;

    final unselectedText =
        isDark
            ? AppColors.darkTextSecondary
            : AppColors.textSecondary;

    final unselectedBorder =
        isDark ? AppColors.darkBorder : AppColors.border;

    final textColor = isSelected
        ? brandColor
        : isDark
            ? AppColors.darkTextPrimary
            : AppColors.textPrimary;

    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(13),

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 9,
        ),

        decoration: BoxDecoration(
          color: isSelected
              ? brandColor.withValues(alpha: 0.10)
              : unselectedBackground,

          borderRadius: BorderRadius.circular(13),

          border: Border.all(
            color: isSelected
                ? brandColor
                : unselectedBorder,
          ),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(
              icon,
              size: 17,

              color: isSelected
                  ? brandColor
                  : unselectedText,
            ),

            const SizedBox(width: 7),

            Text(
              isSelected ? value! : title,

              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(width: 5),

            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 17,

              color: isSelected
                  ? brandColor
                  : unselectedText,
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // CATEGORY BOTTOM SHEET
  // ================================================================

  void _showCategorySheet() {
    Get.bottomSheet(
      _buildSelectionSheet(
        title: 'Select Category',

        items: controller.categories,

        selected: controller.selectedCategory.value,

        onSelected: (value) {
          Get.back();
          controller.setCategory(value);
        },
      ),

      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // ================================================================
  // AREA BOTTOM SHEET
  // ================================================================

  void _showAreaSheet() {
    Get.bottomSheet(
      _buildSelectionSheet(
        title: 'Select Cuisine',

        items: controller.areas,

        selected: controller.selectedArea.value,

        onSelected: (value) {
          Get.back();
          controller.setArea(value);
        },
      ),

      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // ================================================================
  // SELECTION SHEET
  // ================================================================

  Widget _buildSelectionSheet({
    required String title,
    required List<String> items,
    required String? selected,
    required ValueChanged<String> onSelected,
  }) {
    final isDark = Get.isDarkMode;

    final sheetColor =
        isDark ? AppColors.darkSurface : AppColors.surface;

    final primaryText =
        isDark
            ? AppColors.darkTextPrimary
            : AppColors.textPrimary;

    final secondaryText =
        isDark
            ? AppColors.darkTextSecondary
            : AppColors.textSecondary;

    final borderColor =
        isDark ? AppColors.darkBorder : AppColors.border;

    final chipColor =
        isDark
            ? AppColors.darkBackground
            : AppColors.chipBackground;

    final brandColor = AppColors.primary;

    return SafeArea(
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 520,
        ),

        decoration: BoxDecoration(
          color: sheetColor,

          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(26),
          ),

          border: Border(
            top: BorderSide(
              color: borderColor,
            ),
          ),
        ),

        child: Column(
          children: [
            const SizedBox(height: 10),

            Container(
              width: 42,
              height: 4,

              decoration: BoxDecoration(
                color: secondaryText.withValues(
                  alpha: 0.35,
                ),

                borderRadius:
                    BorderRadius.circular(10),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                18,
                20,
                12,
              ),

              child: Text(
                title,

                style: TextStyle(
                  color: primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: items.length,

                itemBuilder: (context, index) {
                  final item = items[index];

                  final isSelected =
                      selected?.toLowerCase() ==
                          item.toLowerCase();

                  return ListTile(
                    onTap: () {
                      onSelected(item);
                    },

                    leading: Container(
                      width: 38,
                      height: 38,

                      decoration: BoxDecoration(
                        color: isSelected
                            ? brandColor.withValues(
                                alpha: 0.12,
                              )
                            : chipColor,

                        shape: BoxShape.circle,
                      ),

                      child: Icon(
                        Icons.restaurant_rounded,
                        size: 19,

                        color: isSelected
                            ? brandColor
                            : secondaryText,
                      ),
                    ),

                    title: Text(
                      item,

                      style: TextStyle(
                        color: primaryText,
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w500,
                      ),
                    ),

                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: brandColor,
                          )
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // CURRENT TITLE
  // ================================================================

  Widget _buildCurrentTitle(
    Color primaryText,
    Color secondaryText,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),

      child: Row(
        children: [
          Expanded(
            child: Obx(
              () {
                String title;

                if (controller.selectedArea.value != null) {
                  title =
                      '${controller.selectedArea.value} Recipes';
                } else if (
                    controller.selectedCategory.value != null) {
                  title =
                      '${controller.selectedCategory.value} Recipes';
                } else if (
                    controller.searchQuery.value.isNotEmpty) {
                  title = 'Search Results';
                } else {
                  title = 'Discover Recipes';
                }

                return Text(
                  title,

                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    color: primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                );
              },
            ),
          ),

          Obx(
            () {
              final count =
                  controller.displayedResults.length;

              if (count == 0) {
                return const SizedBox.shrink();
              }

              return Text(
                '$count recipes',

                style: TextStyle(
                  color: secondaryText,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ================================================================
  // RESULTS
  // ================================================================

  Widget _buildResults(
    BuildContext context,
    Color primaryText,
    Color secondaryText,
    Color borderColor,
    Color brandColor,
  ) {
    return Obx(
      () {
        if (controller.isLoading.value) {
          return _buildLoading(context, brandColor);
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return _buildError(
            primaryText,
            secondaryText,
            brandColor,
          );
        }

        if (controller.displayedResults.isEmpty) {
          return _buildEmpty(
            primaryText,
            secondaryText,
            brandColor,
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(
            16,
            6,
            16,
            30,
          ),

          physics: const BouncingScrollPhysics(),

          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 14,
            childAspectRatio: 0.68,
          ),

          itemCount:
              controller.displayedResults.length,

          itemBuilder: (context, index) {
            final recipe =
                controller.displayedResults[index];

            return _buildRecipeCard(
              context,
              recipe,
              primaryText,
              secondaryText,
              brandColor,
            );
          },
        );
      },
    );
  }

  // ================================================================
  // RECIPE CARD
  // ================================================================

  Widget _buildRecipeCard(
    BuildContext context,
    RecipeModel recipe,
    Color primaryText,
    Color secondaryText,
    Color brandColor,
  ) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final cardColor =
        isDark ? AppColors.darkSurface : AppColors.surface;

    final cardBorder =
        isDark ? AppColors.darkBorder : AppColors.border;

    final imageFallbackColor =
        isDark
            ? AppColors.darkBackground
            : AppColors.primaryLight;

    final favoriteBackground =
        isDark
            ? AppColors.darkSurface.withValues(alpha: 0.92)
            : AppColors.surface.withValues(alpha: 0.92);

    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: () {
          controller.selectRecipe(recipe);
        },

        borderRadius: BorderRadius.circular(18),

        child: Container(
          decoration: BoxDecoration(
            color: cardColor,

            borderRadius: BorderRadius.circular(18),

            border: Border.all(
              color: cardBorder,
            ),

            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.28)
                    : AppColors.shadow,
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),

          clipBehavior: Clip.antiAlias,

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Expanded(
                flex: 7,

                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        recipe.image,

                        fit: BoxFit.cover,

                        errorBuilder: (_, __, ___) {
                          return Container(
                            color: imageFallbackColor,

                            child: Center(
                              child: Icon(
                                Icons.restaurant_rounded,
                                color: brandColor,
                                size: 40,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // =================================================
                    // FAVORITE BUTTON
                    // =================================================

                    Positioned(
                      top: 8,
                      right: 8,

                      child: Container(
                        width: 34,
                        height: 34,

                        decoration: BoxDecoration(
                          color: favoriteBackground,

                          shape: BoxShape.circle,

                          border: Border.all(
                            color: cardBorder,
                          ),
                        ),

                        child: Icon(
                          Icons.favorite_border_rounded,
                          color: brandColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 4,

                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    10,
                    9,
                    10,
                    8,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Text(
                        recipe.name,

                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,

                        style: TextStyle(
                          color: primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const Spacer(),

                      if (recipe.area.isNotEmpty)
                        Text(
                          recipe.area,

                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,

                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 11,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // LOADING
  // ================================================================

  Widget _buildLoading(
    BuildContext context,
    Color brandColor,
  ) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final surfaceColor =
        isDark ? AppColors.darkSurface : AppColors.surface;

    final borderColor =
        isDark ? AppColors.darkBorder : AppColors.border;

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(
        16,
        6,
        16,
        30,
      ),

      physics:
          const NeverScrollableScrollPhysics(),

      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 14,
        childAspectRatio: 0.68,
      ),

      itemCount: 6,

      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: surfaceColor,

            borderRadius:
                BorderRadius.circular(18),

            border: Border.all(
              color: borderColor,
            ),
          ),

          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: brandColor,
            ),
          ),
        );
      },
    );
  }

  // ================================================================
  // EMPTY
  // ================================================================

  Widget _buildEmpty(
    Color primaryText,
    Color secondaryText,
    Color brandColor,
  ) {
    final isDark = Get.isDarkMode;

    final emptyCircleColor = isDark
        ? brandColor.withValues(alpha: 0.14)
        : AppColors.primaryLight;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              width: 82,
              height: 82,

              decoration: BoxDecoration(
                color: emptyCircleColor,
                shape: BoxShape.circle,
              ),

              child: Icon(
                Icons.search_rounded,
                color: brandColor,
                size: 40,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              controller.searchQuery.value.isEmpty
                  ? 'Find your next recipe'
                  : 'No recipes found',

              textAlign: TextAlign.center,

              style: TextStyle(
                color: primaryText,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              controller.searchQuery.value.isEmpty
                  ? 'Search by recipe name, cuisine or ingredient.'
                  : 'Try another recipe name or change your filters.',

              textAlign: TextAlign.center,

              style: TextStyle(
                color: secondaryText,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // ERROR
  // ================================================================

  Widget _buildError(
    Color primaryText,
    Color secondaryText,
    Color brandColor,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(
              Icons.cloud_off_rounded,
              color: brandColor,
              size: 55,
            ),

            const SizedBox(height: 15),

            Text(
              'Something went wrong',

              style: TextStyle(
                color: primaryText,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              controller.errorMessage.value,

              textAlign: TextAlign.center,

              style: TextStyle(
                color: secondaryText,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 18),

            ElevatedButton(
              onPressed: controller.retry,

              style: ElevatedButton.styleFrom(
                backgroundColor: brandColor,

                foregroundColor:
                    AppColors.textWhite,

                elevation: 0,

                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),

              child: const Text(
                'Try Again',
              ),
            ),
          ],
        ),
      ),
    );
  }
}