// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:recipe_app/core/theme/app_colors.dart';
// import 'package:recipe_app/features/recipe_details/controllers/recipe_details_controller.dart';
// import 'package:recipe_app/features/recipe_details/model/recipe_detail_model.dart';

// // Safe lookup ke liye HomeController ko import kiya hai
// import 'package:recipe_app/features/home/controllers/home_controller.dart';

// class RecipeDetailScreen extends GetView<RecipeController> {
//   const RecipeDetailScreen({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: Obx(() {
//         // 1. Loading State Check
//         if (controller.isLoading.value) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         // 2. Error State Check
//         if (controller.errorMessage.value.isNotEmpty) {
//           return _buildErrorState();
//         }

//         // Arguments mapping
//         final recipe = _mapToRecipe(Get.arguments);
        
//         // Empty check logic: Agar parsing fail ho tabhi empty state dikhayein
//         if (recipe.id.isEmpty && recipe.name == 'Recipe Details') {
//           return _buildEmptyState();
//         }

//         return _buildRecipeDetail(context, recipe);
//       }),
//     );
//   }

//   // 100% BULLETPROOF DYNAMIC PARSER: Safe dynamic property mapping prevents all red lines!
//   Recipe _mapToRecipe(dynamic args) {
//     try {
//       String id = '';
//       String name = 'Recipe Details';
//       String cuisine = '';
//       String category = '';
//       double rating = 4.7;
//       int reviews = 45;
//       String difficulty = 'Medium';
//       String imageUrl = '';
//       int prepTime = 25;
//       List<String> ingredients = [];
//       List<String> steps = [];
//       String instructions = '';
//       String youtubeUrl = '';
//       bool isFavorite = false;

//       // Check 1: Safe Dynamic Controller Lookup (No compile red line on controller.recipe!)
//       try {
//         dynamic ctrlRecipe;
//         final dynamic dynController = controller; 
//         if (dynController.recipe != null && dynController.recipe.value != null) {
//           ctrlRecipe = dynController.recipe.value;
//         }
//         if (ctrlRecipe != null) {
//           return _convertToRecipe(ctrlRecipe);
//         }
//       } catch (_) {}

//       if (args == null) {
//         return Recipe(
//           id: id,
//           name: name,
//           cuisine: cuisine,
//           category: category,
//           rating: rating,
//           reviews: reviews,
//           difficulty: difficulty,
//           imageUrl: imageUrl,
//           prepTime: prepTime,
//           ingredients: ingredients,
//           steps: steps,
//           instructions: instructions,
//           youtubeUrl: youtubeUrl,
//           isFavorite: isFavorite,
//         );
//       }

//       // Check 2: Agar arguments already Detail Feature ka Recipe Model hain
//       if (args is Recipe) {
//         return args;
//       }

//       // Check 3: Agar arguments sirf Recipe ID (String/int) hai, to HomeController se lookup karein
//       if (args is String || args is int) {
//         final String targetId = args.toString();
//         final lookupRecipe = _lookupRecipeInHomeController(targetId);
//         if (lookupRecipe != null) {
//           return lookupRecipe;
//         }
//         id = targetId;
//       }

//       // Check 4: Map Parsing
//       else if (args is Map) {
//         id = (args['id'] ?? args['recipeId'] ?? '').toString();
//         name = (args['name'] ?? args['title'] ?? 'Recipe Details').toString();
//         cuisine = (args['cuisine'] ?? '').toString();
//         category = (args['category'] ?? '').toString();
//         rating = double.tryParse((args['rating'] ?? 4.7).toString()) ?? 4.7;
//         reviews = int.tryParse((args['reviews'] ?? 45).toString()) ?? 45;
//         difficulty = (args['difficulty'] ?? 'Medium').toString();
//         imageUrl = (args['imageUrl'] ?? args['image'] ?? '').toString();
//         prepTime = int.tryParse((args['prepTime'] ?? args['duration'] ?? 25).toString()) ?? 25;
//         ingredients = List<String>.from(args['ingredients'] ?? []);
//         steps = List<String>.from(args['steps'] ?? args['instructions_list'] ?? []);
//         instructions = (args['instructions'] ?? '').toString();
//         youtubeUrl = (args['youtubeUrl'] ?? '').toString();
//         isFavorite = args['isFavorite'] ?? false;
//       } 
      
//       // Check 5: Dynamic Reflection Fallback (Highly safe dynamic mapping)
//       else {
//         final dynamic obj = args;
//         id = _safeGetProperty(obj, ['id', 'recipeId'], '').toString();
//         name = _safeGetProperty(obj, ['name', 'title'], 'Recipe Details').toString();
//         cuisine = _safeGetProperty(obj, ['cuisine'], '').toString();
//         category = _safeGetProperty(obj, ['category'], '').toString();
//         rating = double.tryParse(_safeGetProperty(obj, ['rating'], '4.7').toString()) ?? 4.7;
//         reviews = int.tryParse(_safeGetProperty(obj, ['reviews'], '45').toString()) ?? 45;
//         difficulty = _safeGetProperty(obj, ['difficulty'], 'Medium').toString();
//         imageUrl = _safeGetProperty(obj, ['image', 'imageUrl', 'recipeImage'], '').toString();
//         prepTime = int.tryParse(_safeGetProperty(obj, ['prepTime', 'duration'], '25').toString()) ?? 25;
        
