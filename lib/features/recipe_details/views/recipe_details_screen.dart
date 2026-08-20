import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/recipe_details_controller.dart';
import '../model/recipe_detail_model.dart';
import 'widgets/cooking_voice_bar.dart';

class RecipeDetailScreen extends GetView<RecipeDetailsController> {
  const RecipeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          body: _RecipeLoadingView(),
        );
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Scaffold(
          body: _RecipeErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.retry,
          ),
        );
      }

      final recipe = controller.recipeDetails.value;

      if (recipe == null) {
        return Scaffold(
          body: _RecipeErrorView(
            message: 'Recipe details not available.',
            onRetry: controller.retry,
          ),
        );
      }

      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: _RecipeContent(recipe: recipe),
        bottomNavigationBar: const CookingVoiceBar(),
      );
    });
  }
}

// =============================================================
// RECIPE CONTENT
// =============================================================

class _RecipeContent extends StatelessWidget {
  final RecipeDetailsModel recipe;

  const _RecipeContent({
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecipeDetailsController>();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: _HeroSection(recipe: recipe),
        ),

        SliverToBoxAdapter(
          child: _RecipeHeader(recipe: recipe),
        ),

        SliverToBoxAdapter(
          child: _RecipeMeta(recipe: recipe),
        ),

        SliverToBoxAdapter(
          child: _IngredientsSection(recipe: recipe),
        ),

        SliverToBoxAdapter(
          child: _InstructionsHeader(
            totalSteps: controller.totalSteps,
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            16,
            4,
            16,
            30,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _InstructionCard(
                  stepNumber: index + 1,
                  instruction:
                      controller.instructionSteps[index],
                  index: index,
                );
              },
              childCount: controller.instructionSteps.length,
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================
// HERO SECTION
// =============================================================

class _HeroSection extends StatelessWidget {
  final RecipeDetailsModel recipe;

  const _HeroSection({
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecipeDetailsController>();

    return SizedBox(
      height: 330,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'recipe-image-${recipe.id}',
            child: recipe.thumbUrl.isNotEmpty
                ? Image.network(
                    recipe.thumbUrl,
                    fit: BoxFit.cover,
                    loadingBuilder:
                        (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return const _ImageLoading();
                    },
                    errorBuilder: (_, __, ___) {
                      return const _ImageError();
                    },
                  )
                : const _ImageError(),
          ),

          // Hero gradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.50),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.20),
                  ],
                ),
              ),
            ),
          ),

