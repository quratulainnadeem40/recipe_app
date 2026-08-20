import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/home/models/recipe_models.dart';
import 'package:recipe_app/features/search/controllers/search_controller.dart'
    as search_controller;

class SearchSuggestions extends StatelessWidget {
  const SearchSuggestions({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<search_controller.SearchController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(
      () {
        // =====================================================
        // NO QUERY
        // =====================================================
        if (controller.searchQuery.value.trim().isEmpty) {
          return const SizedBox.shrink();
        }

        // =====================================================
        // LOADING
        // =====================================================
        if (controller.isSuggestionLoading.value) {
          return Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? theme.colorScheme.surfaceContainerHighest
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white10
                    : theme.colorScheme.outline.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Finding recipes...',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        // =====================================================
        // NO SUGGESTIONS
        // =====================================================
        if (controller.suggestions.isEmpty) {
          return const SizedBox.shrink();
        }

        // =====================================================
        // SUGGESTION LIST CONTAINER
        // =====================================================
        final containerBg = isDark
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.surface;

        final borderColor = isDark
            ? Colors.white10
            : theme.colorScheme.outline.withValues(alpha: 0.12);

        return Container(
          margin: const EdgeInsets.only(top: 8),
          constraints: const BoxConstraints(maxHeight: 380),
          decoration: BoxDecoration(
            color: containerBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                      color: Colors.black.withValues(alpha: 0.08),
                    ),
                  ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 6),
            itemCount: controller.suggestions.length,
            separatorBuilder: (context, index) {
              return Divider(
                height: 1,
                color: isDark
                    ? Colors.white10
                    : theme.colorScheme.outline.withValues(alpha: 0.08),
              );
            },
            itemBuilder: (context, index) {
              final recipe = controller.suggestions[index];

              return _SuggestionItem(
                recipe: recipe,
                onTap: () {
                  controller.selectSuggestion(recipe);
                },
              );
            },
          ),
        );
      },
    );
  }
}

// =============================================================
// SUGGESTION ITEM
// =============================================================

class _SuggestionItem extends StatelessWidget {
  final RecipeModel recipe;
  final VoidCallback onTap;

  const _SuggestionItem({
    required this.recipe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: Row(
            children: [
              // =================================================
              // RECIPE IMAGE
              // =================================================
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  recipe.image,
                  width: 46,
                  height: 46,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 46,
                      height: 46,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.restaurant_rounded,
                        size: 20,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              // =================================================
              // RECIPE INFORMATION
              // =================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${recipe.area} • ${recipe.category}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}