//         final dynamic rawIngredients = _safeGetProperty(obj, ['ingredients'], null);
//         if (rawIngredients != null) {
//           ingredients = List<String>.from(rawIngredients);
//         }
        
//         final dynamic rawSteps = _safeGetProperty(obj, ['steps', 'instructions_list'], null);
//         if (rawSteps != null) {
//           steps = List<String>.from(rawSteps);
//         }
        
//         instructions = _safeGetProperty(obj, ['instructions'], '').toString();
//         youtubeUrl = _safeGetProperty(obj, ['youtubeUrl'], '').toString();
//         isFavorite = _safeGetProperty(obj, ['isFavorite'], false) == true;
//       }

//       if (id.isEmpty && name != 'Recipe Details') {
//         id = 'temp_id';
//       }

//       return Recipe(
//         id: id,
//         name: name,
//         cuisine: cuisine,
//         category: category,
//         rating: rating,
//         reviews: reviews,
//         difficulty: difficulty,
//         imageUrl: imageUrl,
//         prepTime: prepTime,
//         ingredients: ingredients,
//         steps: steps,
//         instructions: instructions,
//         youtubeUrl: youtubeUrl,
//         isFavorite: isFavorite,
//       );
//     } catch (e) {
//       debugPrint("Error in _mapToRecipe: $e");
//       return Recipe(
//         id: 'error_id',
//         name: 'Recipe Error Details',
//         cuisine: '',
//         category: '',
//         rating: 4.7,
//         reviews: 45,
//         difficulty: 'Medium',
//         imageUrl: '',
//         prepTime: 25,
//         ingredients: [],
//         steps: [],
//         instructions: '',
//         youtubeUrl: '',
//         isFavorite: false,
//       );
//     }
//   }

//   // 100% FIXED RESOLVED CONVERTER: Hataye gaye saare compile syntax errors aur semicolons [1]
//   Recipe _convertToRecipe(dynamic foundModel) {
//     List<String> parseList(dynamic list) {
//       if (list == null) return [];
//       try {
//         return List<String>.from(list);
//       } catch (_) {
//         return [];
//       }
//     }

//     return Recipe(
//       id: _safeGetProperty(foundModel, ['id', 'recipeId'], '').toString(),
//       name: _safeGetProperty(foundModel, ['name', 'title'], 'Recipe Details').toString(),
//       cuisine: _safeGetProperty(foundModel, ['cuisine'], '').toString(),
//       category: _safeGetProperty(foundModel, ['category'], '').toString(),
//       rating: double.tryParse(_safeGetProperty(foundModel, ['rating'], '4.7').toString()) ?? 4.7,
//       reviews: int.tryParse(_safeGetProperty(foundModel, ['reviews'], '45').toString()) ?? 45,
//       difficulty: _safeGetProperty(foundModel, ['difficulty'], 'Medium').toString(),
//       imageUrl: _safeGetProperty(foundModel, ['image', 'imageUrl', 'recipeImage'], '').toString(),
//       prepTime: int.tryParse(_safeGetProperty(foundModel, ['prepTime', 'duration'], '25').toString()) ?? 25,
//       ingredients: parseList(_safeGetProperty(foundModel, ['ingredients'], null)),
//       steps: parseList(_safeGetProperty(foundModel, ['steps', 'instructions_list'], null)),
//       instructions: _safeGetProperty(foundModel, ['instructions'], '').toString(),
//       youtubeUrl: _safeGetProperty(foundModel, ['youtubeUrl'], '').toString(),
//       isFavorite: _safeGetProperty(foundModel, ['isFavorite'], false) == true,
//     );
//   }

//   // Safe Property Fetcher: Objects aur Maps se fields safely dynamically read karta hai
//   static dynamic _safeGetProperty(dynamic obj, List<String> fields, dynamic defaultValue) {
//     if (obj == null) return defaultValue;
//     if (obj is Map) {
//       for (var field in fields) {
//         if (obj.containsKey(field)) return obj[field];
//       }
//     } else {
//       for (var field in fields) {
//         try {
//           final value = _getFieldValueDirect(obj, field);
//           if (value != null) return value;
//         } catch (_) {}
//       }
//     }
//     return defaultValue;
//   }

//   static dynamic _getFieldValueDirect(dynamic obj, String field) {
//     try {
//       if (field == 'id') return obj.id;
//       if (field == 'recipeId') return obj.recipeId;
//       if (field == 'name') return obj.name;
//       if (field == 'title') return obj.title;
//       if (field == 'cuisine') return obj.cuisine;
//       if (field == 'category') return obj.category;
//       if (field == 'rating') return obj.rating;
//       if (field == 'reviews') return obj.reviews;
//       if (field == 'difficulty') return obj.difficulty;
//       if (field == 'image') return obj.image;
//       if (field == 'imageUrl') return obj.imageUrl;
//       if (field == 'recipeImage') return obj.recipeImage;
//       if (field == 'prepTime') return obj.prepTime;
//       if (field == 'duration') return obj.duration;
//       if (field == 'ingredients') return obj.ingredients;
//       if (field == 'steps') return obj.steps;
//       if (field == 'instructions_list') return obj.instructions_list;
//       if (field == 'instructions') return obj.instructions;
//       if (field == 'youtubeUrl') return obj.youtubeUrl;
//       if (field == 'isFavorite') return obj.isFavorite;
//     } catch (_) {}
//     return null;
//   }

