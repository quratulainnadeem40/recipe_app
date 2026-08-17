import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/search_controller.dart'
    as search_controller;

import '../../../home/models/recipe_models.dart';

class SearchSuggestions extends StatelessWidget {
  const SearchSuggestions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.find<search_controller.SearchController>();

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
            margin: const EdgeInsets.only(
              top: 8,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surface,
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Finding recipes...',
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
        // SUGGESTION LIST
        // =====================================================

        return Container(
          margin: const EdgeInsets.only(
            top: 8,
          ),
          constraints: const BoxConstraints(
            maxHeight: 380,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surface,
            borderRadius:
                BorderRadius.circular(14),
            border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .outline
                  .withValues(alpha: 0.15),
            ),
            boxShadow: const [
              BoxShadow(
                blurRadius: 12,
                offset: Offset(0, 4),
                color: Colors.black12,
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(
              vertical: 6,
            ),
            itemCount:
                controller.suggestions.length,
            separatorBuilder:
                (context, index) {
              return Divider(
                height: 1,
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.10),
              );
            },
            itemBuilder:
                (context, index) {
              final recipe =
                  controller.suggestions[index];

              return _SuggestionItem(
                recipe: recipe,
                onTap: () {
                  controller.selectSuggestion(
                    recipe,
                  );
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

    // IMPORTANT:
    // Material + Ink fixes the Flutter
    // "ListTile background color or ink splashes"
    // warning.

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 7,
          ),
          child: Row(
            children: [
              // =================================================
              // IMAGE
              // =================================================

              ClipRRect(
                borderRadius:
                    BorderRadius.circular(8),
                child: Image.network(
                  recipe.image,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) {
                    return Container(
                      width: 48,
                      height: 48,
                      color: theme
                          .colorScheme
                          .surfaceContainerHighest,
                      child: const Icon(
                        Icons
                            .restaurant_rounded,
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
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${recipe.area} • ${recipe.category}',
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons
                    .arrow_forward_ios_rounded,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}