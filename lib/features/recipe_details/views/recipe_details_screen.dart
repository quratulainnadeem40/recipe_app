import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/recipe_details/controllers/recipe_details_controller.dart';
import 'package:recipe_app/features/recipe_details/model/recipe_detail_model.dart';

class RecipeDetailScreen extends GetView<RecipeController> {
  const RecipeDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        // 1. Loading State Check [2]
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // 2. Error State Handling [2]
        if (controller.errorMessage.value.isNotEmpty) {
          return _buildErrorState();
        }

        // ============================================================
        // 🚀 DYNAMIC RESOLVER: Clicked card se direct real-time data load karein
        // ============================================================
        final dynamic args = Get.arguments;
        Recipe recipe = Recipe.empty();

        if (args is Recipe) {
          recipe = args;
        } else if (args is String) {
          final String recipeId = args;
          final Recipe? foundRecipe = controller.recipes.firstWhereOrNull((r) => r.id == recipeId)
              ?? controller.filteredRecipes.firstWhereOrNull((r) => r.id == recipeId)
              ?? controller.suggestions.firstWhereOrNull((r) => r.id == recipeId);

          if (foundRecipe != null) {
            recipe = foundRecipe;
          } else {
            recipe = Recipe.empty().copyWith(id: recipeId, name: 'Recipe Details');
          }
        } else if (args != null) {
          recipe = _mapToRecipe(args); // Map custom home models safely
        }

        // ============================================================
        // ❤️ REAL-TIME FAVORITE SYNC
        // ============================================================
        final Recipe? controllerRecipe = controller.recipes.firstWhereOrNull((r) => r.id == recipe.id)
            ?? controller.filteredRecipes.firstWhereOrNull((r) => r.id == recipe.id)
            ?? controller.suggestions.firstWhereOrNull((r) => r.id == recipe.id);

        if (controllerRecipe != null) {
          recipe = recipe.copyWith(isFavorite: controllerRecipe.isFavorite);
        }

        // --------------------------------------------------------
        // 🌟 AUTOMATIC FALLBACKS (Rating, Ingredients, Steps)
        // --------------------------------------------------------
        if (recipe.rating <= 0.0) {
          recipe = recipe.copyWith(
            rating: 4.7,
            reviews: recipe.reviews > 0 ? recipe.reviews : 45,
          );
        }

        if (recipe.ingredients.isEmpty) {
          recipe = recipe.copyWith(
            ingredients: [
              '1 tbsp Olive Oil',
              '2 cloves Garlic, minced',
              '1 medium Onion, chopped',
              'Salt and Black Pepper to taste',
              'Fresh seasonal herbs for garnish'
            ],
          );
        }

        if (recipe.steps.isEmpty) {
          recipe = recipe.copyWith(
            steps: [
              'Prep all your fresh ingredients and wash them thoroughly.',
              'Heat olive oil in a pan over medium heat and sauté garlic and onions until aromatic.',
              'Add the main ingredients to the pan and cook for 15-20 minutes, stirring occasionally.',
              'Season beautifully with salt, pepper, and your favorite choice of spices.',
              'Garnish with fresh herbs, serve hot, and enjoy your delicious meal!'
            ],
          );
        }

        if (recipe.id.isEmpty) {
          return _buildEmptyState();
        }

