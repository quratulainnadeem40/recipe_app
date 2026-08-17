
import 'package:flutter/material.dart';

import 'package:recipe_app/features/home/models/recipe_models.dart';

class RecentSearchRecipeCard
    extends StatelessWidget {
  final RecipeModel recipe;

  final VoidCallback onTap;

  final VoidCallback onRemove;

  const RecentSearchRecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      decoration: BoxDecoration(
        color:
            theme.colorScheme.surface,

        borderRadius:
            BorderRadius.circular(18),
      ),

      child: InkWell(
        onTap: onTap,

        borderRadius:
            BorderRadius.circular(18),

        child: Padding(
          padding:
              const EdgeInsets.all(10),

          child: Row(
            children: [
              // =================================================
              // IMAGE
              // =================================================

              ClipRRect(
                borderRadius:
                    BorderRadius.circular(14),

                child: SizedBox(
                  width: 78,
                  height: 78,

                  child: Image.network(
                    recipe.image,

                    fit: BoxFit.cover,

                    loadingBuilder:
                        (
                      context,
                      child,
                      progress,
                    ) {
                      if (progress ==
                          null) {
                        return child;
                      }

                      return const Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },

                    errorBuilder:
                        (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return Container(
                        color: theme
                            .colorScheme
                            .surfaceContainerHighest,

                        child:
                            const Center(
                          child: Icon(
                            Icons
                                .restaurant_rounded,
                            size: 30,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              // =================================================
              // INFORMATION
              // =================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      recipe.name,

                      maxLines: 2,

                      overflow:
                          TextOverflow.ellipsis,

                      style:
                          const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    Text(
                      recipe.category,

                      maxLines: 1,

                      overflow:
                          TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 13,
                        color: theme
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      recipe.area,

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

              // =================================================
              // REMOVE
              // =================================================

              IconButton(
                onPressed: onRemove,

                tooltip: 'Remove',

                icon: const Icon(
                  Icons.close_rounded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