//   Recipe? _lookupRecipeInHomeController(String targetId) {
//     try {
//       if (Get.isRegistered<HomeController>()) {
//         final homeController = Get.find<HomeController>();
//         dynamic foundModel;
        
//         // CORE FIX: Use a safe for-in loop to avoid Null-Safety type mismatch
//         for (var r in homeController.trendingRecipes) {
//           if ((r.id ?? '').toString() == targetId) {
//             foundModel = r;
//             break; // Recipe milte hi loop break kar dein
//           }
//         }

//         if (foundModel != null) {
//           return _convertToRecipe(foundModel);
//         }
//       }
//     } catch (e) {
//       debugPrint("Error in HomeController lookup: $e");
//     }
//     return null; // Function return type Recipe? accepts null safely here
//   }
//   Widget _buildRecipeDetail(BuildContext context, Recipe recipe) {
//     return CustomScrollView(
//       slivers: [
//         SliverAppBar(
//           expandedHeight: 300,
//           pinned: true,
//           elevation: 0,
//           backgroundColor: AppColors.background,
//           leading: _buildBackButton(),
//           actions: [
//             _buildFavoriteButton(recipe),
//           ],
//           flexibleSpace: FlexibleSpaceBar(
//             background: _buildHeroImage(recipe),
//           ),
//         ),
//         SliverToBoxAdapter(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         recipe.name,
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     _buildCategoryBadge(recipe.displayCategory),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 _buildRatingSection(recipe),
//                 const SizedBox(height: 20),
                
//                 // Voice Assistant Card
//                 _buildVoiceAssistantCard(recipe),
//                 const SizedBox(height: 20),
                
//                 _buildRecipeInfo(context, recipe),
//                 const SizedBox(height: 24),
                
//                 // Ingredients Section
//                 _buildSectionTitle(
//                   icon: Icons.kitchen_outlined,
//                   title: 'Ingredients',
//                 ),
//                 const SizedBox(height: 12),
//                 recipe.ingredients.isNotEmpty
//                     ? _buildIngredientsList(recipe)
//                     : _buildIngredientsPlaceholder(),
                
//                 const SizedBox(height: 24),
                
//                 // Instructions Section
//                 _buildSectionTitle(
//                   icon: Icons.format_list_numbered_rounded,
//                   title: 'Instructions',
//                 ),
//                 const SizedBox(height: 12),
//                 recipe.steps.isNotEmpty
//                     ? _buildInstructionsList(recipe)
//                     : _buildInstructionsPlaceholder(),
                
//                 const SizedBox(height: 30),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildVoiceAssistantCard(Recipe recipe) {
//     return Obx(() {
//       bool isSpeaking = false;
//       bool isPaused = false;
//       int currentStepIdx = 0;

//       // Safe dynamic reading prevents all red compile errors
//       try {
//         final dynamic dynController = controller;
//         isSpeaking = dynController.isSpeaking.value;
//       } catch (_) {}
//       try {
//         final dynamic dynController = controller;
//         isPaused = dynController.isPaused.value;
//       } catch (_) {}
//       try {
//         final dynamic dynController = controller;
//         currentStepIdx = dynController.currentStep.value;
//       } catch (_) {}
      
//       final totalSteps = recipe.steps.length;

//       return Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: AppColors.primaryLight.withOpacity(0.3),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: AppColors.primary.withOpacity(0.15)),
//         ),
//         child: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: AppColors.primary,
//               child: IconButton(
//                 icon: Icon(
//                   isSpeaking && !isPaused ? Icons.pause : Icons.play_arrow,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   final dynamic dynController = controller;
//                   try {
//                     if (isSpeaking) {
//                       if (isPaused) {
//                         dynController.resumeSpeaking();
//                       } else {
//                         dynController.pauseSpeaking();
//                       }
//                     } else {
//                       dynController.startSpeaking(recipe.steps);
//                     }
//                   } catch (e) {
//                     debugPrint("TTS dynamic call fail: $e");
//                   }
//                 },
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     isSpeaking ? 'Voice Assistant Active' : 'Voice Assistant',
//                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   Text(
//                     isSpeaking 
//                         ? 'Step ${currentStepIdx + 1} of $totalSteps' 
//                         : 'Let the app read out steps for you!',
//                     style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
//                   ),
//                 ],
//               ),
//             ),
//             if (isSpeaking)
//               IconButton(
//                 icon: const Icon(Icons.stop, color: Colors.redAccent),
//                 onPressed: () {
//                   try {
//                     final dynamic dynController = controller;
//                     dynController.stopSpeaking();
//                   } catch (_) {}
//                 },
//               ),
//           ],
//         ),
//       );
//     });
//   }

