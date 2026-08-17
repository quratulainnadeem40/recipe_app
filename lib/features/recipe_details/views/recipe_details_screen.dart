import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/theme/app_colors.dart';

import 'package:recipe_app/features/favorites/controllers/favorites_controller.dart';
import 'package:recipe_app/features/favorites/models/favorite_recipe_model.dart';

import 'package:recipe_app/features/recipe_details/controllers/recipe_details_controller.dart';

class RecipeDetailsScreen extends GetView<RecipeDetailsController> {
  const RecipeDetailsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor = isDarkMode
        ? AppColors.darkBackground
        : AppColors.lightBackground;

    final Color primaryColor = isDarkMode
        ? AppColors.darkPrimary
        : AppColors.primary;

    final Color textColor = isDarkMode
        ? Colors.white
        : const Color(0xFF2D202B);

    final Color secondaryTextColor = isDarkMode
        ? Colors.grey.shade300
        : Colors.grey.shade600;

    final Color cardColor = isDarkMode
        ? AppColors.darkSurface
        : Colors.white;

    // =========================================================
    // FAVORITES CONTROLLER
    // =========================================================

    final FavoritesController favoritesController =
        Get.find<FavoritesController>();

    return Scaffold(
      backgroundColor: backgroundColor,

      // =======================================================
      // APP BAR
      // =======================================================

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 22,
            color: isDarkMode
                ? Colors.white
                : AppColors.primary,
          ),
        ),

        title: Text(
          'Recipe Details',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),

      // =======================================================
      // BODY
      // =======================================================

      body: Obx(() {
        // =====================================================
        // LOADING
        // =====================================================

        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        }

        // =====================================================
        // ERROR
        // =====================================================

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(
                        alpha: 0.10,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.restaurant_rounded,
                      size: 42,
                      color: primaryColor,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    'Unable to load recipe',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: secondaryTextColor,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: controller.retry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // =====================================================
        // RECIPE DATA
        // =====================================================

        final recipe = controller.recipe.value;

        if (recipe == null) {
          return Center(
            child: Text(
              'Recipe not found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          );
        }

        // =====================================================
        // RECIPE ID
        // =====================================================

        final String recipeId = recipe.id.trim();

        // =====================================================
        // IMAGE LIST
        // =====================================================

        final List<String> images = recipe.images.isNotEmpty
            ? recipe.images
            : recipe.image.isNotEmpty
                ? [recipe.image]
                : [];

        // =====================================================
        // MAIN CONTENT
        // =====================================================

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =================================================
              // IMAGE GALLERY
              // =================================================

              if (images.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    8,
                    16,
                    0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 270,
                      child: Stack(
                        children: [
                          // =====================================
                          // IMAGE PAGE VIEW
                          // =====================================

                          PageView.builder(
                            itemCount: images.length,
                            onPageChanged: controller.changeImage,
                            itemBuilder: (
                              context,
                              index,
                            ) {
                              return _RecipeImage(
                                imageUrl: images[index],
                              );
                            },
                          ),

                          // =====================================
                          // FAVORITE BUTTON
                          // =====================================

                          Positioned(
                            top: 14,
                            right: 14,
                            child: Obx(() {
                              final bool isFavorite =
                                  recipeId.isNotEmpty &&
                                  favoritesController.isFavorite(
                                    recipeId,
                                  );

                              return Material(
                                color: Colors.white.withValues(
                                  alpha: 0.92,
                                ),
                                shape: const CircleBorder(),
                                child: IconButton(
                                  tooltip: isFavorite
                                      ? 'Remove from favorites'
                                      : 'Add to favorites',

                                  onPressed: recipeId.isEmpty
                                      ? null
                                      : () async {
                                          final favoriteRecipe =
                                              FavoriteRecipeModel(
                                            id: recipe.id.trim(),
                                            name: recipe.name,
                                            image: recipe.image,
                                          );

                                          await favoritesController
                                              .toggleFavorite(
                                            favoriteRecipe,
                                          );

                                          // =================================
                                          // CHECK UPDATED STATE
                                          // =================================

                                          final bool updatedFavorite =
                                              favoritesController
                                                  .isFavorite(
                                            recipeId,
                                          );

                                          if (updatedFavorite) {
                                            Get.snackbar(
                                              'Favorite Added',
                                              '${recipe.name} added to favorites.',
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              duration:
                                                  const Duration(
                                                seconds: 2,
                                              ),
                                            );
                                          } else {
                                            Get.snackbar(
                                              'Favorite Removed',
                                              '${recipe.name} removed from favorites.',
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              duration:
                                                  const Duration(
                                                seconds: 2,
                                              ),
                                            );
                                          }
                                        },

                                  // =================================
                                  // HEART ICON
                                  // =================================

                                  icon: AnimatedSwitcher(
                                    duration: const Duration(
                                      milliseconds: 200,
                                    ),
                                    transitionBuilder:
                                        (
                                      child,
                                      animation,
                                    ) {
                                      return ScaleTransition(
                                        scale: animation,
                                        child: child,
                                      );
                                    },
                                    child: Icon(
                                      isFavorite
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border_rounded,
                                      key: ValueKey<bool>(
                                        isFavorite,
                                      ),
                                      color: AppColors.primary,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),

                          // =====================================
                          // IMAGE LABEL
                          // =====================================

                          Positioned(
                            left: 18,
                            bottom: 16,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(
                                  alpha: 0.45,
                                ),
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Delicious Recipe',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                const _EmptyImage(),

              // =================================================
              // IMAGE INDICATORS
              // =================================================

              if (images.length > 1)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Obx(() {
                    final int currentIndex =
                        controller.currentImageIndex.value;

                    return Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: List.generate(
                        images.length,
                        (index) {
                          return _PageDot(
                            isActive:
                                currentIndex == index,
                          );
                        },
                      ),
                    );
                  }),
                ),

              // =================================================
              // RECIPE NAME
              // =================================================

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  22,
                  20,
                  8,
                ),
                child: Text(
                  recipe.name,
                  style: TextStyle(
                    fontSize: 30,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
              ),

              // =================================================
              // SUBTITLE
              // =================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Text(
                  'A delicious recipe worth trying',
                  style: TextStyle(
                    fontSize: 15,
                    color: secondaryTextColor,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // =================================================
              // CATEGORY + CUISINE
              // =================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.restaurant_menu_rounded,
                        title: 'Category',
                        value: recipe.category,
                        isDarkMode: isDarkMode,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _InfoCard(
                        icon: Icons.public_rounded,
                        title: 'Cuisine',
                        value: recipe.area,
                        isDarkMode: isDarkMode,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // =================================================
              // INGREDIENTS
              // =================================================

              _SectionHeading(
                title: 'Ingredients',
                color: primaryColor,
                textColor: textColor,
              ),

              const SizedBox(height: 14),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDarkMode ? 0.20 : 0.05,
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: List.generate(
                      recipe.ingredients.length,
                      (index) {
                        final String ingredient =
                            recipe.ingredients[index];

                        final String measure =
                            index < recipe.measures.length
                                ? recipe.measures[index]
                                : '';

                        return _IngredientItem(
                          ingredient: ingredient,
                          measure: measure,
                          isLast: index ==
                              recipe.ingredients.length - 1,
                          isDarkMode: isDarkMode,
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // =================================================
              // INSTRUCTIONS
              // =================================================

              _SectionHeading(
                title: 'Instructions',
                color: AppColors.orange,
                textColor: textColor,
              ),

              const SizedBox(height: 14),

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  35,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDarkMode ? 0.20 : 0.05,
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    recipe.instructions,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.7,
                      color: isDarkMode
                          ? Colors.grey.shade200
                          : Colors.grey.shade800,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
}

// =============================================================
// RECIPE IMAGE
// =============================================================

class _RecipeImage extends StatelessWidget {
  final String imageUrl;

  const _RecipeImage({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          imageUrl,
          fit: BoxFit.cover,

          loadingBuilder: (
            context,
            child,
            loadingProgress,
          ) {
            if (loadingProgress == null) {
              return child;
            }

            return Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },

          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            return Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: Icon(
                  Icons.restaurant_rounded,
                  size: 65,
                  color: Colors.grey,
                ),
              ),
            );
          },
        ),

        // =====================================================
        // BOTTOM GRADIENT
        // =====================================================

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 100,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(
                    alpha: 0.55,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================
// EMPTY IMAGE
// =============================================================

class _EmptyImage extends StatelessWidget {
  const _EmptyImage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          height: 270,
          color: Colors.grey.shade200,
          child: const Center(
            child: Icon(
              Icons.restaurant_rounded,
              size: 65,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================
// SECTION HEADING
// =============================================================

class _SectionHeading extends StatelessWidget {
  final String title;
  final Color color;
  final Color textColor;

  const _SectionHeading({
    required this.title,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 27,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(width: 10),

          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// INFO CARD
// =============================================================

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isDarkMode;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = isDarkMode
        ? Colors.white
        : const Color(0xFF2D202B);

    final Color secondaryColor = isDarkMode
        ? Colors.grey.shade300
        : Colors.grey.shade600;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(
          alpha: 0.07,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(
            alpha: 0.10,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(
                alpha: 0.12,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 21,
              color: isDarkMode
                  ? AppColors.darkPrimary
                  : AppColors.primary,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: secondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value.isEmpty
                      ? 'Not available'
                      : value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// INGREDIENT ITEM
// =============================================================

class _IngredientItem extends StatelessWidget {
  final String ingredient;
  final String measure;
  final bool isLast;
  final bool isDarkMode;

  const _IngredientItem({
    required this.ingredient,
    required this.measure,
    required this.isLast,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = isDarkMode
        ? Colors.white
        : const Color(0xFF30242E);

    final Color measureColor = isDarkMode
        ? Colors.grey.shade300
        : Colors.grey.shade600;

    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? 0 : 14,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(
                    alpha: 0.10,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 19,
                  color: isDarkMode
                      ? AppColors.darkPrimary
                      : AppColors.primary,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  ingredient,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),

              if (measure.isNotEmpty)
                Flexible(
                  child: Text(
                    measure,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14,
                      color: measureColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),

          if (!isLast) ...[
            const SizedBox(height: 14),

            Divider(
              height: 1,
              color: isDarkMode
                  ? Colors.grey.shade700
                  : Colors.grey.shade200,
            ),
          ],
        ],
      ),
    );
  }
}

// =============================================================
// PAGE DOT
// =============================================================

class _PageDot extends StatelessWidget {
  final bool isActive;

  const _PageDot({
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 200,
      ),
      width: isActive ? 20 : 7,
      height: 7,
      margin: const EdgeInsets.symmetric(
        horizontal: 3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isActive
            ? AppColors.primary
            : Colors.grey.shade400,
      ),
    );
  }
}