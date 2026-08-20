import 'package:flutter/material.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
import '../../models/recipe_models.dart';

class RecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final bool horizontal;
  final VoidCallback? onTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.horizontal = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    final placeholderColor = isDark
        ? AppColors.darkSurface
        : AppColors.inputBackground;

    final card = Container(
      decoration: BoxDecoration(
        color: cardColor,

        borderRadius:
            BorderRadius.circular(16),

        border: Border.all(
          color: isDark
              ? AppColors.darkBorder
              : AppColors.border,
          width: 1,
        ),

        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: horizontal
          ? _buildHorizontalCard(
              textPrimary,
              textSecondary,
            )
          : _buildVerticalCard(
              textPrimary,
              textSecondary,
            ),
    );

    return GestureDetector(
      onTap: onTap,
      child: card,
    );
  }

  // ============================================================
  // VERTICAL CARD
  // ============================================================

  Widget _buildVerticalCard(
    Color textPrimary,
    Color textSecondary,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        AspectRatio(
          aspectRatio: 1.15,

          child: _buildImage(
            borderRadius:
                const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
        ),

        Padding(
          padding:
              const EdgeInsets.fromLTRB(
            10,
            9,
            10,
            11,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              // ==================================================
              // RECIPE NAME
              // ==================================================

              Text(
                recipe.name.trim().isNotEmpty
                    ? recipe.name
                    : 'Unknown Recipe',

                maxLines: 2,
                overflow:
                    TextOverflow.ellipsis,

                style: TextStyle(
                  fontWeight:
                      FontWeight.w700,
                  fontSize: 14,
                  height: 1.2,
                  color: textPrimary,
                ),
              ),

              const SizedBox(height: 5),

              // ==================================================
              // CATEGORY
              // ==================================================

              if (recipe.category
                  .trim()
                  .isNotEmpty)
                Text(
                  recipe.category,

                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,

                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

              // ==================================================
              // AREA
              // ==================================================

              if (recipe.area
                  .trim()
                  .isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.only(
                    top: 3,
                  ),

                  child: Text(
                    recipe.area,

                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,

                    style: TextStyle(
                      color: textSecondary
                          .withValues(
                        alpha: 0.75,
                      ),
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // HORIZONTAL CARD
  // ============================================================

  Widget _buildHorizontalCard(
    Color textPrimary,
    Color textSecondary,
  ) {
    return SizedBox(
      width: 210,

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          AspectRatio(
            aspectRatio: 1.15,

            child: _buildImage(
              borderRadius:
                  const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.fromLTRB(
              10,
              9,
              10,
              11,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // ==================================================
                // RECIPE NAME
                // ==================================================

                Text(
                  recipe.name.trim().isNotEmpty
                      ? recipe.name
                      : 'Unknown Recipe',

                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,

                  style: TextStyle(
                    fontWeight:
                        FontWeight.w700,
                    fontSize: 14,
                    height: 1.2,
                    color: textPrimary,
                  ),
                ),

                const SizedBox(height: 5),

                // ==================================================
                // CATEGORY
                // ==================================================

                if (recipe.category
                    .trim()
                    .isNotEmpty)
                  Text(
                    recipe.category,

                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,

                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // IMAGE
  // ============================================================

  Widget _buildImage({
    required BorderRadius borderRadius,
  }) {
    final imageUrl =
        recipe.image.trim();

    return ClipRRect(
      borderRadius: borderRadius,

      child: imageUrl.isEmpty
          ? _imagePlaceholder()
          : Image.network(
              imageUrl,

              width: double.infinity,
              height: double.infinity,

              fit: BoxFit.cover,

              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return _imagePlaceholder();
              },

              loadingBuilder: (
                context,
                child,
                loadingProgress,
              ) {
                if (loadingProgress == null) {
                  return child;
                }

                return _imageLoading();
              },
            ),
    );
  }

  // ============================================================
  // IMAGE PLACEHOLDER
  // ============================================================

  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,

      color: AppColors.primaryLight,

      child: const Center(
        child: Icon(
          Icons.restaurant_rounded,
          color: AppColors.primary,
          size: 34,
        ),
      ),
    );
  }

  // ============================================================
  // IMAGE LOADING
  // ============================================================

  Widget _imageLoading() {
    return Container(
      width: double.infinity,
      height: double.infinity,

      color: AppColors.primaryLight,

      child: const Center(
        child: SizedBox(
          width: 22,
          height: 22,

          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}