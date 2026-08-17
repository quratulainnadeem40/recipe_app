import 'package:get/get.dart';

import 'package:recipe_app/features/home/models/recipe_models.dart';
import 'package:recipe_app/features/recipe_details/model/recipe_detail_model.dart';
import 'package:recipe_app/features/recipe_details/repositories/recipe_detail_repository.dart';

class RecipeDetailsController extends GetxController {
  final RecipeDetailsRepository repository;

  RecipeDetailsController({
    required this.repository,
  });

  // =========================================================
  // RECIPE DETAILS
  // =========================================================

  final Rxn<RecipeDetailsModel> recipe =
      Rxn<RecipeDetailsModel>();

  // =========================================================
  // UI STATE
  // =========================================================

  final RxBool isLoading = false.obs;

  final RxString errorMessage = ''.obs;

  final RxInt currentImageIndex = 0.obs;

  // =========================================================
  // RECIPE ID
  // =========================================================

  String? recipeId;

  // =========================================================
  // INITIALIZATION
  // =========================================================

  @override
  void onInit() {
    super.onInit();

    _handleArguments();
  }

  // =========================================================
  // HANDLE ROUTE ARGUMENTS
  // =========================================================
  //
  // Supports:
  //
  // 1. RecipeModel
  //    arguments: recipe
  //
  // 2. String
  //    arguments: recipe.id
  //
  // This makes Recipe Details compatible with:
  // Home -> Details
  // Search -> Details
  // Live Suggestions -> Details
  // Favorites -> Details
  // =========================================================

  void _handleArguments() {
    final dynamic arguments = Get.arguments;

    // ---------------------------------------------------------
    // CASE 1: RecipeModel
    // ---------------------------------------------------------

    if (arguments is RecipeModel) {
      final String id = arguments.id.trim();

      if (id.isNotEmpty) {
        recipeId = id;
        getRecipeDetails(id);
      } else {
        errorMessage.value =
            'Recipe ID not found.';
      }

      return;
    }

    // ---------------------------------------------------------
    // CASE 2: String ID
    // ---------------------------------------------------------

    if (arguments is String) {
      final String id = arguments.trim();

      if (id.isNotEmpty) {
        recipeId = id;
        getRecipeDetails(id);
      } else {
        errorMessage.value =
            'Recipe ID not found.';
      }

      return;
    }

    // ---------------------------------------------------------
    // CASE 3: Invalid / Missing arguments
    // ---------------------------------------------------------

    errorMessage.value =
        'Recipe information not found.';
  }

  // =========================================================
  // GET RECIPE DETAILS
  // =========================================================

  Future<void> getRecipeDetails(
    String id,
  ) async {
    final String cleanId = id.trim();

    if (cleanId.isEmpty) {
      recipe.value = null;

      errorMessage.value =
          'Recipe ID not found.';

      return;
    }

    try {
      isLoading.value = true;

      errorMessage.value = '';

      currentImageIndex.value = 0;

      // -------------------------------------------------------
      // LOAD DETAILS FROM API
      // -------------------------------------------------------

      final RecipeDetailsModel result =
          await repository.getRecipeDetails(
        cleanId,
      );

      // -------------------------------------------------------
      // VALIDATE RESPONSE
      // -------------------------------------------------------

      if (result.id.trim().isEmpty) {
        recipe.value = null;

        errorMessage.value =
            'Recipe details not found.';

        return;
      }

      // -------------------------------------------------------
      // SUCCESS
      // -------------------------------------------------------

      recipe.value = result;

      recipeId = result.id.trim();
    } catch (e) {
      recipe.value = null;

      errorMessage.value =
          'Failed to load recipe details.';
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================
  // CHANGE IMAGE
  // =========================================================

  void changeImage(
    int index,
  ) {
    if (index < 0) {
      return;
    }

    currentImageIndex.value = index;
  }

  // =========================================================
  // RETRY
  // =========================================================

  Future<void> retry() async {
    final String? id = recipeId;

    if (id != null && id.trim().isNotEmpty) {
      await getRecipeDetails(id);
      return;
    }

    _handleArguments();
  }

  // =========================================================
  // CLEANUP
  // =========================================================

  @override
  void onClose() {
    recipe.value = null;
    errorMessage.value = '';
    recipeId = null;

    super.onClose();
  }
}