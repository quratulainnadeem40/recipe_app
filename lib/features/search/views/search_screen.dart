import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/routes/app_routes.dart';
import 'package:recipe_app/features/home/models/country_model.dart';
import 'package:recipe_app/features/home/data/country_data.dart';
import 'package:recipe_app/features/home/views/widgets/recipe_card.dart';

import '../controllers/search_controller.dart' as search_controller;

class SearchScreen extends GetView<search_controller.SearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = theme.scaffoldBackgroundColor;

    final surfaceColor = colorScheme.surface;

    final primaryColor = colorScheme.primary;

    final textColor = colorScheme.onSurface;

    final secondaryTextColor =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.65) ??
        colorScheme.onSurface.withValues(alpha: 0.65);

    final borderColor = isDark
        ? const Color(0xFF444444)
        : const Color(0xFFE3D8D0);

    final filterColor = isDark
        ? const Color(0xFF3A2D38)
        : const Color(0xFFFFEBDD);

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text(
          'Search Recipes',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // =====================================================
              // SEARCH BAR
              // =====================================================
              _buildSearchBar(
                context,
                surfaceColor,
                primaryColor,
                textColor,
                secondaryTextColor,
                borderColor,
              ),

              const SizedBox(height: 30),

              // =====================================================
              // POPULAR SEARCHES
              // =====================================================
              _buildSectionTitle('Popular Searches', textColor),

              const SizedBox(height: 14),

              _buildPopularSearches(surfaceColor, textColor, borderColor),

              const SizedBox(height: 30),

              // =====================================================
              // EXPLORE BY CUISINE
              // =====================================================
              _buildSectionTitle('Explore by Cuisine', textColor),

              const SizedBox(height: 14),

              _buildCuisineSection(surfaceColor, textColor, borderColor),

              const SizedBox(height: 30),

              // =====================================================
              // QUICK FILTERS
              // =====================================================
              _buildSectionTitle('Quick Filters', textColor),

              const SizedBox(height: 14),

              _buildQuickFilters(
                filterColor,
                textColor,
                primaryColor,
                borderColor,
              ),

              const SizedBox(height: 35),

              // =====================================================
              // RESULTS
              // =====================================================
              Obx(() {
                if (controller.isLoading.value) {
                  return SizedBox(
                    height: 300,
                    child: Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    ),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return _buildErrorState(textColor, secondaryTextColor);
                }

                if (controller.filteredResults.isNotEmpty) {
                  return _buildSearchResults(textColor);
                }

                return _buildEmptyState(
                  surfaceColor,
                  textColor,
                  secondaryTextColor,
                  primaryColor,
                  borderColor,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // SEARCH BAR
  // =============================================================

  Widget _buildSearchBar(
    BuildContext context,
    Color surfaceColor,
    Color primaryColor,
    Color textColor,
    Color secondaryTextColor,
    Color borderColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 68,

          decoration: BoxDecoration(
            color: surfaceColor,

            borderRadius: BorderRadius.circular(20),

            border: Border.all(color: borderColor, width: 1.2),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child: Row(
            children: [
              // SEARCH ICON
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 12),

                child: Icon(
                  Icons.search_rounded,
                  color: primaryColor,
                  size: 30,
                ),
              ),

              // TEXT FIELD
              Expanded(
                child: TextField(
                  textInputAction: TextInputAction.search,

                  onChanged: (value) {
                    controller.onSearchTextChanged(value);
                  },

                  onSubmitted: (value) {
                    FocusManager.instance.primaryFocus?.unfocus();

                    controller.searchRecipes(value);
                  },

                  style: TextStyle(color: textColor, fontSize: 17),

                  cursorColor: primaryColor,

                  decoration: InputDecoration(
                    hintText: 'Search recipes...',

                    hintStyle: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 17,
                    ),

                    border: InputBorder.none,

                    isDense: true,

                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),

              // SEARCH BUTTON
              GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();

                  controller.searchRecipes(controller.searchQuery.value);
                },

                child: Container(
                  width: 52,
                  height: 52,

                  margin: const EdgeInsets.only(right: 7),

                  decoration: BoxDecoration(
                    color: primaryColor,

                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 27,
                  ),
                ),
              ),
            ],
          ),
        ),

        // =========================================================
        // SUGGESTIONS
        // =========================================================
        Obx(() {
          final suggestions = controller.suggestions;

          if (controller.searchQuery.value.isEmpty) {
            return const SizedBox.shrink();
          }

          if (suggestions.isEmpty && !controller.isSuggestionLoading.value) {
            return const SizedBox.shrink();
          }

          return Container(
            width: double.infinity,

            margin: const EdgeInsets.only(top: 8),

            decoration: BoxDecoration(
              color: surfaceColor,

              borderRadius: BorderRadius.circular(16),

              border: Border.all(color: borderColor, width: 1.1),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: controller.isSuggestionLoading.value && suggestions.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20),

                    child: Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      for (int index = 0; index < suggestions.length; index++)
                        _buildSuggestionItem(
                          suggestions[index],
                          textColor,
                          secondaryTextColor,
                          borderColor,
                          primaryColor,
                          index == suggestions.length - 1,
                        ),
                    ],
                  ),
          );
        }),
      ],
    );
  }

  // =============================================================
  // SUGGESTION ITEM
  // =============================================================

  Widget _buildSuggestionItem(
    dynamic recipe,
    Color textColor,
    Color secondaryTextColor,
    Color borderColor,
    Color primaryColor,
    bool isLast,
  ) {
    return InkWell(
      onTap: () {
        controller.selectSuggestion(recipe);
      },

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(bottom: BorderSide(color: borderColor, width: 0.8)),
        ),

        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),

              child: SizedBox(
                width: 52,
                height: 52,

                child: Image.network(
                  recipe.image,
                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: borderColor,

                      child: Icon(Icons.restaurant_rounded, color: textColor),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    recipe.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '${recipe.area} • ${recipe.category}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(color: secondaryTextColor, fontSize: 12),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              color: primaryColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // SECTION TITLE
  // =============================================================

  Widget _buildSectionTitle(String title, Color textColor) {
    return Text(
      title,

      style: TextStyle(
        color: textColor,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // =============================================================
  // POPULAR SEARCHES
  // =============================================================

  Widget _buildPopularSearches(
    Color surfaceColor,
    Color textColor,
    Color borderColor,
  ) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,

      children: controller.categories.map((item) {
        return _buildChip(
          text: item,
          surfaceColor: surfaceColor,
          textColor: textColor,
          borderColor: borderColor,

          onTap: () {
            controller.searchRecipes(item);
          },
        );
      }).toList(),
    );
  }

  // =============================================================
  // CUISINE / COUNTRY SECTION
  // =============================================================

  Widget _buildCuisineSection(
    Color surfaceColor,
    Color textColor,
    Color borderColor,
  ) {
    return SizedBox(
      height: 125,

      child: ListView.separated(
        scrollDirection: Axis.horizontal,

        itemCount: CountryData.countries.length,

        separatorBuilder: (context, index) {
          return const SizedBox(width: 12);
        },

        itemBuilder: (context, index) {
          final CountryModel country = CountryData.countries[index];

          return _buildCountryItem(
            country,
            surfaceColor,
            textColor,
            borderColor,
          );
        },
      ),
    );
  }

  // =============================================================
  // COUNTRY ITEM
  // =============================================================

  Widget _buildCountryItem(
    CountryModel country,
    Color surfaceColor,
    Color textColor,
    Color borderColor,
  ) {
    return InkWell(
      onTap: () {
        // Apply country/area filter
        controller.setArea(country.area);
      },

      borderRadius: BorderRadius.circular(18),

      child: Container(
        width: 110,

        padding: const EdgeInsets.all(10),

        decoration: BoxDecoration(
          color: surfaceColor,

          borderRadius: BorderRadius.circular(18),

          border: Border.all(color: borderColor, width: 1),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(country.flag, style: const TextStyle(fontSize: 36)),

            const SizedBox(height: 8),

            Text(
              country.name,

              maxLines: 1,

              overflow: TextOverflow.ellipsis,

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // NORMAL CHIP
  // =============================================================

  Widget _buildChip({
    required String text,
    required Color surfaceColor,
    required Color textColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(18),

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),

        decoration: BoxDecoration(
          color: surfaceColor,

          borderRadius: BorderRadius.circular(18),

          border: Border.all(color: borderColor, width: 1.1),
        ),

        child: Text(
          text,

          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // =============================================================
  // QUICK FILTERS
  // =============================================================

  Widget _buildQuickFilters(
    Color filterColor,
    Color textColor,
    Color primaryColor,
    Color borderColor,
  ) {
    final filters = ['Easy', 'Under 30 min', 'Vegetarian'];

    return Wrap(
      spacing: 10,
      runSpacing: 10,

      children: filters.map((filter) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),

          decoration: BoxDecoration(
            color: filterColor,

            borderRadius: BorderRadius.circular(18),

            border: Border.all(color: borderColor, width: 1),
          ),

          child: Row(
            mainAxisSize: MainAxisSize.min,

            children: [
              Icon(Icons.tune_rounded, color: primaryColor, size: 17),

              const SizedBox(width: 6),

              Text(
                filter,

                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // =============================================================
  // EMPTY STATE
  // =============================================================

  Widget _buildEmptyState(
    Color surfaceColor,
    Color textColor,
    Color secondaryTextColor,
    Color primaryColor,
    Color borderColor,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 320,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Container(
            width: 88,
            height: 88,

            decoration: BoxDecoration(
              color: surfaceColor,

              shape: BoxShape.circle,

              border: Border.all(color: borderColor, width: 1.2),
            ),

            child: Icon(Icons.search_rounded, color: primaryColor, size: 52),
          ),

          const SizedBox(height: 22),

          Text(
            'Search for a recipe',

            textAlign: TextAlign.center,

            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Find your favourite recipes by name.',

            textAlign: TextAlign.center,

            style: TextStyle(color: secondaryTextColor, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // SEARCH RESULTS
  // =============================================================

  Widget _buildSearchResults(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          'Search Results',

          style: TextStyle(
            color: textColor,
            fontSize: 23,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 16),

        GridView.builder(
          shrinkWrap: true,

          physics: const NeverScrollableScrollPhysics(),

          itemCount: controller.filteredResults.length,

          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 15,
            mainAxisExtent: 260,
          ),

          itemBuilder: (context, index) {
            final recipe = controller.filteredResults[index];

            return RecipeCard(
              recipe: recipe,
              horizontal: false,

              onTap: () {
                Get.toNamed(AppRoutes.recipeDetails, arguments: recipe.id);
              },
            );
          },
        ),
      ],
    );
  }

  // =============================================================
  // ERROR STATE
  // =============================================================

  Widget _buildErrorState(Color textColor, Color secondaryTextColor) {
    return SizedBox(
      width: double.infinity,
      height: 250,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.redAccent,
            size: 50,
          ),

          const SizedBox(height: 12),

          Text(
            'Something went wrong',

            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            controller.errorMessage.value,

            textAlign: TextAlign.center,

            style: TextStyle(color: secondaryTextColor, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
