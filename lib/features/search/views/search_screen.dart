import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/routes/app_routes.dart';
import 'package:recipe_app/features/home/controllers/home_controller.dart';
import 'package:recipe_app/features/home/models/recipe_models.dart';
import 'package:recipe_app/features/home/views/widgets/recipe_card.dart';

class SearchScreen extends GetView<HomeController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isDark =
        theme.brightness == Brightness.dark;

    final Color backgroundColor =
        theme.scaffoldBackgroundColor;

    final Color surfaceColor =
        colorScheme.surface;

    final Color primaryColor =
        colorScheme.primary;

    final Color textColor =
        colorScheme.onSurface;

    final Color secondaryTextColor =
        theme.textTheme.bodyMedium?.color?.withValues(
              alpha: 0.65,
            ) ??
            colorScheme.onSurface.withValues(
              alpha: 0.65,
            );

    final Color borderColor = isDark
        ? const Color(0xFF444444)
        : const Color(0xFFE3D8D0);

    final Color filterColor = isDark
        ? const Color(0xFF3A2D38)
        : const Color(0xFFFFEBDD);

    return Scaffold(
      backgroundColor: backgroundColor,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text(
          'Search Recipes',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(
            24,
            10,
            24,
            30,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              // ===================================================
              // SEARCH BAR + LIVE SUGGESTIONS
              // ===================================================

              _buildSearchBar(
                context,
                surfaceColor,
                primaryColor,
                textColor,
                secondaryTextColor,
                borderColor,
              ),

              const SizedBox(height: 30),

              // ===================================================
              // POPULAR SEARCHES
              // ===================================================

              _buildSectionTitle(
                'Popular Searches',
                textColor,
              ),

              const SizedBox(height: 14),

              _buildPopularSearches(
                surfaceColor,
                textColor,
                borderColor,
              ),

              const SizedBox(height: 30),

              // ===================================================
              // EXPLORE BY CUISINE
              // ===================================================

              _buildSectionTitle(
                'Explore by Cuisine',
                textColor,
              ),

              const SizedBox(height: 14),

              _buildCuisineSection(
                surfaceColor,
                textColor,
                borderColor,
              ),

              const SizedBox(height: 30),

              // ===================================================
              // QUICK FILTERS
              // ===================================================

              _buildSectionTitle(
                'Quick Filters',
                textColor,
              ),

              const SizedBox(height: 14),

              _buildQuickFilters(
                filterColor,
                textColor,
                primaryColor,
                borderColor,
              ),

              const SizedBox(height: 35),

              // ===================================================
              // SEARCH RESULTS / EMPTY STATE
              // ===================================================

              Obx(
                () {
                  if (controller.isSearching.value) {
                    return SizedBox(
                      height: 300,
                      child: Center(
                        child:
                            CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      ),
                    );
                  }

                  if (controller
                      .searchErrorMessage
                      .value
                      .isNotEmpty) {
                    return _buildErrorState(
                      textColor,
                      secondaryTextColor,
                      primaryColor,
                    );
                  }

                  if (controller
                      .searchResults
                      .isNotEmpty) {
                    return _buildSearchResults(
                      textColor,
                    );
                  }

                  return _buildEmptyState(
                    surfaceColor,
                    textColor,
                    secondaryTextColor,
                    primaryColor,
                    borderColor,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // SEARCH BAR + LIVE SUGGESTIONS
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
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        // =========================================================
        // SEARCH BAR
        // =========================================================

        Container(
          height: 68,

          decoration: BoxDecoration(
            color: surfaceColor,

            borderRadius:
                BorderRadius.circular(20),

            border: Border.all(
              color: borderColor,
              width: 1.2,
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.04,
                ),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child: Row(
            children: [
              // ===================================================
              // SEARCH ICON
              // ===================================================

              Padding(
                padding:
                    const EdgeInsets.only(
                  left: 18,
                  right: 12,
                ),

                child: Icon(
                  Icons.search_rounded,
                  color: primaryColor,
                  size: 30,
                ),
              ),

              // ===================================================
              // TEXT FIELD
              // ===================================================

              Expanded(
                child: TextField(
                  controller:
                      controller.searchTextController,

                  textInputAction:
                      TextInputAction.search,

                  // =================================================
                  // LIVE SEARCH
                  // =================================================

                  onChanged: (value) {
                    controller
                        .onSearchTextChanged(
                      value,
                    );
                  },

                  // =================================================
                  // ENTER / SEARCH
                  // =================================================

                  onSubmitted: (value) {
                    FocusManager
                        .instance
                        .primaryFocus
                        ?.unfocus();

                    controller.searchRecipes(
                      value,
                    );
                  },

                  style: TextStyle(
                    color: textColor,
                    fontSize: 17,
                  ),

                  cursorColor: primaryColor,

                  decoration:
                      InputDecoration(
                    hintText:
                        'Search recipes...',

                    hintStyle: TextStyle(
                      color:
                          secondaryTextColor,
                      fontSize: 17,
                    ),

                    border:
                        InputBorder.none,

                    isDense: true,

                    filled: false,

                    contentPadding:
                        EdgeInsets.zero,
                  ),
                ),
              ),

              // ===================================================
              // SEARCH BUTTON
              // ===================================================

              GestureDetector(
                onTap: () {
                  FocusManager
                      .instance
                      .primaryFocus
                      ?.unfocus();

                  controller.searchRecipes(
                    controller
                        .searchTextController
                        .text,
                  );
                },

                child: Container(
                  width: 52,
                  height: 52,

                  margin:
                      const EdgeInsets.only(
                    right: 7,
                  ),

                  decoration:
                      BoxDecoration(
                    color: primaryColor,

                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
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
        // LIVE SUGGESTIONS
        // =========================================================

        Obx(
          () {
            final bool showSuggestions =
                controller
                    .showSuggestions
                    .value;

            if (!showSuggestions) {
              return const SizedBox.shrink();
            }

            final bool isLoading =
                controller
                    .isSuggestionLoading
                    .value;

            final List<RecipeModel>
                suggestions =
                controller
                    .searchSuggestions
                    .toList();

            // =====================================================
            // SUGGESTION CONTAINER
            // =====================================================

            return Container(
              width: double.infinity,

              margin:
                  const EdgeInsets.only(
                top: 8,
              ),

              decoration: BoxDecoration(
                color: surfaceColor,

                borderRadius:
                    BorderRadius.circular(16),

                border: Border.all(
                  color: borderColor,
                  width: 1.1,
                ),

                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withValues(
                      alpha: 0.06,
                    ),
                    blurRadius: 12,
                    offset:
                        const Offset(0, 4),
                  ),
                ],
              ),

              child: isLoading &&
                      suggestions.isEmpty
                  ? const Padding(
                      padding:
                          EdgeInsets.all(20),

                      child: Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,

                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    )
                  : suggestions.isEmpty
                      ? Padding(
                          padding:
                              const EdgeInsets
                                  .all(18),

                          child: Text(
                            'No recipes found',
                            style: TextStyle(
                              color:
                                  secondaryTextColor,
                              fontSize: 14,
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            for (
                              int index = 0;
                              index <
                                  suggestions.length;
                              index++
                            )
                              _buildSuggestionItem(
                                context,
                                suggestions[index],
                                surfaceColor,
                                textColor,
                                secondaryTextColor,
                                borderColor,
                                primaryColor,
                                index ==
                                    suggestions
                                            .length -
                                        1,
                              ),
                          ],
                        ),
            );
          },
        ),
      ],
    );
  }

  // =============================================================
  // LIVE SUGGESTION ITEM
  // =============================================================

  Widget _buildSuggestionItem(
    BuildContext context,
    RecipeModel recipe,
    Color surfaceColor,
    Color textColor,
    Color secondaryTextColor,
    Color borderColor,
    Color primaryColor,
    bool isLast,
  ) {
    return InkWell(
      borderRadius:
          BorderRadius.circular(16),

      onTap: () {
        // =======================================================
        // PUT SELECTED RECIPE NAME IN SEARCH FIELD
        // =======================================================

        controller.selectSearchSuggestion(
          recipe,
        );

        // =======================================================
        // SEARCH SELECTED RECIPE
        // =======================================================

        controller.searchRecipes(
          recipe.name,
        );

        FocusManager
            .instance
            .primaryFocus
            ?.unfocus();
      },

      child: Container(
        width: double.infinity,

        padding:
            const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),

        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: borderColor,
                    width: 0.8,
                  ),
                ),
        ),

        child: Row(
          children: [
            // ===================================================
            // RECIPE IMAGE
            // ===================================================

            ClipRRect(
              borderRadius:
                  BorderRadius.circular(10),

              child: SizedBox(
                width: 52,
                height: 52,

                child: Image.network(
                  recipe.image,

                  fit: BoxFit.cover,

                  errorBuilder:
                      (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return Container(
                      color: borderColor,

                      child: Icon(
                        Icons
                            .restaurant_rounded,
                        color: textColor,
                        size: 24,
                      ),
                    );
                  },

                  loadingBuilder:
                      (
                    context,
                    child,
                    loadingProgress,
                  ) {
                    if (loadingProgress ==
                        null) {
                      return child;
                    }

                    return const Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 12),

            // ===================================================
            // RECIPE INFORMATION
            // ===================================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    recipe.name,

                    maxLines: 1,

                    overflow:
                        TextOverflow.ellipsis,

                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '${recipe.area} • ${recipe.category}',

                    maxLines: 1,

                    overflow:
                        TextOverflow.ellipsis,

                    style: TextStyle(
                      color:
                          secondaryTextColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ===================================================
            // ARROW
            // ===================================================

            Icon(
              Icons
                  .arrow_forward_ios_rounded,
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

  Widget _buildSectionTitle(
    String title,
    Color textColor,
  ) {
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
    final List<String> searches = [
      'Chicken',
      'Pasta',
      'Dessert',
      'Beef',
      'Pizza',
      'Salad',
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,

      children: searches.map(
        (item) {
          return _buildChip(
            text: item,

            surfaceColor:
                surfaceColor,

            textColor: textColor,

            borderColor:
                borderColor,

            onTap: () {
              controller
                  .searchTextController
                  .text = item;

              controller.searchRecipes(
                item,
              );
            },
          );
        },
      ).toList(),
    );
  }

  // =============================================================
  // CUISINE SECTION
  // =============================================================

  Widget _buildCuisineSection(
    Color surfaceColor,
    Color textColor,
    Color borderColor,
  ) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,

      children: [
        _buildCuisineChip(
          flag: '🇵🇰',
          name: 'Pakistani',
          surfaceColor:
              surfaceColor,
          textColor: textColor,
          borderColor:
              borderColor,

          onTap: () {
            controller.getRecipesByCountry(
              'Pakistani',
            );
          },
        ),

        _buildCuisineChip(
          flag: '🇮🇳',
          name: 'Indian',
          surfaceColor:
              surfaceColor,
          textColor: textColor,
          borderColor:
              borderColor,

          onTap: () {
            controller.getRecipesByCountry(
              'Indian',
            );
          },
        ),

        _buildCuisineChip(
          flag: '🇺🇸',
          name: 'American',
          surfaceColor:
              surfaceColor,
          textColor: textColor,
          borderColor:
              borderColor,

          onTap: () {
            controller.getRecipesByCountry(
              'American',
            );
          },
        ),

        _buildCuisineChip(
          flag: '🇮🇹',
          name: 'Italian',
          surfaceColor:
              surfaceColor,
          textColor: textColor,
          borderColor:
              borderColor,

          onTap: () {
            controller.getRecipesByCountry(
              'Italian',
            );
          },
        ),
      ],
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

      borderRadius:
          BorderRadius.circular(18),

      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 11,
        ),

        decoration: BoxDecoration(
          color: surfaceColor,

          borderRadius:
              BorderRadius.circular(18),

          border: Border.all(
            color: borderColor,
            width: 1.1,
          ),
        ),

        child: Text(
          text,

          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // =============================================================
  // CUISINE CHIP
  // =============================================================

  Widget _buildCuisineChip({
    required String flag,
    required String name,
    required Color surfaceColor,
    required Color textColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius:
          BorderRadius.circular(18),

      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 11,
        ),

        decoration: BoxDecoration(
          color: surfaceColor,

          borderRadius:
              BorderRadius.circular(18),

          border: Border.all(
            color: borderColor,
            width: 1.1,
          ),
        ),

        child: Row(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            Text(
              flag,

              style: const TextStyle(
                fontSize: 19,
              ),
            ),

            const SizedBox(width: 7),

            Text(
              name,

              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
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
    final List<String> filters = [
      'Easy',
      'Under 30 min',
      'Vegetarian',
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,

      children: filters.map(
        (filter) {
          return Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 11,
            ),

            decoration: BoxDecoration(
              color: filterColor,

              borderRadius:
                  BorderRadius.circular(18),

              border: Border.all(
                color: borderColor,
                width: 1,
              ),
            ),

            child: Row(
              mainAxisSize:
                  MainAxisSize.min,

              children: [
                Icon(
                  Icons.tune_rounded,
                  color: primaryColor,
                  size: 17,
                ),

                const SizedBox(width: 6),

                Text(
                  filter,

                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ).toList(),
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
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [
          Container(
            width: 88,
            height: 88,

            decoration: BoxDecoration(
              color: surfaceColor,

              shape: BoxShape.circle,

              border: Border.all(
                color: borderColor,
                width: 1.2,
              ),
            ),

            child: Icon(
              Icons.search_rounded,
              color: primaryColor,
              size: 52,
            ),
          ),

          const SizedBox(height: 22),

          Text(
            'Search for a recipe',

            textAlign:
                TextAlign.center,

            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Find your favourite recipes by name.',

            textAlign:
                TextAlign.center,

            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // SEARCH RESULTS
  // =============================================================

  Widget _buildSearchResults(
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          'Search Results',

          style: TextStyle(
            color: textColor,
            fontSize: 23,
            fontWeight:
                FontWeight.w700,
          ),
        ),

        const SizedBox(height: 16),

        GridView.builder(
          shrinkWrap: true,

          physics:
              const NeverScrollableScrollPhysics(),

          itemCount:
              controller.searchResults.length,

          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 15,
            mainAxisExtent: 260,
          ),

          itemBuilder: (
            context,
            index,
          ) {
            final recipe =
                controller.searchResults[index];

            return RecipeCard(
              recipe: recipe,
              horizontal: false,

              onTap: () {
                Get.toNamed(
                  AppRoutes.recipeDetails,
                  arguments: recipe,
                );
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

  Widget _buildErrorState(
    Color textColor,
    Color secondaryTextColor,
    Color primaryColor,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 250,

      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

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
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            controller
                .searchErrorMessage
                .value,

            textAlign:
                TextAlign.center,

            style: TextStyle(
              color:
                  secondaryTextColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}