// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:recipe_app/core/theme/app_colors.dart';
// import 'package:recipe_app/features/recipe_details/controllers/recipe_details_controller.dart';

// class RecipeDetailsScreen extends GetView<RecipeDetailsController> {
//   const RecipeDetailsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.lightBackground,

//       // =====================================================
//       // APP BAR
//       // =====================================================

//       appBar: AppBar(
//         backgroundColor: AppColors.lightBackground,
//         elevation: 0,
//         centerTitle: true,

//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: const Icon(
//             Icons.arrow_back_ios_new_rounded,
//             size: 22,
//           ),
//         ),

//         title: const Text(
//           'Recipe Details',
//           style: TextStyle(
//             fontSize: 21,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),

//       // =====================================================
//       // BODY
//       // =====================================================

//       body: Obx(() {
//         // ===================================================
//         // LOADING
//         // ===================================================

//         if (controller.isLoading.value) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         // ===================================================
//         // ERROR
//         // ===================================================

//         if (controller.errorMessage.value.isNotEmpty) {
//           return Center(
//             child: Padding(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(18),
//                     decoration: BoxDecoration(
//                       color: AppColors.primary.withValues(
//                         alpha: 0.10,
//                       ),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.restaurant_rounded,
//                       size: 42,
//                       color: AppColors.primary,
//                     ),
//                   ),

//                   const SizedBox(height: 18),

//                   const Text(
//                     'Unable to load recipe',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   const SizedBox(height: 8),

//                   Text(
//                     controller.errorMessage.value,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       color: Colors.grey,
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   ElevatedButton(
//                     onPressed: controller.retry,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 28,
//                         vertical: 13,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                     ),
//                     child: const Text(
//                       'Try Again',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }

//         // ===================================================
//         // NO DATA
//         // ===================================================

//         final recipe = controller.recipe.value;

//         if (recipe == null) {
//           return const Center(
//             child: Text(
//               'Recipe not found',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           );
//         }

//         // ===================================================
//         // RECIPE CONTENT
//         // ===================================================

//         return SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [

//               // =================================================
//               // HERO IMAGE
//               // =================================================

//               Padding(
//                 padding: const EdgeInsets.fromLTRB(
//                   16,
//                   8,
//                   16,
//                   0,
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(24),
//                   child: SizedBox(
//                     width: double.infinity,
//                     height: 270,
//                     child: Stack(
//                       fit: StackFit.expand,
//                       children: [
//                         Image.network(
//                           recipe.image,
//                           fit: BoxFit.cover,

//                           loadingBuilder: (
//                             context,
//                             child,
//                             loadingProgress,
//                           ) {
//                             if (loadingProgress == null) {
//                               return child;
//                             }

//                             return Container(
//                               color: Colors.grey.shade200,
//                               child: const Center(
//                                 child: CircularProgressIndicator(),
//                               ),
//                             );
//                           },

//                           errorBuilder: (
//                             context,
//                             error,
//                             stackTrace,
//                           ) {
//                             return Container(
//                               color: Colors.grey.shade200,
//                               child: const Center(
//                                 child: Icon(
//                                   Icons.restaurant_rounded,
//                                   size: 65,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),

//                         // Bottom gradient
//                         Positioned(
//                           left: 0,
//                           right: 0,
//                           bottom: 0,
//                           height: 100,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomCenter,
//                                 colors: [
//                                   Colors.transparent,
//                                   Colors.black.withValues(
//                                     alpha: 0.55,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),

//                         // Favorite button
//                         Positioned(
//                           top: 14,
//                           right: 14,
//                           child: Material(
//                             color: Colors.white.withValues(
//                               alpha: 0.92,
//                             ),
//                             shape: const CircleBorder(),
//                             child: IconButton(
//                               onPressed: () {},
//                               icon: const Icon(
//                                 Icons.favorite_border_rounded,
//                                 color: AppColors.primary,
//                               ),
//                             ),
//                           ),
//                         ),

//                         // Image label
//                         Positioned(
//                           left: 18,
//                           bottom: 16,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 7,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.black.withValues(
//                                 alpha: 0.45,
//                               ),
//                               borderRadius:
//                                   BorderRadius.circular(20),
//                             ),
//                             child: const Text(
//                               'Delicious Recipe',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               // =================================================
//               // RECIPE NAME
//               // =================================================

//               Padding(
//                 padding: const EdgeInsets.fromLTRB(
//                   20,
//                   22,
//                   20,
//                   8,
//                 ),
//                 child: Text(
//                   recipe.name,
//                   style: const TextStyle(
//                     fontSize: 30,
//                     height: 1.15,
//                     fontWeight: FontWeight.w800,
//                     color: Color(0xFF2D202B),
//                   ),
//                 ),
//               ),

//               // Small subtitle
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                 ),
//                 child: Text(
//                   'A delicious recipe worth trying',
//                   style: TextStyle(
//                     fontSize: 15,
//                     color: Colors.grey.shade600,
//                     height: 1.4,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 18),