          // Back
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: _CircleButton(
              icon: Icons.arrow_back_rounded,
              onTap: Get.back,
            ),
          ),

          // Favorite
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: Obx(
              () => _CircleButton(
                icon: controller.isFavorite.value
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                iconColor: controller.isFavorite.value
                    ? Colors.redAccent
                    : Colors.white,
                onTap: controller.toggleFavorite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// RECIPE HEADER
// =============================================================

class _RecipeHeader extends StatelessWidget {
  final RecipeDetailsModel recipe;

  const _RecipeHeader({
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final subtitle = _buildSubtitle(recipe);

    final secondaryColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        22,
        20,
        8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipe.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              height: 1.15,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.public_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 7),

              Expanded(
                child: Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: secondaryColor,
                  ),
                ),
              ),
            ],
          ),

          if (recipe.tags.isNotEmpty) ...[
            const SizedBox(height: 14),

            SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recipe.tags.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return _TagChip(
                    text: recipe.tags[index],
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _buildSubtitle(RecipeDetailsModel recipe) {
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

    return 'Delicious Recipe';
  }
}

// =============================================================
// META
// =============================================================

class _RecipeMeta extends StatelessWidget {
  final RecipeDetailsModel recipe;

  const _RecipeMeta({
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        8,
      ),
      child: Row(
        children: [
          Expanded(
            child: _MetaCard(
              icon: Icons.restaurant_menu_rounded,
              title: 'Category',
              value: recipe.category.isEmpty
                  ? 'Recipe'
                  : recipe.category,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: _MetaCard(
              icon: Icons.public_rounded,
              title: 'Cuisine',
              value: recipe.area.isEmpty
                  ? 'International'
                  : recipe.area,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: _MetaCard(
              icon: Icons.shopping_basket_rounded,
              title: 'Ingredients',
              value: '${recipe.ingredients.length}',
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// META CARD
// =============================================================

class _MetaCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _MetaCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.border;

    final secondaryText = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 21,
            color: AppColors.primary,
          ),

          const SizedBox(height: 7),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: secondaryText,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelLarge?.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// INGREDIENTS SECTION
// =============================================================

class _IngredientsSection extends StatelessWidget {
  final RecipeDetailsModel recipe;

  const _IngredientsSection({
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (recipe.ingredients.isEmpty) {
      return const SizedBox.shrink();
    }

    final cardColor = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.border;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        24,
        20,
        8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Ingredients',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              Text(
                '${recipe.ingredients.length} items',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: borderColor,
              ),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                vertical: 6,
              ),
              itemCount: recipe.ingredients.length,
              separatorBuilder: (_, __) {
                return Divider(
                  height: 1,
                  indent: 72,
                  endIndent: 16,
                  color: borderColor,
                );
              },
              itemBuilder: (context, index) {
                return _IngredientRow(
                  item: recipe.ingredients[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// INGREDIENT ROW
// =============================================================

class _IngredientRow extends StatelessWidget {
  final IngredientItem item;

  const _IngredientRow({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final iconBackground = isDark
        ? AppColors.primary.withValues(alpha: 0.16)
        : AppColors.primaryLight;

    final primaryText = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 11,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.restaurant_rounded,
              size: 20,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Text(
              _capitalize(item.name),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 10),

          if (item.measure.isNotEmpty)
            Flexible(
              child: Text(
                item.measure,
                maxLines: 2,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() + value.substring(1);
  }
}

// =============================================================
// INSTRUCTIONS HEADER
// =============================================================

class _InstructionsHeader extends StatelessWidget {
  final int totalSteps;

  const _InstructionsHeader({
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final chipBackground = isDark
        ? AppColors.primary.withValues(alpha: 0.15)
        : AppColors.primaryLight;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Cooking Instructions',
              style: theme.textTheme.titleLarge?.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          if (totalSteps > 0)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: chipBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$totalSteps steps',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// =============================================================
// INSTRUCTION CARD
// =============================================================

class _InstructionCard extends StatelessWidget {
  final int stepNumber;
  final String instruction;
  final int index;

  const _InstructionCard({
    required this.stepNumber,
    required this.instruction,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecipeDetailsController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.border;

    final inactiveCircle = isDark
        ? AppColors.primary.withValues(alpha: 0.15)
        : AppColors.primaryLight;

    return Obx(() {
      final isCurrent =
          controller.currentStepIndex.value == index;

      final isSpeaking =
          controller.isSpeaking.value && isCurrent;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: isCurrent
              ? (isDark
                  ? AppColors.primary.withValues(alpha: 0.13)
                  : AppColors.primaryLight)
              : cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCurrent
                ? AppColors.primary.withValues(alpha: 0.45)
                : borderColor,
            width: isCurrent ? 1.4 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? AppColors.primary
                        : inactiveCircle,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    stepNumber.toString().padLeft(2, '0'),
                    style: TextStyle(
                      color: isCurrent
                          ? Colors.white
                          : AppColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ),

                const Spacer(),

                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      controller.selectStep(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isSpeaking
                                ? Icons.volume_up_rounded
                                : Icons.volume_up_outlined,
                            size: 19,
                            color: AppColors.primary,
                          ),

                          const SizedBox(width: 5),

                          Text(
                            isSpeaking ? 'Speaking' : 'Listen',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Text(
              instruction,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
                height: 1.65,
                fontWeight:
                    isCurrent ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    });
  }
}

// =============================================================
// TAG CHIP
// =============================================================

class _TagChip extends StatelessWidget {
  final String text;

  const _TagChip({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final background = isDark
        ? AppColors.primary.withValues(alpha: 0.15)
        : AppColors.primaryLight;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// =============================================================
// CIRCLE BUTTON
// =============================================================

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.42),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            icon,
            color: iconColor,
            size: 23,
          ),
        ),
      ),
    );
  }
}

// =============================================================
// IMAGE LOADING
// =============================================================

class _ImageLoading extends StatelessWidget {
  const _ImageLoading();

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark
          ? AppColors.darkBackground
          : AppColors.primaryLight,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }
}

// =============================================================
// IMAGE ERROR
// =============================================================

class _ImageError extends StatelessWidget {
  const _ImageError();

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark
          ? AppColors.darkBackground
          : AppColors.primaryLight,
      child: const Center(
        child: Icon(
          Icons.restaurant_rounded,
          size: 70,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

// =============================================================
// LOADING SCREEN
// =============================================================

class _RecipeLoadingView extends StatelessWidget {
  const _RecipeLoadingView();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }
}

// =============================================================
// ERROR SCREEN
// =============================================================

class _RecipeErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _RecipeErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final circleBackground = isDark
        ? AppColors.primary.withValues(alpha: 0.15)
        : AppColors.primaryLight;

    final primaryText = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    final secondaryText = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: circleBackground,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.restaurant_rounded,
                  size: 38,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Recipe Not Available',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: primaryText,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: secondaryText,
                ),
              ),

              const SizedBox(height: 22),

              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(
                  Icons.refresh_rounded,
                ),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}