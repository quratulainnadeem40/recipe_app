import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/core/routes/app_routes.dart';
import 'package:recipe_app/features/home/models/recipe_models.dart'; // RecipeModel import
import 'package:recipe_app/features/home/repositories/home_repository.dart'; // Repository import
import 'package:recipe_app/features/search/controllers/search_controller.dart'; // RecipeSearchController import

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  // DYNAMIC SAFE GETTER: Agar route bindings miss bhi ho jayein, toh yeh automatic
  // controller register kar dega aur Null subtype error nahi aane dega!
  RecipeSearchController get controller {
    if (Get.isRegistered<RecipeSearchController>()) {
      return Get.find<RecipeSearchController>();
    } else {
      return Get.put(RecipeSearchController(repository: Get.find<HomeRepository>()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Search Recipes',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =================================================
            // SEARCH FIELD
            // =================================================
            TextField(
              controller: controller.searchTextController,
              onChanged: (value) {
                controller.searchRecipes(value);
              },
              decoration: InputDecoration(
                hintText: 'Search for recipes...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune, color: Colors.green),
                  onPressed: () => _showFilterModal(context),
                ),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // =================================================
            // HORIZONTAL QUICK FILTERS ROW
            // =================================================
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Difficulty'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Cuisine'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Time'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Diet'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // =================================================
            // SEARCH RESULTS (Obx List View)
            // =================================================
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  );
                }

                // Controller ke filteredResults list se data pull ho raha hai
                final recipes = controller.filteredResults;
                if (recipes.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 60, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'No recipes found',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: recipes.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return _buildRecipeCard(recipe);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Filter Chip Generator Helper
  Widget _buildFilterChip(String label) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          _buildFilterSheet(label),
          isScrollControlled: true,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF666666),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, color: Color(0xFF999999), size: 18),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // RECIPE CARD WIDGET
  // ===========================================================
  Widget _buildRecipeCard(RecipeModel recipe) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.recipeDetails,
          arguments: recipe,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF0F0F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Safe Image Handling (Using RecipeModel variables)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12), 
                bottomLeft: Radius.circular(12),
              ),
              child: recipe.image.isNotEmpty
                  ? Image.network(
                      recipe.image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 100, 
                        height: 100, 
                        color: Colors.grey,
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    )
                  : Container(
                      width: 100, 
                      height: 100, 
                      color: Colors.grey,
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
            ),
            const SizedBox(width: 12),
            // Recipe Info Column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: const TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.category_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          recipe.category.isNotEmpty ? recipe.category : 'General',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          recipe.area.isNotEmpty ? recipe.area : 'Global',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        recipe.category.isNotEmpty ? recipe.category : 'Healthy',
                        style: const TextStyle(
                          fontSize: 10, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================
  // BOTTOM SHEET QUICK OPTIONS
  // ===========================================================
  Widget _buildFilterSheet(String filterType) {
    Widget optionsWidget = const SizedBox();
    if (filterType == 'Difficulty') optionsWidget = _buildDifficultyOptions();
    if (filterType == 'Cuisine') optionsWidget = _buildCuisineOptions();
    if (filterType == 'Time') optionsWidget = _buildTimeOptions();
    if (filterType == 'Diet') optionsWidget = _buildDietOptions();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(filterType, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Get.back()),
            ],
          ),
          const SizedBox(height: 16),
          optionsWidget,
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => Get.back(),
              child: const Text('Apply Filter', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyOptions() {
    return Wrap(
      spacing: 8,
      children: ['Easy', 'Medium', 'Hard'].map((difficulty) {
        return Obx(() {
          final selected = controller.activeFilters.contains(difficulty);
          return FilterChip(
            label: Text(difficulty),
            selected: selected,
            onSelected: (value) => value ? controller.addFilter(difficulty) : controller.removeFilter(difficulty),
            selectedColor: Colors.green.withOpacity(0.2),
            checkmarkColor: Colors.green,
          );
        });
      }).toList(),
    );
  }

  Widget _buildCuisineOptions() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: controller.areas.take(6).map((cuisine) {
        return Obx(() {
          final isSelected = controller.selectedCuisine.value == cuisine;
          return ChoiceChip(
            label: Text(cuisine),
            selected: isSelected,
            onSelected: (value) => controller.selectedCuisine.value = value ? cuisine : '',
            selectedColor: Colors.green.withOpacity(0.2),
          );
        });
      }).toList(),
    );
  }

  Widget _buildTimeOptions() {
    return Wrap(
      spacing: 8,
      children: ['Under 15 min', 'Under 30 min', 'Under 60 min'].map((time) {
        return Obx(() {
          final isSelected = controller.activeFilters.contains(time);
          return FilterChip(
            label: Text(time),
            selected: isSelected,
            onSelected: (value) => value ? controller.addFilter(time) : controller.removeFilter(time),
            selectedColor: Colors.green.withOpacity(0.2),
          );
        });
      }).toList(),
    );
  }

  Widget _buildDietOptions() {
    return Wrap(
      spacing: 8,
      children: ['Vegetarian', 'Vegan', 'Healthy'].map((diet) {
        return Obx(() {
          final isSelected = controller.activeFilters.contains(diet);
          return FilterChip(
            label: Text(diet),
            selected: isSelected,
            onSelected: (value) => value ? controller.addFilter(diet) : controller.removeFilter(diet),
            selectedColor: Colors.green.withOpacity(0.2),
          );
        });
      }).toList(),
    );
  }

  // ===========================================================
  // MAIN FILTER BOTTOM SHEET MODAL
  // ===========================================================
  void _showFilterModal(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Filter Recipes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Get.back()),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              const Text('Difficulty', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildDifficultyOptions(),
              const SizedBox(height: 16),
              const Text('Cuisine (Dynamic Areas)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildCuisineOptions(),
              const SizedBox(height: 16),
              const Text('Prep Time', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildTimeOptions(),
              const SizedBox(height: 16),
              const Text('Dietary Preferences', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildDietOptions(),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        controller.clearAllFilters();
                        Get.back();
                      },
                      child: const Text('Clear All'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () => Get.back(),
                      child: const Text('Apply Filters', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}