//               // =================================================
//               // CATEGORY + CUISINE
//               // =================================================

//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: _InfoCard(
//                         icon: Icons.restaurant_menu_rounded,
//                         title: 'Category',
//                         value: recipe.category,
//                       ),
//                     ),

//                     const SizedBox(width: 12),

//                     Expanded(
//                       child: _InfoCard(
//                         icon: Icons.public_rounded,
//                         title: 'Cuisine',
//                         value: recipe.area,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 28),

//               // =================================================
//               // INGREDIENTS HEADING
//               // =================================================

//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 5,
//                       height: 27,
//                       decoration: BoxDecoration(
//                         color: AppColors.primary,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),

//                     const SizedBox(width: 10),

//                     const Text(
//                       'Ingredients',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.w800,
//                         color: Color(0xFF2D202B),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 14),

//               // =================================================
//               // INGREDIENT LIST
//               // =================================================

//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                 ),
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(18),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withValues(
//                           alpha: 0.05,
//                         ),
//                         blurRadius: 12,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: List.generate(
//                       recipe.ingredients.length,
//                       (index) {
//                         final String ingredient =
//                             recipe.ingredients[index];

//                         final String measure =
//                             index < recipe.measures.length
//                                 ? recipe.measures[index]
//                                 : '';

//                         return _IngredientItem(
//                           ingredient: ingredient,
//                           measure: measure,
//                           isLast:
//                               index ==
//                               recipe.ingredients.length - 1,
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 30),

//               // =================================================
//               // INSTRUCTIONS HEADING
//               // =================================================

//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 5,
//                       height: 27,
//                       decoration: BoxDecoration(
//                         color: AppColors.orange,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),

//                     const SizedBox(width: 10),

//                     const Text(
//                       'Instructions',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.w800,
//                         color: Color(0xFF2D202B),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 14),

//               // =================================================
//               // INSTRUCTIONS CARD
//               // =================================================