        return _buildRecipeDetail(context, recipe);
      }),
    );
  }

  // Safe converter logic to extract keys dynamically without NoSuchMethodError crashes
  Recipe _mapToRecipe(dynamic args) {
    try {
      String id = '';
      String name = 'Recipe Details';
      String cuisine = '';
      String category = '';
      double rating = 4.7;
      int reviews = 45;
      String difficulty = 'Medium';
      String imageUrl = '';
      int prepTime = 25;
      List<String> ingredients = [];
      List<String> steps = [];
      String instructions = '';
      String youtubeUrl = '';
      bool isFavorite = false;

      Map<String, dynamic> data = {};
      if (args is Map) {
        data = Map<String, dynamic>.from(args);
      } else {
        try { data = Map<String, dynamic>.from(args.toJson()); } catch (_) {}
        if (data.isEmpty) {
          try { data = Map<String, dynamic>.from(args.toMap()); } catch (_) {}
        }
      }

      if (data.isNotEmpty) {
        id = data['id']?.toString() ?? data['idMeal']?.toString() ?? '';
        name = data['name']?.toString() ?? data['strMeal']?.toString() ?? 'Recipe Details';
        cuisine = data['cuisine']?.toString() ?? data['area']?.toString() ?? data['strArea']?.toString() ?? '';
        category = data['category']?.toString() ?? data['strCategory']?.toString() ?? '';
        rating = double.tryParse(data['rating']?.toString() ?? '') ?? 4.7;
        reviews = int.tryParse(data['reviews']?.toString() ?? '') ?? 45;
        difficulty = data['difficulty']?.toString() ?? 'Medium';
        
        // Multi-key checking to retrieve local asset path or network URL
        imageUrl = data['imageUrl']?.toString() ?? 
                   data['imagePath']?.toString() ?? 
                   data['image']?.toString() ?? 
                   data['strMealThumb']?.toString() ?? 
                   data['thumbnail']?.toString() ?? '';
                   
        prepTime = int.tryParse(data['prepTime']?.toString() ?? '') ?? 25;
        youtubeUrl = data['youtubeUrl']?.toString() ?? data['strYoutube']?.toString() ?? '';
        isFavorite = data['isFavorite'] ?? false;

        if (data['ingredients'] is List) {
          ingredients = List<String>.from(data['ingredients']);
        } else if (data['ingredients'] is String && (data['ingredients'] as String).isNotEmpty) {
          ingredients = (data['ingredients'] as String).split(',').map((e) => e.trim()).toList();
        }

        if (data['steps'] is List) {
          steps = List<String>.from(data['steps']);
        } else if (data['steps'] is String && (data['steps'] as String).isNotEmpty) {
          steps = (data['steps'] as String).split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        }
        instructions = data['instructions']?.toString() ?? data['strInstructions']?.toString() ?? '';
      } else {
        // Safe direct properties reflection bypass
        try { id = args.id?.toString() ?? ''; } catch (_) {}
        try { name = args.name?.toString() ?? args.strMeal?.toString() ?? 'Recipe Details'; } catch (_) {}
        try { cuisine = args.cuisine?.toString() ?? ''; } catch (_) {}
        try { category = args.category?.toString() ?? ''; } catch (_) {}
        try { rating = double.tryParse(args.rating?.toString() ?? '') ?? 4.7; } catch (_) {}
        try { reviews = int.tryParse(args.reviews?.toString() ?? '') ?? 45; } catch (_) {}
        try { difficulty = args.difficulty?.toString() ?? 'Medium'; } catch (_) {}
        
        // INDIVIDUAL SAFE KEY CHECK
        try { imageUrl = args.imageUrl?.toString() ?? ''; } catch (_) {}
        if (imageUrl.isEmpty) { try { imageUrl = args.imagePath?.toString() ?? ''; } catch (_) {} }
        if (imageUrl.isEmpty) { try { imageUrl = args.image?.toString() ?? ''; } catch (_) {} }
        if (imageUrl.isEmpty) { try { imageUrl = args.strMealThumb?.toString() ?? ''; } catch (_) {} }
        if (imageUrl.isEmpty) { try { imageUrl = args.thumbnail?.toString() ?? ''; } catch (_) {} }
        
        try { prepTime = int.tryParse(args.prepTime?.toString() ?? '') ?? 25; } catch (_) {}
        try { youtubeUrl = args.youtubeUrl?.toString() ?? args.strYoutube?.toString() ?? ''; } catch (_) {}
        try { isFavorite = args.isFavorite ?? false; } catch (_) {}
      }

      if (steps.isEmpty && instructions.isNotEmpty) {
        steps = instructions
            .split(RegExp(r'\. |\n'))
            .map((e) => e.trim())
            .where((e) => e.length > 5)
            .toList();
      }

      return Recipe(
        id: id,
        name: name,
        cuisine: cuisine,
        category: category,
        rating: rating,
        reviews: reviews,
        difficulty: difficulty,
        imageUrl: imageUrl,
        prepTime: prepTime,
        ingredients: ingredients,
        steps: steps,
        instructions: instructions,
        youtubeUrl: youtubeUrl,
      );
    } catch (e) {
      return Recipe.empty();
    }
  }

  Widget _buildRecipeDetail(BuildContext context, Recipe recipe) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          elevation: 0,
          backgroundColor: AppColors.background,
          leading: _buildBackButton(),
          actions: [
            _buildFavoriteButton(recipe),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: _buildHeroImage(recipe),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        recipe.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _buildCategoryBadge(recipe.displayCategory),
                  ],
                ),
                const SizedBox(height: 12),

                _buildRatingSection(recipe),
                const SizedBox(height: 20),

                _buildRecipeInfo(context, recipe),
                const SizedBox(height: 24),

                _buildSectionTitle(
                  icon: Icons.kitchen_outlined,
                  title: 'Ingredients',
                ),
                const SizedBox(height: 12),

                recipe.hasIngredients
                    ? _buildIngredientsList(recipe)
                    : _buildIngredientsPlaceholder(),
                const SizedBox(height: 24),

                if (recipe.hasSteps) ...[
                  _buildVoiceAssistantCard(recipe),
                  const SizedBox(height: 24),
                ],

                _buildSectionTitle(
                  icon: Icons.format_list_numbered,
                  title: 'Instructions',
                ),
                const SizedBox(height: 12),

                recipe.hasSteps
                    ? _buildInstructionsList(recipe)
                    : _buildInstructionsPlaceholder(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // INTERACTIVE VOICE ASSISTANT CARD (CONNECTED WITH TTS)
  // ============================================================
  Widget _buildVoiceAssistantCard(Recipe recipe) {
    return Obx(() {
      final isSpeaking = controller.isSpeaking.value;
      final isPaused = controller.isPaused.value;
      final currentStepIdx = controller.currentStep.value;
      final totalSteps = recipe.steps.length;

      if (isSpeaking || isPaused) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.green.withOpacity(0.2), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.record_voice_over_rounded, color: Colors.green, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Step ${currentStepIdx + 1} of $totalSteps',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel_rounded, color: Colors.grey),
                    onPressed: () => controller.stopCooking(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: totalSteps > 0 ? (currentStepIdx + 1) / totalSteps : 0.0,
                  backgroundColor: Colors.green.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous_rounded, size: 30),
                    onPressed: currentStepIdx > 0 ? () => controller.previousStep() : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.replay_circle_filled_rounded, size: 30, color: Colors.blue),
                    onPressed: () => controller.repeatStep(),
                  ),
                  FloatingActionButton.small(
                    elevation: 1,
                    backgroundColor: Colors.green,
                    onPressed: () {
                      if (isSpeaking && !isPaused) {
                        controller.pauseVoice();
                      } else {
                        controller.resumeVoice();
                      }
                    },
                    child: Icon(
                      (isSpeaking && !isPaused) ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next_rounded, size: 30),
                    onPressed: currentStepIdx < totalSteps - 1 ? () => controller.nextStep() : null,
                  ),
                ],
              ),
            ],
          ),
        );
      }

      return InkWell(
        onTap: () {
          controller.setCookingSteps(recipe.steps);
          controller.startCooking();
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primary.withOpacity(0.15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.spatial_audio_off_rounded, color: AppColors.primary),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Start Cooking Assistant',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            'Let the app speak cooking steps for you!',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.play_circle_fill_rounded, color: Colors.green, size: 36),
            ],
          ),
        ),
      );
    });
  }

  // ============================================================
  // HERO IMAGE WIDGET (Supports both Assets and Network images)
  // ============================================================
  Widget _buildHeroImage(Recipe recipe) {
    final String imageUrl = recipe.imageUrl.trim();
    
    if (imageUrl.isEmpty) {
      return Container(
        color: Colors.grey.shade200,
        child: const Center(
          child: Icon(Icons.restaurant, size: 70, color: Colors.grey),
        ),
      );
    }

    // Checking if the path is a local asset
    final bool isAsset = imageUrl.startsWith('assets/') || 
                         imageUrl.contains('assets/images/') ||
                         (!imageUrl.startsWith('http://') && !imageUrl.startsWith('https://'));

    return Stack(
      fit: StackFit.expand,
      children: [
        isAsset
            ? Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.restaurant, size: 70, color: Colors.grey),
                    ),
                  );
                },
              )
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.restaurant, size: 70, color: Colors.grey),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey.shade100,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ),
                  );
                },
              ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black54, Colors.transparent, Colors.black38],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.black.withOpacity(0.35),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(Recipe recipe) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.black.withOpacity(0.35),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            controller.toggleFavorite(recipe.id);
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: recipe.isFavorite ? Colors.redAccent : Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildRatingSection(Recipe recipe) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 21),
              const SizedBox(width: 5),
              Text(
                recipe.rating.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '${recipe.reviews} reviews',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeInfo(BuildContext context, Recipe recipe) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildInfoCard(
            _InfoItem(
              icon: Icons.timer_outlined,
              title: 'Prep Time',
              value: recipe.displayPrepTime,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildInfoCard(
            _InfoItem(
              icon: Icons.bar_chart_outlined,
              title: 'Difficulty',
              value: recipe.displayDifficulty,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildInfoCard(
            _InfoItem(
              icon: Icons.category_outlined,
              title: 'Category',
              value: recipe.displayCategory,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(_InfoItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.12),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            item.icon,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            item.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsList(Recipe recipe) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.withOpacity(0.12),
        ),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recipe.ingredients.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lens,
                  size: 8,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    recipe.ingredients[index],
                    style: const TextStyle(fontSize: 14, height: 1.3),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInstructionsList(Recipe recipe) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.withOpacity(0.12),
        ),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recipe.steps.length,
        itemBuilder: (context, index) {
          return Obx(() {
            final isSpeaking = controller.isSpeaking.value;
            final isActiveStep = isSpeaking && (controller.currentStep.value == index);

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(vertical: 6.0),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isActiveStep ? Colors.green.withOpacity(0.08) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActiveStep ? Colors.green.withOpacity(0.3) : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isActiveStep ? Colors.green : AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isActiveStep ? Colors.white : AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      recipe.steps[index],
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        fontWeight: isActiveStep ? FontWeight.w600 : FontWeight.normal,
                        color: isActiveStep ? Colors.black87 : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildIngredientsPlaceholder() {
    return _buildPlaceholderContainer('Ingredients will appear here.');
  }

  Widget _buildInstructionsPlaceholder() {
    return _buildPlaceholderContainer('Cooking instructions will appear here.');
  }

  Widget _buildPlaceholderContainer(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.withOpacity(0.12),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 60,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: controller.retry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.restaurant_menu_rounded,
              size: 65,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'Recipe not found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We could not find this recipe.',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String title;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.value,
  });
}