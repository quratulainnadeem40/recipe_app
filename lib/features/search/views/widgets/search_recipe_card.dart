import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/routes/app_routes.dart';
import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/home/models/recipe_models.dart';

class SearchRecipeCard extends StatelessWidget {
  final RecipeModel recipe;

  const SearchRecipeCard({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surface = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final primaryText = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    final secondaryText = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final border = isDark
        ? AppColors.darkBorder
        : AppColors.border;

    return InkWell(
      onTap: () {
        if (recipe.id.trim().isEmpty) {
          return;
        }

        Get.toNamed(
          AppRoutes.recipeDetails,
          arguments: recipe.id,
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: border,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // =====================================================
            // RECIPE IMAGE
            // =====================================================

            SizedBox(
              height: 135,
              width: double.infinity,
              child: _buildImage(
                recipe.image,
                surface,
                secondaryText,
              ),
            ),

            // =====================================================
            // RECIPE INFORMATION
            // =====================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                11,
                10,
                11,
                11,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name.trim().isNotEmpty
                        ? recipe.name
                        : 'Unknown Recipe',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 7),

                  // =================================================
                  // AREA + CATEGORY
                  // =================================================

                  Text(
                    _meta(recipe),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 9),

                  // =================================================
                  // BOTTOM INFO
                  // =================================================

                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.ratingStar,
                        size: 16,
                      ),

                      const SizedBox(width: 3),

                      Text(
                        '4.8',
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const Spacer(),

                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.primary,
                        size: 17,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // IMAGE
  // =============================================================

  Widget _buildImage(
    String imageUrl,
    Color background,
    Color iconColor,
  ) {
    final url = imageUrl.trim();

    if (url.isEmpty) {
      return _placeholder(
        background,
        iconColor,
      );
    }

    return Image.network(
      url,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,

      // ---------------------------------------------------------
      // ERROR
      // ---------------------------------------------------------

      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        return _placeholder(
          background,
          iconColor,
        );
      },

      // ---------------------------------------------------------
      // LOADING
      // ---------------------------------------------------------

      loadingBuilder: (
        context,
        child,
        loadingProgress,
      ) {
        if (loadingProgress == null) {
          return child;
        }

        return _placeholder(
          background,
          iconColor,
          loading: true,
        );
      },
    );
  }

  // =============================================================
  // PLACEHOLDER
  // =============================================================

  Widget _placeholder(
    Color background,
    Color iconColor, {
    bool loading = false,
  }) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: background,
      child: Center(
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: AppColors.primary,
                ),
              )
            : Icon(
                Icons.restaurant_rounded,
                color: iconColor,
                size: 34,
              ),
      ),
    );
  }

  // =============================================================
  // META
  // =============================================================

  String _meta(
    RecipeModel recipe,
  ) {
    final area = recipe.area.trim();
    final category = recipe.category.trim();

    if (area.isNotEmpty && category.isNotEmpty) {
      return '$area • $category';
    }

    if (area.isNotEmpty) {
      return area;
    }

    if (category.isNotEmpty) {
      return category;
    }

    return 'Recipe';
  }
}