//               Padding(
//                 padding: const EdgeInsets.fromLTRB(
//                   20,
//                   0,
//                   20,
//                   35,
//                 ),
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(18),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withValues(
//                           alpha: 0.05,
//                         ),
//                         blurRadius: 12,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Text(
//                     recipe.instructions,
//                     style: TextStyle(
//                       fontSize: 16,
//                       height: 1.7,
//                       color: Colors.grey.shade800,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

// // =============================================================
// // INFO CARD
// // =============================================================

// class _InfoCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String value;

//   const _InfoCard({
//     required this.icon,
//     required this.title,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: AppColors.primary.withValues(
//           alpha: 0.07,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: AppColors.primary.withValues(
//             alpha: 0.10,
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: AppColors.primary.withValues(
//                 alpha: 0.12,
//               ),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(
//               icon,
//               size: 21,
//               color: AppColors.primary,
//             ),
//           ),

//           const SizedBox(width: 10),

//           Expanded(
//             child: Column(
//               crossAxisAlignment:
//                   CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey.shade600,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),

//                 const SizedBox(height: 3),

//                 Text(
//                   value.isEmpty
//                       ? 'Not available'
//                       : value,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFF2D202B),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // =============================================================
// // INGREDIENT ITEM
// // =============================================================

// class _IngredientItem extends StatelessWidget {
//   final String ingredient;
//   final String measure;
//   final bool isLast;

//   const _IngredientItem({
//     required this.ingredient,
//     required this.measure,
//     required this.isLast,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: isLast ? 0 : 14,
//       ),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment:
//                 CrossAxisAlignment.center,
//             children: [
//               Container(
//                 width: 34,
//                 height: 34,
//                 decoration: BoxDecoration(
//                   color: AppColors.primary.withValues(
//                     alpha: 0.10,
//                   ),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.check_rounded,
//                   size: 19,
//                   color: AppColors.primary,
//                 ),
//               ),

//               const SizedBox(width: 12),

//               Expanded(
//                 child: Text(
//                   ingredient,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF30242E),
//                   ),
//                 ),
//               ),

//               if (measure.isNotEmpty)
//                 Flexible(
//                   child: Text(
//                     measure,
//                     textAlign: TextAlign.right,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade600,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//             ],
//           ),

//           if (!isLast) ...[
//             const SizedBox(height: 14),

//             Divider(
//               height: 1,
//               color: Colors.grey.shade200,
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/recipe_details/controllers/recipe_details_controller.dart';

class RecipeDetailsScreen extends GetView<RecipeDetailsController> {
  const RecipeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,

      // =====================================================
      // APP BAR
      // =====================================================

      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 22,
          ),
        ),
        title: const Text(
          'Recipe Details',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // =====================================================
      // BODY
      // =====================================================

      body: Obx(() {
        // ===================================================
        // LOADING
        // ===================================================

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // ===================================================
        // ERROR
        // ===================================================

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(
                        alpha: 0.10,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.restaurant_rounded,
                      size: 42,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Unable to load recipe',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: controller.retry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // ===================================================
        // NO DATA
        // ===================================================

        final recipe = controller.recipe.value;

        if (recipe == null) {
          return const Center(
            child: Text(
              'Recipe not found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        // ===================================================
        // IMAGE LIST
        // ===================================================

        final List<String> images = recipe.images.isNotEmpty
            ? recipe.images
            : recipe.image.isNotEmpty
                ? [recipe.image]
                : [];

        // ===================================================
        // RECIPE CONTENT
        // ===================================================

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =================================================
              // IMAGE GALLERY
              // =================================================

              if (images.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    8,
                    16,
                    0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 270,
                      child: Stack(
                        children: [
                          PageView.builder(
                            itemCount: images.length,
                            onPageChanged:
                                controller.changeImage,
                            itemBuilder: (
                              context,
                              index,
                            ) {
                              return _RecipeImage(
                                imageUrl: images[index],
                              );
                            },
                          ),

                          // ---------------------------------------
                          // FAVORITE BUTTON
                          // ---------------------------------------

                          Positioned(
                            top: 14,
                            right: 14,
                            child: Material(
                              color: Colors.white.withValues(
                                alpha: 0.92,
                              ),
                              shape: const CircleBorder(),
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.favorite_border_rounded,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),

                          // ---------------------------------------
                          // IMAGE LABEL
                          // ---------------------------------------

                          Positioned(
                            left: 18,
                            bottom: 16,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(
                                  alpha: 0.45,
                                ),
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Delicious Recipe',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                _EmptyImage(),

              // =================================================
              // IMAGE INDICATORS
              // =================================================

              if (images.length > 1)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Obx(() {
                    final int currentIndex =
                        controller.currentImageIndex.value;

                    return Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: List.generate(
                        images.length,
                        (index) {
                          return _PageDot(
                            isActive:
                                currentIndex == index,
                          );
                        },
                      ),
                    );
                  }),
                ),

              // =================================================
              // RECIPE NAME
              // =================================================

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  22,
                  20,
                  8,
                ),
                child: Text(
                  recipe.name,
                  style: const TextStyle(
                    fontSize: 30,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D202B),
                  ),
                ),
              ),

              // =================================================
              // SUBTITLE
              // =================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Text(
                  'A delicious recipe worth trying',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // =================================================
              // CATEGORY + CUISINE
              // =================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        icon:
                            Icons.restaurant_menu_rounded,
                        title: 'Category',
                        value: recipe.category,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _InfoCard(
                        icon: Icons.public_rounded,
                        title: 'Cuisine',
                        value: recipe.area,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // =================================================
              // INGREDIENTS HEADING
              // =================================================

              _SectionHeading(
                title: 'Ingredients',
                color: AppColors.primary,
              ),

              const SizedBox(height: 14),

              // =================================================
              // INGREDIENT LIST
              // =================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.05,
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: List.generate(
                      recipe.ingredients.length,
                      (index) {
                        final String ingredient =
                            recipe.ingredients[index];

                        final String measure =
                            index < recipe.measures.length
                                ? recipe.measures[index]
                                : '';

                        return _IngredientItem(
                          ingredient: ingredient,
                          measure: measure,
                          isLast:
                              index ==
                              recipe.ingredients.length - 1,
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // =================================================
              // INSTRUCTIONS HEADING
              // =================================================

              _SectionHeading(
                title: 'Instructions',
                color: AppColors.orange,
              ),

              const SizedBox(height: 14),

              // =================================================
              // INSTRUCTIONS
              // =================================================

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  35,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.05,
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    recipe.instructions,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.7,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
}

// =============================================================
// RECIPE IMAGE
// =============================================================

class _RecipeImage extends StatelessWidget {
  final String imageUrl;

  const _RecipeImage({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          imageUrl,
          fit: BoxFit.cover,

          loadingBuilder: (
            context,
            child,
            loadingProgress,
          ) {
            if (loadingProgress == null) {
              return child;
            }

            return Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },

          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            return Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: Icon(
                  Icons.restaurant_rounded,
                  size: 65,
                  color: Colors.grey,
                ),
              ),
            );
          },
        ),

        // Bottom gradient
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 100,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(
                    alpha: 0.55,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================
// EMPTY IMAGE
// =============================================================

class _EmptyImage extends StatelessWidget {
  const _EmptyImage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          height: 270,
          color: Colors.grey.shade200,
          child: const Center(
            child: Icon(
              Icons.restaurant_rounded,
              size: 65,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================
// SECTION HEADING
// =============================================================

class _SectionHeading extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionHeading({
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 27,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(width: 10),

          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D202B),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// INFO CARD
// =============================================================

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(
          alpha: 0.07,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(
            alpha: 0.10,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(
                alpha: 0.12,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 21,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value.isEmpty
                      ? 'Not available'
                      : value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D202B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// INGREDIENT ITEM
// =============================================================

class _IngredientItem extends StatelessWidget {
  final String ingredient;
  final String measure;
  final bool isLast;

  const _IngredientItem({
    required this.ingredient,
    required this.measure,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? 0 : 14,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(
                    alpha: 0.10,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 19,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  ingredient,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF30242E),
                  ),
                ),
              ),

              if (measure.isNotEmpty)
                Flexible(
                  child: Text(
                    measure,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),

          if (!isLast) ...[
            const SizedBox(height: 14),

            Divider(
              height: 1,
              color: Colors.grey.shade200,
            ),
          ],
        ],
      ),
    );
  }
}

// =============================================================
// PAGE DOT
// =============================================================

class _PageDot extends StatelessWidget {
  final bool isActive;

  const _PageDot({
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isActive ? 20 : 7,
      height: 7,
      margin: const EdgeInsets.symmetric(
        horizontal: 3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isActive
            ? AppColors.primary
            : Colors.grey.shade400,
      ),
    );
  }
}