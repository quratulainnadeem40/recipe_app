import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/routes/app_routes.dart';
import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/home/controllers/home_controller.dart';
import 'package:recipe_app/features/home/views/widgets/recipe_card.dart';

class CategoryRecipesScreen extends StatefulWidget {
  final String category;

  const CategoryRecipesScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryRecipesScreen> createState() =>
      _CategoryRecipesScreenState();
}

class _CategoryRecipesScreenState
    extends State<CategoryRecipesScreen> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.find<HomeController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadCategoryRecipes(widget.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.background;

    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textPrimary,
            size: 20,
          ),
        ),

        title: Text(
          '${widget.category} Recipes',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),

        centerTitle: true,
      ),

      body: Obx(
        () {
          // ======================================================
          // LOADING
          // ======================================================

          if (controller.isCategoryLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          // ======================================================
          // ERROR
          // ======================================================

          if (controller.errorMessage.value.isNotEmpty &&
              controller.categoryRecipes.isEmpty) {
            return _buildErrorState(
              textPrimary,
              textSecondary,
            );
          }

          // ======================================================
          // EMPTY
          // ======================================================

          if (controller.categoryRecipes.isEmpty) {
            return _buildEmptyState(
              textPrimary,
              textSecondary,
            );
          }

          // ======================================================
          // RECIPES
          // ======================================================

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              30,
            ),

            physics: const BouncingScrollPhysics(),

            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 16,

              // Slightly taller card to prevent overflow.
              childAspectRatio: 0.68,
            ),

            itemCount:
                controller.categoryRecipes.length,

            itemBuilder: (context, index) {
              final recipe =
                  controller.categoryRecipes[index];

              return RecipeCard(
                recipe: recipe,
                horizontal: false,
                onTap: () {
                  if (recipe.id.trim().isEmpty) {
                    return;
                  }

                  Get.toNamed(
                    AppRoutes.recipeDetails,
                    arguments: recipe.id,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // ==============================================================
  // ERROR STATE
  // ==============================================================

  Widget _buildErrorState(
    Color textPrimary,
    Color textSecondary,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(
                  alpha: 0.10,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.restaurant_menu_rounded,
                color: AppColors.primary,
                size: 38,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              'Unable to load recipes',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textPrimary,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
  controller.loadCategoryRecipes(widget.category);
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,

                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(13),
                ),
              ),

              child: const Text(
                'Try Again',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // EMPTY STATE
  // ==============================================================

  Widget _buildEmptyState(
    Color textPrimary,
    Color textSecondary,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(
                  alpha: 0.10,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.restaurant_rounded,
                color: AppColors.primary,
                size: 38,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'No ${widget.category} recipes found',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              'Try another category.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}