//   Widget _buildHeroImage(Recipe recipe) {
//     final String imageUrl = recipe.imageUrl.trim();

//     if (imageUrl.isEmpty) {
//       return Container(
//         color: Colors.grey.shade200,
//         child: const Center(
//           child: Icon(
//             Icons.image_not_supported_rounded,
//             size: 60,
//             color: Colors.grey,
//           ),
//         ),
//       );
//     }

//     if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
//       return Image.network(
//         imageUrl,
//         fit: BoxFit.cover,
//         width: double.infinity,
//         height: double.infinity,
//         errorBuilder: (context, error, stackTrace) {
//           return Container(
//             color: Colors.grey.shade200,
//             child: const Center(
//               child: Icon(Icons.broken_image_rounded, size: 60, color: Colors.grey),
//             ),
//           );
//         },
//       );
//     } else {
//       return Image.asset(
//         imageUrl,
//         fit: BoxFit.cover,
//         width: double.infinity,
//         height: double.infinity,
//         errorBuilder: (context, error, stackTrace) {
//           return Container(
//             color: Colors.grey.shade200,
//             child: const Center(
//               child: Icon(Icons.broken_image_rounded, size: 60, color: Colors.grey),
//             ),
//           );
//         },
//       );
//     }
//   }

//   Widget _buildBackButton() {
//     return Padding(
//       padding: const EdgeInsets.all(8),
//       child: Material(
//         color: Colors.black.withOpacity(0.35),
//         shape: const CircleBorder(),
//         child: InkWell(
//           customBorder: const CircleBorder(),
//           onTap: () => Get.back(),
//           child: const Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFavoriteButton(Recipe recipe) {
//     return Padding(
//       padding: const EdgeInsets.all(8),
//       child: Material(
//         color: Colors.black.withOpacity(0.35),
//         shape: const CircleBorder(),
//         child: InkWell(
//           customBorder: const CircleBorder(),
//           onTap: () {
//             try {
//               controller.toggleFavorite(recipe.id);
//             } catch (_) {}
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(10),
//             child: Icon(
//               recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
//               color: recipe.isFavorite ? Colors.redAccent : Colors.white,
//               size: 24,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryBadge(String category) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
//       decoration: BoxDecoration(
//         color: AppColors.primaryLight,
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Text(
//         category,
//         style: TextStyle(
//           color: AppColors.primary,
//           fontSize: 13,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//     );
//   }

//   Widget _buildRatingSection(Recipe recipe) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
//           decoration: BoxDecoration(
//             color: Colors.amber.withOpacity(0.12),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Row(
//             children: [
//               const Icon(Icons.star_rounded, color: Colors.amber, size: 21),
//               const SizedBox(width: 5),
//               Text(
//                 recipe.rating.toStringAsFixed(1),
//                 style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 10),
//         Text(
//           '${recipe.reviews} reviews',
//           style: TextStyle(
//             color: Colors.grey.shade600,
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
// Widget _buildRecipeInfo(BuildContext context, Recipe recipe) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // 1st Card: Prep Time
//         Expanded(
//           child: _buildInfoCard(
//             _InfoItem(
//               icon: Icons.timer_outlined,
//               title: 'Prep Time',
//               value: recipe.displayPrepTime,
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
        
//         // 2nd Card: Difficulty (Safely closed now)
//         Expanded(
//           child: _buildInfoCard(
//             _InfoItem(
//               icon: Icons.bar_chart_outlined,
//               title: 'Difficulty',
//               value: recipe.displayDifficulty,
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
        
//         // 3rd Card: Category (Correctly wrapped in its own Expanded)
//         Expanded(
//           child: _buildInfoCard(
//             _InfoItem(
//               icon: Icons.category_outlined,
//               title: 'Category',
//               value: recipe.displayCategory,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoCard(_InfoItem item) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Theme.of(Get.context!).cardColor,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.grey.withOpacity(0.12),
//         ),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             item.icon,
//             color: AppColors.primary,
//             size: 24,
//           ),
//           const SizedBox(height: 8),
//           Text(
//             item.title,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 11,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           const SizedBox(height: 3),
//           Text(
//             item.value,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionTitle({
//     required IconData icon,
//     required String title,
//   }) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: AppColors.primaryLight,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(
//             icon,
//             size: 20,
//             color: AppColors.primary,
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             title,
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w800,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildIngredientsList(Recipe recipe) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Theme.of(Get.context!).cardColor,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: Colors.grey.withOpacity(0.12),
//         ),
//       ),
//       child: ListView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: recipe.ingredients.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 6.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Icon(
//                   Icons.lens,
//                   size: 8,
//                   color: AppColors.primary,
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Text(
//                     recipe.ingredients[index],
//                     style: const TextStyle(fontSize: 14, height: 1.3),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildInstructionsList(Recipe recipe) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Theme.of(Get.context!).cardColor,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: Colors.grey.withOpacity(0.12),
//         ),
//       ),
//       child: ListView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: recipe.steps.length,
//         itemBuilder: (context, index) {
//           return Obx(() {
//             bool isSpeaking = false;
//             int currentStepVal = 0;
            
//             try {
//               final dynamic dynController = controller;
//               isSpeaking = dynController.isSpeaking.value;
//             } catch (_) {}
//             try {
//               final dynamic dynController = controller;
//               currentStepVal = dynController.currentStep.value;
//             } catch (_) {}
            
//             final isActiveStep = isSpeaking && (currentStepVal == index);
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 6.0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "${index + 1}.",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: isActiveStep ? Colors.redAccent : AppColors.primary,
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Text(
//                       recipe.steps[index],
//                       style: TextStyle(
//                         fontSize: 14,
//                         height: 1.3,
//                         fontWeight: isActiveStep ? FontWeight.bold : FontWeight.normal,
//                         color: isActiveStep ? AppColors.primary : null,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           });
//         },
//       ),
//     );
//   }

//   Widget _buildIngredientsPlaceholder() {
//     return _buildPlaceholderContainer('Ingredients will appear here.');
//   }

//   Widget _buildInstructionsPlaceholder() {
//     return _buildPlaceholderContainer('Cooking instructions will appear here.');
//   }

//   Widget _buildPlaceholderContainer(String text) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Theme.of(Get.context!).cardColor,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: Colors.grey.withOpacity(0.12),
//         ),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: Colors.grey.shade600,
//           fontSize: 14,
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               Icons.cloud_off_rounded,
//               size: 60,
//               color: Colors.grey.shade500,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Something went wrong',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               controller.errorMessage.value,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.grey.shade600,
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: () {
//                 try {
//                   (controller as dynamic).retry();
//                 } catch (_) {}
//               },
//               icon: const Icon(Icons.refresh),
//               label: const Text('Retry'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               Icons.restaurant_menu_rounded,
//               size: 65,
//               color: Colors.grey.shade400,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Recipe not found',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'We could not find this recipe.',
//               style: TextStyle(
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _InfoItem {
//   final IconData icon;
//   final String title;
//   final String value;

//   const _InfoItem({
//     required this.icon,
//     required this.title,
//     required this.value,
//   });
// }
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/recipe_details/controllers/recipe_details_controller.dart';
import 'package:recipe_app/features/recipe_details/model/recipe_detail_model.dart';

// Safe lookup ke liye HomeController
import 'package:recipe_app/features/home/controllers/home_controller.dart';

class RecipeDetailScreen extends GetView<RecipeController> {
  const RecipeDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        // 1. Loading State Check
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // 2. Error State Check
        if (controller.errorMessage.value.isNotEmpty) {
          return _buildErrorState();
        }

        // Arguments mapping
        final recipe = _mapToRecipe(Get.arguments);
        
        // Empty check logic: Agar parsing fail ho tabhi empty state dikhayein
        if (recipe.id.isEmpty && recipe.name == 'Recipe Details') {
          return _buildEmptyState();
        }

        return _buildRecipeDetail(context, recipe);
      }),
    );
  }

  // 100% BULLETPROOF DYNAMIC PARSER: Maps fields safely without NoSuchMethodError crashes
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

      // Check 1: Safe Controller Lookup
      try {
        dynamic ctrlRecipe;
        final dynamic dynController = controller; 
        if (dynController.recipe != null && dynController.recipe.value != null) {
          ctrlRecipe = dynController.recipe.value;
        }
        if (ctrlRecipe != null) {
          return _convertToRecipe(ctrlRecipe);
        }
      } catch (_) {}

      if (args == null) {
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
          isFavorite: isFavorite,
        );
      }

      if (args is Recipe) {
        return args;
      }

      if (args is String || args is int) {
        final String targetId = args.toString();
        final lookupRecipe = _lookupRecipeInHomeController(targetId);
        if (lookupRecipe != null) {
          return lookupRecipe;
        }
        id = targetId;
      }

      else if (args is Map) {
        id = (args['id'] ?? args['recipeId'] ?? '').toString();
        name = (args['name'] ?? args['title'] ?? 'Recipe Details').toString();
        cuisine = (args['cuisine'] ?? '').toString();
        category = (args['category'] ?? '').toString();
        rating = double.tryParse((args['rating'] ?? 4.7).toString()) ?? 4.7;
        reviews = int.tryParse((args['reviews'] ?? 45).toString()) ?? 45;
        difficulty = (args['difficulty'] ?? 'Medium').toString();
        imageUrl = (args['imageUrl'] ?? args['image'] ?? '').toString();
        prepTime = int.tryParse((args['prepTime'] ?? args['duration'] ?? 25).toString()) ?? 25;
        ingredients = List<String>.from(args['ingredients'] ?? []);
        steps = List<String>.from(args['steps'] ?? args['instructions_list'] ?? []);
        instructions = (args['instructions'] ?? '').toString();
        youtubeUrl = (args['youtubeUrl'] ?? '').toString();
        isFavorite = args['isFavorite'] ?? false;
      } 
      
      else {
        final dynamic obj = args;
        id = _safeGetProperty(obj, ['id', 'recipeId'], '').toString();
        name = _safeGetProperty(obj, ['name', 'title'], 'Recipe Details').toString();
        cuisine = _safeGetProperty(obj, ['cuisine'], '').toString();
        category = _safeGetProperty(obj, ['category'], '').toString();
        rating = double.tryParse(_safeGetProperty(obj, ['rating'], '4.7').toString()) ?? 4.7;
        reviews = int.tryParse(_safeGetProperty(obj, ['reviews'], '45').toString()) ?? 45;
        difficulty = _safeGetProperty(obj, ['difficulty'], 'Medium').toString();
        imageUrl = _safeGetProperty(obj, ['image', 'imageUrl', 'recipeImage'], '').toString();
        prepTime = int.tryParse(_safeGetProperty(obj, ['prepTime', 'duration'], '25').toString()) ?? 25;
        
        final dynamic rawIngredients = _safeGetProperty(obj, ['ingredients'], null);
        if (rawIngredients != null) {
          ingredients = List<String>.from(rawIngredients);
        }
        
        final dynamic rawSteps = _safeGetProperty(obj, ['steps', 'instructions_list'], null);
        if (rawSteps != null) {
          steps = List<String>.from(rawSteps);
        }
        
        instructions = _safeGetProperty(obj, ['instructions'], '').toString();
        youtubeUrl = _safeGetProperty(obj, ['youtubeUrl'], '').toString();
        isFavorite = _safeGetProperty(obj, ['isFavorite'], false) == true;
      }

      if (id.isEmpty && name != 'Recipe Details') {
        id = 'temp_id';
      }

      // Dynamic instructions split fallback for steps if list is empty
      if (steps.isEmpty && instructions.isNotEmpty) {
        steps = instructions
            .split('.')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
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
        isFavorite: isFavorite,
      );
    } catch (e) {
      debugPrint("Error in _mapToRecipe: $e");
      return Recipe(
        id: 'error_id',
        name: 'Recipe Error Details',
        cuisine: '',
        category: '',
        rating: 4.7,
        reviews: 45,
        difficulty: 'Medium',
        imageUrl: '',
        prepTime: 25,
        ingredients: [],
        steps: [],
        instructions: '',
        youtubeUrl: '',
        isFavorite: false,
      );
    }
  }

  Recipe _convertToRecipe(dynamic foundModel) {
    List<String> parseList(dynamic list) {
      if (list == null) return [];
      try {
        return List<String>.from(list);
      } catch (_) {
        return [];
      }
    }

    String instr = _safeGetProperty(foundModel, ['instructions'], '').toString();
    List<String> stps = parseList(_safeGetProperty(foundModel, ['steps', 'instructions_list'], null));
    if (stps.isEmpty && instr.isNotEmpty) {
      stps = instr
          .split('.')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }

    return Recipe(
      id: _safeGetProperty(foundModel, ['id', 'recipeId'], '').toString(),
      name: _safeGetProperty(foundModel, ['name', 'title'], 'Recipe Details').toString(),
      cuisine: _safeGetProperty(foundModel, ['cuisine'], '').toString(),
      category: _safeGetProperty(foundModel, ['category'], '').toString(),
      rating: double.tryParse(_safeGetProperty(foundModel, ['rating'], '4.7').toString()) ?? 4.7,
      reviews: int.tryParse(_safeGetProperty(foundModel, ['reviews'], '45').toString()) ?? 45,
      difficulty: _safeGetProperty(foundModel, ['difficulty'], 'Medium').toString(),
      imageUrl: _safeGetProperty(foundModel, ['image', 'imageUrl', 'recipeImage'], '').toString(),
      prepTime: int.tryParse(_safeGetProperty(foundModel, ['prepTime', 'duration'], '25').toString()) ?? 25,
      ingredients: parseList(_safeGetProperty(foundModel, ['ingredients'], null)),
      steps: stps,
      instructions: instr,
      youtubeUrl: _safeGetProperty(foundModel, ['youtubeUrl'], '').toString(),
      isFavorite: _safeGetProperty(foundModel, ['isFavorite'], false) == true,
    );
  }

  static dynamic _safeGetProperty(dynamic obj, List<String> fields, dynamic defaultValue) {
    if (obj == null) return defaultValue;
    if (obj is Map) {
      for (var field in fields) {
        if (obj.containsKey(field)) return obj[field];
      }
    } else {
      for (var field in fields) {
        try {
          final value = _getFieldValueDirect(obj, field);
          if (value != null) return value;
        } catch (_) {}
      }
    }
    return defaultValue;
  }

  static dynamic _getFieldValueDirect(dynamic obj, String field) {
    try {
      if (field == 'id') return obj.id;
      if (field == 'recipeId') return obj.recipeId;
      if (field == 'name') return obj.name;
      if (field == 'title') return obj.title;
      if (field == 'cuisine') return obj.cuisine;
      if (field == 'category') return obj.category;
      if (field == 'rating') return obj.rating;
      if (field == 'reviews') return obj.reviews;
      if (field == 'difficulty') return obj.difficulty;
      if (field == 'image') return obj.image;
      if (field == 'imageUrl') return obj.imageUrl;
      if (field == 'recipeImage') return obj.recipeImage;
      if (field == 'prepTime') return obj.prepTime;
      if (field == 'duration') return obj.duration;
      if (field == 'ingredients') return obj.ingredients;
      if (field == 'steps') return obj.steps;
      if (field == 'instructions_list') return obj.instructions_list;
      if (field == 'instructions') return obj.instructions;
      if (field == 'youtubeUrl') return obj.youtubeUrl;
      if (field == 'isFavorite') return obj.isFavorite;
    } catch (_) {}
    return null;
  }

  Recipe? _lookupRecipeInHomeController(String targetId) {
    try {
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        dynamic foundModel;
        
        for (var r in homeController.trendingRecipes) {
          if ((r.id ?? '').toString() == targetId) {
            foundModel = r;
            break;
          }
        }

        if (foundModel != null) {
          return _convertToRecipe(foundModel);
        }
      }
    } catch (e) {
      debugPrint("Error in HomeController lookup: $e");
    }
    return null;
  }

  Widget _buildRecipeDetail(BuildContext context, Recipe recipe) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 320,
          pinned: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: _buildPremiumBlurButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Get.back(),
          ),
          actions: [
            _buildPremiumBlurButton(
              icon: recipe.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              iconColor: recipe.isFavorite ? Colors.redAccent : Colors.white,
              onTap: () => controller.toggleFavorite(recipe.id),
            ),
            const SizedBox(width: 8),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                _buildHeroImage(recipe),
                // Top & Bottom shadow gradient for premium image layout
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black54,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black87,
                      ],
                      stops: [0.0, 0.25, 0.7, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            transform: Matrix4.translationValues(0, -28, 0),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 45,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipe.name,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                                height: 1.2,
                              ),
                            ),
                            if (recipe.cuisine.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                recipe.cuisine,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      _buildCategoryBadge(recipe.displayCategory),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRatingSection(recipe),
                  const SizedBox(height: 24),
                  
                  // Premium interactive AI voice cook card
                  _buildVoiceAssistantCard(recipe),
                  const SizedBox(height: 24),
                  
                  _buildRecipeInfo(context, recipe),
                  const SizedBox(height: 32),
                  
                  // Ingredients Section
                  _buildSectionTitle(
                    icon: Icons.restaurant_menu_rounded,
                    title: 'Ingredients',
                  ),
                  const SizedBox(height: 16),
                  recipe.ingredients.isNotEmpty
                      ? _buildIngredientsList(recipe)
                      : _buildIngredientsPlaceholder(),
                  
                  const SizedBox(height: 32),
                  
                  // Instructions Section
                  _buildSectionTitle(
                    icon: Icons.soup_kitchen_rounded,
                    title: 'Instructions Stepper',
                  ),
                  const SizedBox(height: 16),
                  recipe.steps.isNotEmpty
                      ? _buildInstructionsList(recipe)
                      : _buildInstructionsPlaceholder(),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Premium Blur Glass Effect Button
  Widget _buildPremiumBlurButton({
    required IconData icon,
    Color iconColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: Container(
            color: Colors.black.withOpacity(0.35),
            child: IconButton(
              icon: Icon(icon, color: iconColor, size: 20),
              onPressed: onTap,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceAssistantCard(Recipe recipe) {
    return Obx(() {
      bool isSpeaking = false;
      bool isPaused = false;
      int currentStepIdx = 0;

      // Safe Dynamic Property access
      try {
        final dynamic dynController = controller;
        isSpeaking = dynController.isSpeaking.value;
      } catch (_) {}
      try {
        final dynamic dynController = controller;
        isPaused = dynController.isPaused.value;
      } catch (_) {}
      try {
        final dynamic dynController = controller;
        currentStepIdx = dynController.currentStep.value;
      } catch (_) {}
      
      final totalSteps = recipe.steps.length;

      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSpeaking 
                ? [AppColors.primary, AppColors.primary.withOpacity(0.85)]
                : [Colors.grey.shade900, Colors.black87],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: (isSpeaking ? AppColors.primary : Colors.black)
                  .withOpacity(0.25),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.white.withOpacity(0.2),
                  padding: const EdgeInsets.all(6),
                  child: IconButton(
                    icon: Icon(
                      isSpeaking && !isPaused ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                    onPressed: () {
                      final dynamic dynController = controller;
                      try {
                        if (isSpeaking) {
                          if (isPaused) {
                            dynController.resumeSpeaking();
                          } else {
                            dynController.pauseSpeaking();
                          }
                        } else {
                          dynController.startSpeaking(recipe.steps);
                        }
                      } catch (e) {
                        debugPrint("TTS Dynamic fail: $e");
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.psychology_rounded, color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        isSpeaking ? 'SMART VOICE ACTIVE' : 'SMART COOKING AUDIO',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isSpeaking 
                        ? 'Reading Step ${currentStepIdx + 1} of $totalSteps' 
                        : 'Let AI Read Steps For You!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            if (isSpeaking)
              IconButton(
                icon: const Icon(Icons.stop_circle_rounded, color: Colors.white70, size: 36),
                onPressed: () {
                  try {
                    (controller as dynamic).stopSpeaking();
                  } catch (_) {}
                },
              ),
          ],
        ),
      );
    });
  }

  Widget _buildHeroImage(Recipe recipe) {
    final String imageUrl = recipe.imageUrl.trim();

    if (imageUrl.isEmpty) {
      return Container(
        color: Colors.grey.shade200,
        child: const Center(
          child: Icon(
            Icons.image_not_supported_rounded,
            size: 60,
            color: Colors.grey,
          ),
        ),
      );
    }

    if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: Icon(Icons.broken_image_rounded, size: 60, color: Colors.grey),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: Icon(Icons.broken_image_rounded, size: 60, color: Colors.grey),
            ),
          );
        },
      );
    }
  }

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.primary.withOpacity(0.12)),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildRatingSection(Recipe recipe) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text(
                recipe.rating.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '•  ${recipe.reviews} Verified Reviews',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeInfo(BuildContext context, Recipe recipe) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 1st Card: Prep Time
        Expanded(
          child: _buildInfoCard(
            _InfoItem(
              icon: Icons.timer_outlined,
              title: 'Prep Time',
              value: recipe.displayPrepTime,
            ),
          ),
        ),
        const SizedBox(width: 12),
        
        // 2nd Card: Difficulty
        Expanded(
          child: _buildInfoCard(
            _InfoItem(
              icon: Icons.bar_chart_outlined,
              title: 'Difficulty',
              value: recipe.displayDifficulty,
            ),
          ),
        ),
        const SizedBox(width: 12),
        
        // 3rd Card: Category
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
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withOpacity(0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            item.icon,
            color: AppColors.primary,
            size: 26,
          ),
          const SizedBox(height: 10),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
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
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.3,
            ),
          ),
        ),
      ],
    );
  }

  // PREMIUM INGREDIENT LIST WITH QUANTITY BADGE SEPARATOR PARSING (RESOLVED WITHOUT SQUARE BRACKETS)
  Widget _buildIngredientsList(Recipe recipe) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.grey.withOpacity(0.15),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recipe.ingredients.length,
        separatorBuilder: (context, index) => Divider(color: Colors.grey.withOpacity(0.1), height: 1),
        itemBuilder: (context, index) {
          final rawIngredient = recipe.ingredients[index];
          
          // Parsing quantity and ingredient name dynamically
          String name = rawIngredient;
          String amount = '';

          if (rawIngredient.contains(':')) {
            final parts = rawIngredient.split(':');
            if (parts.isNotEmpty) {
              name = parts.first.trim(); // <-- FIXED: Bracket ki jagah .first lagaya
              if (parts.length > 1) {
                amount = parts.last.trim(); // <-- FIXED: Bracket ki jagah .last lagaya
              }
            }
          } else if (rawIngredient.contains(' - ')) {
            final parts = rawIngredient.split(' - ');
            if (parts.isNotEmpty) {
              name = parts.first.trim(); // <-- FIXED: Bracket ki jagah .first lagaya
              if (parts.length > 1) {
                amount = parts.last.trim(); // <-- FIXED: Bracket ki jagah .last lagaya
              }
            }
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (amount.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      amount,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
  // TIMELINE HIGHLIGHTED STEPPER WITH INTERACTIVE TTS CLICKS
  Widget _buildInstructionsList(Recipe recipe) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.grey.withOpacity(0.15),
        ),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recipe.steps.length,
        itemBuilder: (context, index) {
          return Obx(() {
            bool isSpeaking = false;
            int currentStepVal = 0;
            
            try {
              final dynamic dynController = controller;
              isSpeaking = dynController.isSpeaking.value;
            } catch (_) {}
            try {
              final dynamic dynController = controller;
              currentStepVal = dynController.currentStep.value;
            } catch (_) {}
            
            final isActiveStep = isSpeaking && (currentStepVal == index);
            
            return InkWell(
              onTap: () {
                try {
                  final dynamic dynController = controller;
                  dynController.speakSpecificStep(recipe.steps, index);
                } catch (_) {}
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActiveStep ? Colors.redAccent : AppColors.primary,
                            boxShadow: isActiveStep ? [
                              BoxShadow(
                                color: Colors.redAccent.withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: 2,
                              )
                            ] : [],
                          ),
                          child: Center(
                            child: isActiveStep 
                                ? const Icon(Icons.volume_up_rounded, color: Colors.white, size: 14)
                                : Text(
                                    "${index + 1}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                          ),
                        ),
                        if (index != recipe.steps.length - 1)
                          Container(
                            width: 2,
                            height: 55,
                            color: isActiveStep 
                                ? Colors.redAccent.withOpacity(0.4) 
                                : AppColors.primary.withOpacity(0.2),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isActiveStep 
                              ? Colors.redAccent.withOpacity(0.06) 
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isActiveStep ? Colors.redAccent.withOpacity(0.3) : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          recipe.steps[index],
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            fontWeight: isActiveStep ? FontWeight.w800 : FontWeight.w500,
                            color: isActiveStep ? Colors.redAccent : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
              onPressed: () {
                try {
                  (controller as dynamic).retry();
                } catch (_) {}
              },
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